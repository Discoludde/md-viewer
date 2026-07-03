# Styled Markdown Preview In The Terminal (`md`)

A small shell function that renders a `.md` file to styled, self-contained HTML with
Pandoc and opens it in your browser. Useful for quickly reading or sharing Markdown
without pushing it anywhere.

**Features:**
- GitHub-like typography, tables, code blocks, and table of contents (TOC)
- Automatic dark/light mode based on the system theme
- Syntax highlighting
- Everything embedded in **one** self-contained HTML file
- Previews are stored in `/tmp/md-preview/` and **cleaned up automatically**

---

## 1. Install Pandoc

```bash
sudo apt install pandoc        # Debian / Ubuntu
# macOS: brew install pandoc
```

> Requires Pandoc **>= 2.19** for `--embed-resources`. Check your version with `pandoc --version`.
> If you have an older Pandoc version, replace `--embed-resources` with `--self-contained` in the function below.

---

## 2. Save The Stylesheet

```bash
mkdir -p ~/.config/pandoc
cat > ~/.config/pandoc/md.css <<'CSS'
:root{--fg:#1f2328;--muted:#59636e;--bg:#fff;--border:#d1d9e0;--accent:#0969da;--code-bg:#f6f8fa;--quote-border:#d0d7de}
@media (prefers-color-scheme:dark){:root{--fg:#e6edf3;--muted:#9198a1;--bg:#0d1117;--border:#30363d;--accent:#4493f8;--code-bg:#161b22;--quote-border:#3d444d}}
html{font-size:16px}
body{color:var(--fg);background:var(--bg);font-family:-apple-system,BlinkMacSystemFont,"Segoe UI","Noto Sans",Helvetica,Arial,sans-serif;line-height:1.6;max-width:900px;margin:0 auto;padding:2.5rem 1.5rem 6rem;word-wrap:break-word}
h1,h2,h3,h4,h5,h6{margin:1.8rem 0 1rem;font-weight:600;line-height:1.25}
h1{font-size:2rem;padding-bottom:.3em;border-bottom:1px solid var(--border)}
h2{font-size:1.5rem;padding-bottom:.3em;border-bottom:1px solid var(--border)}
h3{font-size:1.25rem}h4{font-size:1rem}h5{font-size:.875rem}h6{font-size:.85rem;color:var(--muted)}
p,ul,ol,dl,table,pre,blockquote{margin:0 0 1rem}
a{color:var(--accent);text-decoration:none}a:hover{text-decoration:underline}
strong{font-weight:600}
code,pre,kbd,samp{font-family:ui-monospace,SFMono-Regular,"SF Mono",Menlo,Consolas,"Liberation Mono",monospace;font-size:.875em}
code{background:var(--code-bg);padding:.2em .4em;border-radius:6px}
pre{background:var(--code-bg);padding:1rem;border-radius:8px;overflow:auto;line-height:1.45;border:1px solid var(--border)}
pre code{background:none;padding:0;border:0;font-size:100%}
blockquote{color:var(--muted);border-left:.25em solid var(--quote-border);padding:0 1em}
blockquote>:first-child{margin-top:0}blockquote>:last-child{margin-bottom:0}
table{border-collapse:collapse;display:block;width:max-content;max-width:100%;overflow:auto}
th,td{border:1px solid var(--border);padding:.5rem .9rem}
th{background:var(--code-bg);font-weight:600}
tr:nth-child(2n) td{background:color-mix(in srgb,var(--code-bg) 55%,transparent)}
ul,ol{padding-left:2em}li+li{margin-top:.25em}
hr{height:1px;border:0;background:var(--border);margin:2rem 0}
img{max-width:100%}
nav#TOC{background:var(--code-bg);border:1px solid var(--border);border-radius:8px;padding:1rem 1.25rem;margin-bottom:2rem}
nav#TOC::before{content:"Contents";display:block;font-weight:600;margin-bottom:.5rem}
nav#TOC ul{list-style:none;padding-left:1em}nav#TOC>ul{padding-left:0}nav#TOC li{margin-top:.15em}
CSS
```

---

## 3. Add The Function To `~/.zshrc`

```zsh
# Render Markdown to styled, self-contained HTML and open it in the browser.
# Previews are stored in /tmp/md-preview/ and cleaned up automatically.
md() {
  emulate -L zsh
  local src=$1
  [[ -n $src && -f $src ]] || { print -u2 "usage: md <file.md>"; return 1 }

  local css=${MD_CSS:-$HOME/.config/pandoc/md.css}
  local dir=${TMPDIR:-/tmp}/md-preview
  mkdir -p $dir

  # Delete old previews older than MD_TTL_MIN minutes, default 60.
  find $dir -maxdepth 1 -name '*.html' -mmin +${MD_TTL_MIN:-60} -delete 2>/dev/null

  local out=$dir/${src:t:r}.html            # basename -> the same file is overwritten

  local -a args=(
    --standalone --embed-resources
    --toc --toc-depth=3
    --highlight-style=pygments
    --metadata title=${src:t}
  )
  [[ -f $css ]] && args+=(-c $css)

  pandoc $src $args -o $out || return
  if [[ -n ${BROWSER:-} ]]; then
    $BROWSER $out >/dev/null 2>&1 &!
  elif command -v google-chrome >/dev/null 2>&1; then
    google-chrome $out >/dev/null 2>&1 &!
  else
    xdg-open $out >/dev/null 2>&1 &!
  fi
}

# Optional: delete all previews manually.
md-clean() { rm -f ${TMPDIR:-/tmp}/md-preview/*.html 2>/dev/null }
```

Reload your shell:

```bash
source ~/.zshrc
```

---

## 4. Usage

```bash
md docs/AI_CONTEXT.md      # render and open in the browser
md README.md
MD_TTL_MIN=15 md notes.md  # clean previews older than 15 minutes instead of 60
md-clean                   # delete all previews immediately
```

---

## How Cleanup Works

- All previews are stored in `/tmp/md-preview/`.
- Each file is rendered to `<basename>.html` without a PID, so **the same file is overwritten** and no duplicates are created.
- On every `md` run, previews older than **60 minutes** are deleted. `MD_TTL_MIN` controls this.
- `/tmp` is usually cleared on reboot, so nothing stays around long term.
- Deleting a file that is already open in a browser tab is safe because the HTML is self-contained and already loaded by the browser.

---

## Customize

- **Custom CSS file:** `export MD_CSS=/path/to/my.css` in `~/.zshrc`.
- **Custom browser:** `export BROWSER=google-chrome` in `~/.zshrc` or `~/.bashrc`.
- **Different syntax highlighting style:** replace `--highlight-style=pygments` with for example
  `tango`, `zenburn`, `breezedark`, `espresso`, `kate`, `monochrome` or `haddock`
  (`pandoc --list-highlight-styles`).
- **Bash instead of zsh:** `${src:t:r}` in zsh is equivalent to
  `"$(basename "${src%.*}")"` in bash, and `&!` becomes `& disown`.

---

## Troubleshooting

| Problem | Solution |
|---|---|
| `command not found: pandoc` | Install Pandoc, see step 1. |
| `unrecognized option '--embed-resources'` | Older Pandoc version, replace it with `--self-contained`. |
| Does not open in the browser | Check that `xdg-open` exists with `sudo apt install xdg-utils`; on macOS, replace `xdg-open` with `open`. |
| No styling | Check that `~/.config/pandoc/md.css` exists and that the path is correct. |
