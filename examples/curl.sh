#!/usr/bin/env bash
# App Store API 的 curl 示例：所有能力都发到同一个地址，只换 action 和 params。
# curl examples for the App Store API: every capability uses the same URL; only action and params change.
#
#   export EVERYINFRA_API_KEY=<your API key>
#   bash examples/curl.sh search "habit tracker"
#   bash examples/curl.sh profile <app id>       # search 结果里的 app_id（数字）/ the numeric app_id from a search result
#   bash examples/curl.sh reviews <app id>
set -euo pipefail
: "${EVERYINFRA_API_KEY:?Set EVERYINFRA_API_KEY first: https://everyinfra.com/docs#quickstart}"
action=${1:?"usage: bash examples/curl.sh <search|profile|reviews> <value>"}
value=${2:?"value: a keyword or a numeric app id"}

case "$action" in
  search)            params="{\"keyword\":\"$value\"}" ;;
  profile | reviews) params="{\"app_id\":\"$value\"}" ;;
  *) echo "unknown action: $action (use search, profile or reviews)" >&2; exit 2 ;;
esac

curl -sS -X POST https://api.everyinfra.com/api/v1/social \
  -H "Authorization: Bearer $EVERYINFRA_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"platform\":\"app_store\",\"action\":\"$action\",\"params\":$params}"
echo
