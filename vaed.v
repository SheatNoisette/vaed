module main

import os

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

struct Vaed_context {
mut:
	// Command feature flags
	help_mode  bool
	quit       bool
	extensions bool
	// File
	file_path string
	// File buffer
	file_buffer  []string
	current_line u32
}

// Parse the command into simple token
// Examples:
// - "a" -> ["a"]
// - "12eee32" -> ["12", "eee", "32"]
// - "-1212zzzz" -> ["-1212", "zzzz"]
fn parse_command(s string) []string {
	mut tokens := []string{}
	mut is_number := false
	mut current_token := ''
	for c in s {
		if ((c >= `0` && c <= `9`) || c == `-` || c == `+`) && !is_number {
			tokens << current_token
			current_token = ''
			is_number = true
		} else if (c < `0` || c > `9`) && is_number {
			tokens << current_token
			current_token = ''
			is_number = false
		}
		current_token += c.ascii_str()
	}

	if current_token.len > 0 {
		tokens << current_token
	}

	return tokens.filter(it.len > 0)
}

// Handle basic commands
fn vaed_prompt(mut ctx Vaed_context) {
	current_line := parse_command(os.get_line())

	// Check if the command is empty
	if current_line.len == 0 {
		ctx.print_help('No command given')
		return
	}

	command := current_line[0]
	command_arguments := current_line[1..]

	// Simples commands
	match command[0] {
		`h` {
			println('Human friendly messages enabled')
			ctx.help_mode = true
		}
		`H` {
			ctx.help_mode = false
		}
		`q` {
			ctx.quit = true
		}
		`a` {
			vaed_handle_append(mut ctx)
		}
		`w` {
			vaed_handle_write(mut ctx, command_arguments)
		}
		`p` {
			vaed_handle_print(mut ctx)
		}
		`n` {
			vaed_handle_print_number(mut ctx)
		}
		`d` {
			vaed_handle_delete_line(mut ctx)
		}
		`c` {
			vaed_handle_edit_line(mut ctx)
		}
		`+` {
			vaed_handle_increment_line(mut ctx, command, command_arguments)
		}
		`-` {
			vaed_handle_decrement_line(mut ctx, command, command_arguments)
		}
		else {

			// +/- are special cases that are handled in the previous match
			// If the command is not a number, the user did something wrong
			if is_number_from_string(command) {
				ctx.change_line(u32(command.int()))
			} else {
				ctx.print_help('Unknown command')
			}
		}
	}
}

fn main() {
	mut vaed_ctx := Vaed_context{
		help_mode: false
		quit: false
		extensions: false
		file_path: ''
		file_buffer: []string{}
		current_line: 0
	}

	if os.args.len == 2 {
		// If the file is not loaded, go to prompt mode
		println(vaed_ctx.load_file(os.args[1])!)
	}

	for vaed_ctx.quit == false {
		vaed_prompt(mut vaed_ctx)
	}
}
