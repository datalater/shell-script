# Comment

## multiline comment

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
