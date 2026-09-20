# PRIME_INDEX_HOLOGRAM_TM.sh

Prime-index hologram TM (`p_n`, Gödel encoding, zeta link).

| Artifact | Role |
|----------|------|
| `PRIME_INDEX_HOLOGRAM_TM.sh` | One-liner (~1209B) |
| `PRIME_INDEX_HOLOGRAM_TM_DAEMON.sh` | Resident loop (default 1s) |
| `.github/workflows/prime-index-hologram-tm.yml` | Actions `*/5` |

```sh
curl -fsSL https://raw.githubusercontent.com/letsgo0226/PRIME_INDEX_HOLOGRAM_TM.sh/main/PRIME_INDEX_HOLOGRAM_TM.sh | bash
nohup bash PRIME_INDEX_HOLOGRAM_TM_DAEMON.sh 1 >> prime_index_hologram_tm_daemon.log 2>&1 &
```

Bound: formal / symbolic only — `RH_proved=false`; not an RH proof.
