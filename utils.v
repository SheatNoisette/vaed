module main

/*
MIT License

Copyright (c) 2022 SheatNoisette

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

fn is_number_from_string(s string) bool {
	mut number := s

	if s.len == 0 {
		return false
	}

	if s[0] == `-` || s[0] == `+` {
		number = s[1..]
	} else {
		number = s
	}

	for c in number {
		if c < `0` || c > `9` {
			return false
		}
	}
	return true
}

// Parse the number from the command
fn parse_number(n string) int {
	mut number := n

	if n.len == 0 {
		return 0
	}

	sign := match number[0] {
		`-` { -1 }
		else { 1 }
	}

	if number[0] == `+` || number[0] == `-` {
		number = number[1..]
	}

	return sign * number.int()
}
