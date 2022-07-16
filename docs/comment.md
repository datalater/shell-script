# Comment

## multiline comment

```sh
: '
#!/bin/bash

source ./colors.sh

# inline
echo "${PURPLE}Added files:${NC}"

# function
echo_bred() {
  echo "${BRED}$1${NC}"
}

echo_red "No argument supplied"
'

```

```sh
#!/bin/bash

function validate_argument {
  if [ -z "$1" ]; then
    echo "No argument supplied"
    echo "\nUsage: sh /log.sh <filename>"
    exit 1
  fi
}

validate_argument $1

<<comment
$ sh log.sh README.md
README.md

$ sh log.sh
No argument supplied

Usage: ./log.sh <filename>
comment

```

## 📚 함께 읽기

- [stackoverflow](https://stackoverflow.com/questions/43158140/way-to-create-multiline-comments-in-bash)
