#!/bin/bash

source ./colors.sh

echo_bred() {
  echo "\n${BRED}$1${NC}"
}

echo_bgreen() {
  echo "\n${BGREEN}$1${NC}"
}

echo_bpurple() {
  echo "\n${BPURPLE}$1${NC}"
}

echo_byellow() {
  echo "\n${BYELLOW}$1${NC}"
}

validate_argument() {
  if [ -z "$1" ]; then
    echo_bred "No argument supplied"
    echo "\nUsage: sh $0 <filename>"
    exit 1
  fi
}

get_diff_files() {
  # Only Added(A) files in git (Not modified files)
  # Because this script will be executed after files are added to the git repo.
  files=$(git diff --cached --name-only --diff-filter=A)
  echo "$files"
}

print_files() {
  echo_bpurple "Added files:"
  echo "$1" | while IFS= read -r filename; do 
    if ! [[ -z "$filename" ]]; then
      echo "- $filename"
    fi
  done
}

FILENAME=$1

has_log_area() {
  local log_title="## 📜 LOG"

  alreadyExists=$(grep -Fc "$log_title" "$1")
  # 0 = true, 1 = false
  [[ $alreadyExists -gt 0 ]] && return 0 || return 1
}

insert_log_area() {
  cat >> "$1" <<- EOF

<!-- LOG STARTS -->

## 📜 LOG

| Last modified | Article | Summary |
| --- | --- | --- |

<!-- LOG ENDS -->
EOF
}

find_pattern_line() {
  pattern=$1
  filename=$2

  line=$(grep -n "$pattern" "$filename" | awk -F: '{print $1}')
  echo "$line"
}

make_row() {
  filename=$1
  logfile=$2

  # Skip if not markdown file
  if ! [[ $filename == *.md ]]; then
    return 1
  fi

  # Skip if file is argument file
  if [[ $filename == $2 ]]; then
    return 1
  fi

  headline=$(git blame -L 1,1 $filename)

  echo_bpurple "headline: $headline"
  if ! [[ -z $headline ]]; then
    last_modified=$(git blame $filename | grep -Eo '\b[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}\b' | sort -n | tail -1)
    article=$(echo $headline | awk '{split($0, array, "# "); print array[2]}')

    # Skip if file is already in LOG.md (we will log only the first time the file is added)
    alreadyExists=$(grep -Fc "$article" "$2")

    echo "alreadyExists: $alreadyExists"

    if [[ $alreadyExists -gt 0 ]]; then
      echo "Skipping already existing $article..."
      continue;
    fi

    row="| $last_modified | $article | [$filename](./$filename) |"
    echo "$row"
  fi
}

validate_argument $FILENAME

files=$(get_diff_files)
print_files "$files"

if ! has_log_area "$FILENAME"; then
  insert_log_area "$FILENAME"
  echo_bgreen 'Successfully inserted log area: 📜 LOG'
else 
  log_start=$(find_pattern_line "LOG STARTS" "$FILENAME")
  log_end=$(find_pattern_line "LOG ENDS" "$FILENAME")
  echo_byellow "Log area already exists: 📜 LOG from L${log_start} to L${log_end}"
fi

# make_row "docs/arguments.md" "$FILENAME"
