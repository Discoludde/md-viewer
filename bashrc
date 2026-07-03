###Add this to your .bashrc

md() {
  local src=$1
  [[ -n $src && -f $src ]] || { printf '%s\n' "usage: md <file.md>" >&2; return 1; }

  local css=${MD_CSS:-$HOME/.config/pandoc/md.css}
  local dir=${TMPDIR:-/tmp}/md-preview
  mkdir -p "$dir"

  # Delete old previews older than MD_TTL_MIN minutes, default 60.
  find "$dir" -maxdepth 1 -name '*.html' -mmin +"${MD_TTL_MIN:-60}" -delete 2>/dev/null

  local base=${src##*/}
  local out=$dir/${base%.*}.html            # basename -> the same file is overwritten

  local args=(
    --standalone --embed-resources
    --toc --toc-depth=3
    --highlight-style=pygments
    --metadata "title=$base"
  )
  [[ -f $css ]] && args+=(-c "$css")

  pandoc "$src" "${args[@]}" -o "$out" || return
  if [[ -n ${BROWSER:-} ]]; then
    "$BROWSER" "$out" >/dev/null 2>&1 &
  elif command -v google-chrome >/dev/null 2>&1; then
    google-chrome "$out" >/dev/null 2>&1 &
  else
    xdg-open "$out" >/dev/null 2>&1 &
  fi
}
