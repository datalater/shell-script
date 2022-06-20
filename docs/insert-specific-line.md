# Insert specific line

```sh
$ cat File1
Line #1
Line #2
Line #3
Line #4
```

```sh
$ sed '3 i New Line with sed' File1
Line #1
Line #2
New Line with sed
Line #3
Line #4
```

> https://www.baeldung.com/linux/insert-line-specific-line-number
