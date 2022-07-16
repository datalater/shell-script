#!/bin/bash

# {{{ specifications }}}
: '
지원하는 기능
- 새롭게 추가된 md 파일을 로그에 추가합니다.

지원되지 않는 기능
- 삭제된 md 파일을 추적하지 않습니다.
- 수정된 md 파일을 추적하지 않습니다.
'

# {{{ output example }}}
: '
❯ source main.sh README.md

✅ Added files:
- docs/echo.md

✅ Successfully inserted log area: 📜 LOG

✅ Inserting rows:
| 2022-07-16 | echo | [docs/echo.md](./docs/echo.md) |
'

source ./colors.sh

echo_bred() {
  echo >&2 "\n${BRED}$1${NC}"
}

echo_bgreen() {
  echo >&2 "\n✅ ${BGREEN}$1${NC}"
}

echo_bpurple() {
  echo >&2 "\n🟣 ${BPURPLE}$1${NC}"
}

echo_byellow() {
  echo >&2 "\n🟡 ${BYELLOW}$1${NC}"
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
  echo_bgreen "Added files:"
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
| --- | --- | --- | <!-- DELIMITER LINE -->

<!-- LOG ENDS -->
EOF
}

find_pattern_line() {
  local pattern=$1
  local filename=$2

  line=$(grep -n "$pattern" "$filename" | awk -F: '{print $1}')
  echo "$line"
}

# make_row
#
# 필수 요건: row를 만들려면 새로 추가된 diff 파일의 첫번째 라인이 '# '로 시작해야 합니다.
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
      echo_byellow "Skipping already logged file: $filename"
      return 1;
    fi

    row="| $last_modified | $article | [$filename](./$filename) |"
    echo "$row"
  fi
}

# make_rows
#
# unused: 현재 함수로 호출하면 정상 동작되지 않아 함수 바디를 복사 붙여넣기 해서 main에서 사용하고 있습니다.
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

# insert_rows
#
# Log area에서 DELIMITER LINE의 다음 라인에 새로운 row를 추가합니다.
# 최근에 작성한 문서가 오름차순으로 나오도록 항상 DELMITER LINE의 다음 라인에 추가합니다.
insert_rows() {
  local log_file=$1
  local log_title=$2
  local rows=$3

  # delimiter_line을 기준으로 기존 콘텐츠를 위아래로 나눈다고 했을 때
  #
  # ```
  # previous_content <!-- DELIMITER LINE -->
  # next_content
  # ```
  #
  # previous_content와 next_content 사이에 새로운 row를 추가합니다
  delimiter_line=$(find_pattern_line "<!-- DELIMITER LINE -->" "$log_file")

  total_line=$(wc -l "$log_file" | awk '{print $1}')
  previous_content=$(head -n $delimiter_line "$log_file")
  next_content=$(tail -n $(($total_line - $delimiter_line)) "$log_file")
  
  cat > "$log_file" <<- EOF
$previous_content
$rows
$next_content
EOF
}

# {{{ main }}}

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
  echo_byellow "Log area already exists: 📜 LOG from L${start_line} to L${end_line} in ${LOG_FILE}"
fi

# make_rows 함수 본문
local log_file=$LOG_FILE
local diff_files=$DIFF_FILES

local rows=""
local newline=$'\n'

while IFS= read -r filename; do
  row=$(make_row "$filename" "$log_file")
  if [[ ! -z $row ]]; then
    rows+=${row}${newline}
  fi
done <<< "$(echo "$diff_files")" # `echo $DIFF_FILES` will run in a subshell.

if [[ -z $rows ]]; then
  echo_bred 'No rows to insert'
else 
  # row를 append할 때 마지막에 추가된 newline 제거
  rows=${rows%${newline}}

  echo_bgreen 'Inserting rows:'
  echo "$rows"
  insert_rows "$LOG_FILE" "$LOG_TITLE" "$rows"
fi

