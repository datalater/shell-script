# Script arguments

## Basic

The `$@` variable expands to all command-line parameters separated by spaces.

```sh
#!/bin/bash

args=("$@")

function validate_argument {
  if [ -z "${args[0]}" ]; then
    echo "No argument supplied"
    echo "\nUsage: ./log.sh <filename>"
    # exit 1
  fi
}

validate_argument

echo $1

<<comment
$ sh log.sh README.md
README.md

$ sh log.sh
No argument supplied

Usage: ./log.sh <filename>
comment
```

> https://stackoverflow.com/q/3811345

## Examples

validate cli arguments

```sh
#!/bin/bash

function validate_argument {
  if [ -z "$1" ]; then
    echo "No argument supplied"
    echo "\nUsage: ./log.sh <filename>"
    # exit 1
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
