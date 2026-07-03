#!/usr/bin/env bash

set -Eeuo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
terraform_dir="${TERRAFORM_DIR:-$script_dir}"
kubeconfig_path="${KUBECONFIG_PATH:-${HOME}/.kube/config}"
talosconfig_path="${TALOSCONFIG:-${HOME}/.talos/config}"
dry_run=false

usage() {
  printf 'Usage: %s [--dry-run] [--terraform-dir DIR] [--kubeconfig PATH] [--talosconfig PATH]\n' "$(basename "$0")"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      dry_run=true
      shift
      ;;
    --terraform-dir)
      terraform_dir="$2"
      shift 2
      ;;
    --kubeconfig)
      kubeconfig_path="$2"
      shift 2
      ;;
    --talosconfig)
      talosconfig_path="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 2
      ;;
  esac
done

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'error: required command not found: %s\n' "$1" >&2
    exit 1
  fi
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

config_names() {
  local kubeconfig="$1"
  local kind="$2"

  kubectl config view \
    --kubeconfig "$kubeconfig" \
    -o "jsonpath={range .$kind[*]}{.name}{'\n'}{end}"
}

talos_contexts() {
  local talosconfig="$1"

  talosctl --talosconfig "$talosconfig" config contexts |
    awk 'NR > 1 && NF { if ($1 == "*") print $2; else print $1 }'
}

install_file() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  chmod 600 "$dest"
}

config_action() {
  local dest="$1"

  if [[ -s "$dest" ]]; then
    printf 'update'
  else
    printf 'create'
  fi
}

remove_kubeconfig_entries() {
  local existing="$1"
  local incoming="$2"
  local kind="$3"
  local delete_command="$4"
  local name

  while IFS= read -r name; do
    [[ -n "$name" ]] || continue
    kubectl config "$delete_command" "$name" --kubeconfig "$existing" >/dev/null 2>&1 || true
  done < <(config_names "$incoming" "$kind")
}

upsert_kubeconfig() {
  local incoming="$1"
  local dest="$2"
  local existing="$tmpdir/kubeconfig-existing"
  local merged="$tmpdir/kubeconfig-merged"

  if [[ ! -s "$dest" ]]; then
    install_file "$incoming" "$dest"
    return
  fi

  cp "$dest" "$existing"
  remove_kubeconfig_entries "$existing" "$incoming" "contexts" "delete-context"
  remove_kubeconfig_entries "$existing" "$incoming" "clusters" "delete-cluster"
  remove_kubeconfig_entries "$existing" "$incoming" "users" "delete-user"

  KUBECONFIG="${existing}:${incoming}" kubectl config view --raw --flatten > "$merged"
  install_file "$merged" "$dest"
}

upsert_talosconfig() {
  local incoming="$1"
  local dest="$2"
  local existing="$tmpdir/talosconfig-existing"
  local context

  if [[ ! -s "$dest" ]]; then
    install_file "$incoming" "$dest"
    return
  fi

  cp "$dest" "$existing"
  while IFS= read -r context; do
    [[ -n "$context" ]] || continue
    talosctl --talosconfig "$existing" config remove "$context" --noconfirm >/dev/null 2>&1 || true
  done < <(talos_contexts "$incoming")

  talosctl --talosconfig "$existing" config merge "$incoming" >/dev/null
  install_file "$existing" "$dest"
}

sync_config() {
  local label="$1"
  local command="$2"
  local output="$3"
  local dest="$4"
  local upsert_fn="$5"
  local incoming="$tmpdir/$label"

  if ! command_exists "$command"; then
    printf 'Skipped %s: %s is not installed\n' "$label" "$command"
    return
  fi

  terraform -chdir="$terraform_dir" output -raw "$output" > "$incoming"
  chmod 600 "$incoming"

  if [[ "$dry_run" == true ]]; then
    printf 'Would %s %s: %s\n' "$(config_action "$dest")" "$label" "$dest"
    return
  fi

  mkdir -p "$(dirname "$dest")"
  "$upsert_fn" "$incoming" "$dest"
  printf 'Updated %s: %s\n' "$label" "$dest"
}

require_command terraform

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

sync_config "kubeconfig" "kubectl" "kubeconfig_raw" "$kubeconfig_path" upsert_kubeconfig
sync_config "talosconfig" "talosctl" "talosconfig" "$talosconfig_path" upsert_talosconfig
