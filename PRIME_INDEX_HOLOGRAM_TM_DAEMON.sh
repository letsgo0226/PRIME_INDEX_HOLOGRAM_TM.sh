#!/usr/bin/env bash
# PRIME_INDEX_HOLOGRAM_TM resident loop — default 1s
set -u
INTERVAL="${1:-${PIH_INTERVAL:-1}}"
LOG="${PIH_LOG:-prime_index_hologram_tm_daemon.log}"
DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd || pwd)"
SCRIPT="${PIH_SCRIPT:-$DIR/PRIME_INDEX_HOLOGRAM_TM.sh}"
RAW_URL="https://raw.githubusercontent.com/letsgo0226/PRIME_INDEX_HOLOGRAM_TM.sh/main/PRIME_INDEX_HOLOGRAM_TM.sh"
WORKDIR="${PIH_WORKDIR:-$DIR/run}"
mkdir -p "$WORKDIR"
if [[ ! -f "$SCRIPT" ]]; then
  command -v curl >/dev/null || exit 127
  SCRIPT="${TMPDIR:-/tmp}/PRIME_INDEX_HOLOGRAM_TM.sh"
  curl -fsSL "$RAW_URL" -o "$SCRIPT" || exit 1
fi
command -v python3 >/dev/null || exit 127
echo "{\"daemon\":\"PRIME_INDEX_HOLOGRAM_TM\",\"interval\":$INTERVAL,\"ts\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}" | tee -a "$LOG"
while true; do
  TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  OUT=$(mktemp)
  if (cd "$WORKDIR" && bash "$SCRIPT" >"$OUT" 2>"${OUT}.err"); then
    if python3 - "$OUT" <<'PY'
import json,sys
o=json.load(open(sys.argv[1]))
ex=o.get("exact") or {}
cl=o.get("claims") or {}
ok=(o.get("model")=="PRIME_INDEX_HOLOGRAM_TM"
    and ex.get("float") is False and ex.get("sha") is False
    and cl.get("RH_proved") is False
    and cl.get("exact_integer") is True
    and o.get("ordinal_exact") is True
    and o.get("prime") is True
    and isinstance(o.get("n"), int) and o.get("n")>=1
    and isinstance(o.get("p"), int) and o.get("p")>=2)
sys.exit(0 if ok else 2)
PY
    then echo "{\"ts\":\"$TS\",\"status\":\"pass\"} $(python3 -c 'import json,sys;o=json.load(open(sys.argv[1]));print(json.dumps({"model":o["model"],"n":o["n"],"p":o["p"],"prime":o["prime"],"exact":o.get("exact"),"RH_proved":(o.get("claims") or {}).get("RH_proved")},separators=(",",":")))' "$OUT")" >>"$LOG"
    else echo "{\"ts\":\"$TS\",\"status\":\"assert_fail\"}" >>"$LOG"
    fi
  else echo "{\"ts\":\"$TS\",\"status\":\"run_fail\"}" >>"$LOG"
  fi
  rm -f "$OUT" "${OUT}.err"
  sleep "$INTERVAL"
done
