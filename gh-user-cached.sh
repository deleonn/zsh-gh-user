#!/usr/bin/env bash
#
# Usage: By default, this script will store its cache in 
# "$XDG_CACHE_HOME/gh_user_cache" (or "$HOME/.cache/gh_user_cache") 
# and treat any cache younger than 300 seconds (=5 minutes) as valid.
#
# You can override:
#   - GH_CACHE_FILE    : full path to cache file
#   - GH_CACHE_TTL     : maximum age of cache in seconds
#
# Example:
#   GH_CACHE_TTL=60 ~/bin/gh‐user‐cached.sh
#

# ─── CONFIGURATION ──────────────────────────────────────────────────

# Where to keep the cache. Default: XDG_CACHE_HOME or ~/.cache
: "${GH_CACHE_FILE:="${XDG_CACHE_HOME:-"$HOME/.cache"}/gh_user_cache"}"

# How many seconds until we consider the cache “stale”. Default: 300 (5 minutes)
: "${GH_CACHE_TTL:=300}"

# ────────────────────────────────────────────────────────────────────

# Ensure the cache directory exists
cache_dir="$(dirname "$GH_CACHE_FILE")"
if [[ ! -d "$cache_dir" ]]; then
  mkdir -p "$cache_dir" 2>/dev/null || {
    echo "Error: cannot create cache directory '$cache_dir'." >&2
    exit 1
  }
fi

# If the cache file exists, check its modification time:
if [[ -f "$GH_CACHE_FILE" ]]; then
  # stat -c %Y gives "modification time as seconds since epoch" on Linux.
  # (If you need to run this on macOS, you could switch to: `stat -f %m "$GH_CACHE_FILE"`.)
  last_mod=$(stat -c %Y "$GH_CACHE_FILE" 2>/dev/null)
  now_ts=$(date +%s)

  if [[ -n "$last_mod" ]] && (( now_ts - last_mod < GH_CACHE_TTL )); then
    # Cache is fresh: just print and exit
    cat "$GH_CACHE_FILE"
    exit 0
  fi
fi

user=$(
  gh auth status 2>/dev/null | awk '
    /Logged in to .* account/ {
      user = $7
    }
    /Active account: true/ {
      print user
      exit
    }
    END {
      if (!user) {
        print "Sign in"
      }
    }
  '
)

if ! printf "%s\n" "$user" > "$GH_CACHE_FILE" 2>/dev/null; then
  echo "Warning: could not write to cache file '$GH_CACHE_FILE'." >&2
fi

echo "$user"

exit 0


