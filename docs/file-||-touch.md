# unless file exists create the file

```sh
# 디렉토리 필요할 경우
dir=/Scripts
mkdir -p $dir

filename=$dir/file.txt
test -f $filename || touch $filename

# 디렉토리 필요 없을 경우
filename=file.txt
test -f $filename || touch $filename
```

## 📚 함께 읽기

[stackexchange](https://unix.stackexchange.com/a/405120)
