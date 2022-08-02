# Script arguments

## 인자 null 체크

여러 인자에 대한 empty 문자열 체크:

> `[ -n STRING ]`: 문자열 길이가 0이 아니면 true

```sh
if ! [[ -n "$1" && -n "$2" && -n "$3" ]]; then echo "Usage: $0 <arg1> <arg2> <arg3>"; exit 1; fi
```

인자 개수에 대한 체크:

> `$#`: 인자 개수

```sh
! [[ $# -eq 3 ]] && echo "Usage: $0 <arg1> <arg2> <arg3>" && exit 1
```

모든 인자를 하나의 문자열로 합쳐서 empty 문자열 체크:

> `[ -z STRING ]`: 문자열 길이가 0이면 true

```sh
[[ -z "$@" ]] && echo "No args." && exit 1
```

## Basic

The `$@` variable expands to all command-line parameters separated by spaces.

```sh
#!/bin/bash

# $@: 모든 cli 파라미터가 스페이스로 구분자로 연결됩니다
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

## 📚 함께 읽기

- [stackoverflow - bash non null zero check multiple arguments](https://stackoverflow.com/questions/40782394/bash-non-null-non-zero-check-multiple-string-variables)
- [tldp - bash beginner guide: if primary -n, -z 등의 의미](https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html)
- [tldp - bash beginner guide: argument 관련 $#, $@, $\*, $?, $1의 의미](https://tldp.org/LDP/abs/html/internalvariables.html#ARGLIST)
- [shell 실시간 버그 체크](https://www.shellcheck.net/)
