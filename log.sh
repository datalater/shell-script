#!/bin/sh

# Only Added(A) files in git (Not modified files)
files=$(git diff --cached --name-only --diff-filter=A)

if ! [[ -z "$files" ]]; then
  echo "Added files:"
  echo "$files" | while IFS= read -r filename; do 
    if ! [[ -z "$filename" ]]; then
      echo "- $filename"
    fi
  done
  echo ""
fi

# Create LOG.md if it doesn't exist
if ! [[ -f "LOG.md" ]]; then
cat > LOG.md <<- EOF
# 📜 LOG

| Last modified | Article | Summary |
| --- | --- | --- |
EOF
fi

# Make table rows as looping through files
rows=""
newline=$'\n'

# Use here string to re-write the while loop to be in the main shell process
# Because, in `echo $files | while read line ... done`,
# the while loop is executed in a subshell, so any changes you do to the variable will not be available once the subshell exists.
# Link: https://stackoverflow.com/a/16854326
while IFS= read -r filename; do 
  echo $filename

  # Skip if file is not markdown
  if ! [[ $filename == *.md ]]; then
    continue
  fi

  if [[ $filename == LOG.md || $filename == README.md ]]; then
    continue
  fi

  headline=$(git blame -L 1,1 $filename)

  echo "headline: $headline"
  if ! [[ -z $headline ]]; then
    last_modified=$(git blame $filename | grep -Eo '\b[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}\b' | sort -n | tail -1)
    article=$(echo $headline | awk '{split($0, array, "# "); print array[2]}')

    # Skip if file is already in LOG.md (we will log only the first time the file is added)
    alreadyExists=$(grep -Fc "$article" LOG.md)

    echo "alreadyExists: $alreadyExists"

    if [[ $alreadyExists -gt 0 ]]; then
      echo "Skipping already existing $article..."
      continue;
    fi

    row="| $last_modified | $article | [$filename](./$filename) |"
    rows+=${row}${newline}
  fi
done <<< "$(echo "$files")" # only `echo $files` will run in a subshell.

# Remove last new line for appending new rows next time script is run
rows=${rows%${newline}}

if ! [[ -z $rows ]]; then
  echo "Rows: $rows"
fi

# Append new rows to LOG.md
if ! [[ -z $rows ]]; then
cat >> LOG.md <<- EOF
$rows
EOF

git add LOG.md
fi

# Remove file if LOG file is an initialized default file
lc=$(wc -l LOG.md | awk '{print $1}')
defaultLines=4
if ! [[ $lc -gt $defaultLines ]]; then
  rm LOG.md
fi
