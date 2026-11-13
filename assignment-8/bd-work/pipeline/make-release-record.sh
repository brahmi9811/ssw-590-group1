#!/usr/bin/env bash
# DRAFT (BD): writes releases/<version>-<environment>.yml from the files the pipeline stage wrote in reports/ (metadata only, never credentials).
# Usage (sourced by the Jenkinsfile): . make-release-record.sh; make_release_record staging|production
make_release_record() {
  local env="$1" version commit digest total url
  version="$(cat reports/version.txt)"; commit="$(cat reports/commit.txt)"; digest="$(cat reports/digest.txt)"
  case "$version" in v1) total=30 ;; v2) total=36 ;; *) echo "unknown version $version" >&2; return 1 ;; esac
  case "$env" in
    staging)    url="https://staging.ssw590-g1.tech" ;;
    production) url="https://app.ssw590-g1.tech" ;;
    *) echo "unknown environment $env" >&2; return 1 ;;
  esac
  case "$digest" in *@sha256:*) ;; *) echo "digest is not a repository digest: $digest" >&2; return 1 ;; esac
  mkdir -p releases
  {
    echo "# release record, written by Jenkins build ${BUILD_NUMBER:-local}; metadata only"
    echo "target_env: $env"
    echo "release_image: $digest"
    echo "expected_version: $version"
    echo "expected_commit: $commit"
    echo "expected_total: $total"
    echo "public_url: $url"
    echo "proxy_network: gitea_web"
    [ -f reports/approval.txt ] && [ "$env" = production ] && echo "approval: \"$(tr -d '\n' < reports/approval.txt)\""
  } > "releases/${version}-${env}.yml"
}
