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
  # Only Added(A) DIFF_FILES in git (Not modified DIFF_FILES)
  # Because this script will be executed after DIFF_FILES are added to the git repo.
  diff_files=$(git diff --cached --name-only --diff-filter=A)
  echo "$diff_files"
}

print_files() {
  echo_bpurple "Added files:"
  echo "$1" | while IFS= read -r filename; do 
    if ! [[ -z "$filename" ]]; then
      echo "- $filename"
    fi
  done
}

has_log_area() {
  local log_file=$1
  local log_title=$2

  alreadyExists=$(grep -Fc "$log_title" "$log_file")
  # 0 = true, 1 = false
  [[ $alreadyExists -gt 0 ]] && return 0 || return 1
}

insert_log_area() {
  local log_file=$1
  local log_title=$2

  cat >> "$log_file" <<- EOF

<!-- LOG STARTS -->

$log_title

| Last modified | Article | Summary |
| --- | --- | --- | <!-- TOP LINE -->

<!-- LOG ENDS -->
EOF
}

find_pattern_line() {
  local pattern=$1
  local filename=$2

  line=$(grep -n "$pattern" "$filename" | awk -F: '{print $1}')
  echo "$line"
}

make_row() {
  local filename=$1
  local log_file=$2

  # Skip if not markdown file
  if ! [[ $filename == *.md ]]; then
    return 1
  fi

  # Skip if file is argument file
  if [[ $filename == $log_file ]]; then
    return 1
  fi

  headline=$(git blame -L 1,1 $filename)

  if ! [[ -z $headline ]]; then
    last_modified=$(git blame $filename | grep -Eo '\b[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}\b' | sort -n | tail -1)
    article=$(echo $headline | awk '{split($0, array, "# "); print array[2]}')

    # Skip if file is already in LOG.md (we will log only the first time the file is added)
    alreadyExists=$(grep -Fc "$article" "$2")

    if [[ $alreadyExists -gt 0 ]]; then
      return 1;
    fi

    row="| $last_modified | $article | [$filename](./$filename) |"
    echo "$row"
  fi
}

make_rows() {
  local log_file=$1
  local diff_files=$2

  local rows=""
  local newline=$'\n'

  while IFS= read -r filename; do
    row=$(make_row "$filename" "$log_file")
    rows+=${row}${newline}
  done <<< "$(echo "$diff_files")" # `echo $DIFF_FILES` will run in a subshell.

  echo "$rows"
}

insert_rows() {
  local log_file=$1
  local log_title=$2
  local rows=$3

  top_line=$(find_pattern_line "<!-- TOP LINE -->" "$log_file")
  top_row_line=$(($top_line + 1))

  echo "top_row_line: $top_row_line"

  ### Resume here to insert rows after the top line
  # sed -i'' -e "${top_row_line} i $rows" "$log_file"
}

LOG_FILE=$1
LOG_TITLE="## 📜 LOG"
DIFF_FILES=$(get_diff_files)

validate_argument $LOG_FILE
print_files "$DIFF_FILES"

if ! has_log_area $LOG_FILE $LOG_TITLE; then
  insert_log_area "$LOG_FILE" "$LOG_TITLE"
  echo_bgreen 'Successfully inserted log area: 📜 LOG'
else 
  start_line=$(find_pattern_line "LOG STARTS" $LOG_FILE)
  end_line=$(find_pattern_line "LOG ENDS" $LOG_FILE)
  echo_byellow "Log area already exists: 📜 LOG from L${start_line} to L${end_line}"
fi

rows=$(make_rows "$LOG_FILE" "$DIFF_FILES")
insert_rows "$LOG_FILE" "$LOG_TITLE" "$rows"
