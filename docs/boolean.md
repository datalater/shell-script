# Boolean

- `0`: true
- `1`: false

```sh
#!/bin/bash

isdirectory() {
  if [ -d "$1" ]
  then
    # 0 = true
    return 0
  else
    # 1 = false
    return 1
  fi
}


if isdirectory $1; then echo "is directory"; else echo "nopes"; fi
```
