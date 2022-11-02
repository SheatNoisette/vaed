# vaed
`V-Atto EDitor` or `VAed` for short is a basic text editor written in V.
This application was designed to be the most basic text editor possible,
and is not intended to be a full-featured text editor. This program exists for
the sole purpose of making a simple OS distribution with V-based userland
programs only.

Supports:
- [X] Opening files
- [X] p: print the current line
- [X] d: delete the current line
- [X] a: append text after the current line
- [X] h: print help
- [X] H: Disable human-readable help mode
- [X] c: Edit the current line
- [X] q: quit
- [X] w: write to file
- [X] n: print the current line number and the line itself

Maybe in the future:
- [ ] s: Search for a string
- [ ] Basic QoF Improvements
- [ ] Others ed commands

## Demo
```bash
$ ./vaed
a
This is a line
.
w test.txt
15
q
$ cat test.txt
This is a line
$ ./vaed test.txt
15
n
1    This is a line
c
This is a edited line
w
24
q
```

## Building

You need to have V installed. You can get it from [here](vlang.io).
To build, run `v .` in the directory or alternatively `make` if you have `make`
installed.

## License
This program is licensed under the MIT License. See the [LICENSE](LICENSE) file
for more details.
