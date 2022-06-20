# function

## 정의하고 호출하기

```bash
#!/bin/bash

function validate_argument {
  if [ -z "$1" ]; then
    echo "You have to pass filename as an argument"
    echo "\nUsage: ./log.sh <filename>"
    exit 1
  fi
}

validate_argument $1
```
