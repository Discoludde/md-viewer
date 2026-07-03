## Run `chmod +x css.sh` to make this script executable, or copy and paste it into your terminal.
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
