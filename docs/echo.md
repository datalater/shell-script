# echo

```sh
make_row() {
  # 함수를 실행하면서 리턴하지는 않고 출력만 하고 싶은 echo
  echo >&2 "Skipping already exisiting file: $filename"

  # 함수가 리턴할 문자열 echo
  echo 'return string'
}

result=$(make_row)
```

> To quickly explain what the others missed:
>
> echo "hey" >&2
>
> `>` redirect standard output (implicit `1>`)
>
> `&` what comes next is a file descriptor, not a file (only for right hand side of >)
>
> `2` stderr file descriptor number
>
> Redirect stdout from echo command to stderr. (If you were to useecho "hey" >2 you would output hey to a file called 2)

## 📚 함께 읽기

- [stackoverflow - echo >&2 meaning](https://stackoverflow.com/questions/23489934/echo-2-some-text-what-does-it-mean-in-shell-scripting)
- [stackoverflow - returning value from called function in shell script](https://stackoverflow.com/a/8743103)
