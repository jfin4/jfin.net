#!/bin/sh

# Microscopic static site generator built around Pandoc. Provides a TOC
# landing page and an arbitrary number of entry pages. Makes assumptions
# about dir structure and markdown files formatting:
#   1. Entry dir names determine TOC sorting and URL slug
#   2. Markdown file names (one per entry) determine html title tags
#   3. First level 1 header in markdown files determines TOC entry name

# define variables -------------------------------------------------------------
entries_dir="$(dirname $0)/content"
# production_dir='/var/www/htdocs/jfin.net'
production_dir="/tmp/jfin.net"
font_size='20px'
banner_text='John Inman'
favicon_text='🐩'
code_bg='#f0f0f0'

# start fresh ------------------------------------------------------------------
rm -rf $production_dir/*

# make favicon -----------------------------------------------------------------
# Write the favicon as a real SVG file (more reliable than
# data URI on iOS/Safari)
cat > "$production_dir/favicon.svg" << EOF
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <text y=".9em" font-size="90">$favicon_text</text>
</svg>
EOF

# Reference the real file + apple-touch-icon for iOS compatibility
cat > /tmp/favicon.h << EOF
<link rel="icon" type="image/svg+xml" href="/favicon.svg">
<link rel="apple-touch-icon" href="/favicon.svg">
EOF

# load google fonts ------------------------------------------------------------
cat > /tmp/googlefonts.h << EOF
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Source+Sans+Pro:wght@400;700&family=Source+Code+Pro&display=swap" rel="stylesheet">
EOF

# configure pandoc -------------------------------------------------------------
my_pandoc() {
  pandoc\
    --standalone\
    --include-in-header=/tmp/favicon.h\
    --include-in-header=/tmp/googlefonts.h\
    --mathjax\
    -V mainfont='Source Sans Pro, sans-serif'\
    -V monofont='Source Code Pro, monospace'\
    -V fontsize=$font_size\
    -V monobackgroundcolor=$code_bg\
    "$@"
    # --math-method=mathjax \ # pandoc >= 3.11
}

# render entries ---------------------------------------------------------------
entries=
# LC_COLLATE=C to sort by (reverse) ascii
for dir in $(ls -dr $entries_dir/*); do
  source=$(ls $dir/*.md 2> /dev/null) 
  [ -f "$source" ] || continue

  date=$(basename $dir)
  mkdir -p $production_dir/$date
  my_pandoc -o $production_dir/$date/index.html "$source"
  
  # only assets targetted in source move to production
  for img in $(sed -n 's/.*!\[.*\](\([^)]*\)).*/\1/p' "$source"); do
    cp $dir/$img $production_dir/$date/
  done

  title=$(sed -n '/^# /{ s/^# //p;q; }' "$source")
  entries="$entries<tr><td>$date</td><td><a href=/$date>$title</a></td></tr>"
done

# make toc ---------------------------------------------------------------------
my_pandoc -f html -o $production_dir/index.html << EOF
<h1>$banner_text</h1>
<table>$entries</table>
EOF
