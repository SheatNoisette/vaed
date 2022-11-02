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

/*******************************************************************************
 * 							   VAED COMMANDS FUNCTIONS
 ******************************************************************************/

// Handle the "append" / "a" command
fn vaed_handle_append(mut ctx Vaed_context) {
	for {
		line := os.get_line()
		if line == '.' {
			break
		}
		ctx.file_buffer.insert(int(ctx.current_line), line)
		ctx.current_line++
	}
}

// Write the file buffer to the file
fn vaed_handle_write(mut ctx Vaed_context, command_arguments []string) {
	if command_arguments.len > 1 {
		ctx.print_help('Too many arguments')
		return
	} else if command_arguments.len == 1 {
		// We override the file path
		ctx.file_path = command_arguments.join(' ')
	} else if ctx.file_path.len == 0 {
		ctx.print_help('No file loaded, missing arguments')
		return
	}

	file_content := ctx.file_buffer.join('\n') + '\n'
	os.write_file(ctx.file_path, file_content) or { ctx.print_help('Could not write to file') }

	// Print number of bytes written
	println(file_content.len)
}

// Print current line
fn vaed_handle_print(mut ctx Vaed_context) {
	if ctx.current_line == 0 {
		println('No line to print')
		return
	}
	println(ctx.get_line())
}

// Print the line and the line number
fn vaed_handle_print_number(mut ctx Vaed_context) {
	if ctx.current_line == 0 {
		ctx.print_help('No line to print')
		return
	}
	println('$ctx.current_line\t$ctx.get_line()')
}

// Delete a line
fn vaed_handle_delete_line(mut ctx Vaed_context) {
	if ctx.current_line == 0 {
		ctx.print_help('No line to delete')
		return
	}
	ctx.file_buffer.delete(int(ctx.current_line - 1))
	ctx.current_line--
}

// Edit a line
fn vaed_handle_edit_line(mut ctx Vaed_context) {
	if ctx.current_line == 0 {
		ctx.print_help('No line to edit')
		return
	}

	line := os.get_line()
	if line == '.' {
		return
	}
	ctx.file_buffer[int(ctx.current_line - 1)] = line
	ctx.current_line++
	vaed_handle_append(mut ctx)
}

// Increment line pointer
fn vaed_handle_increment_line(mut ctx Vaed_context, value string, command_arguments []string) {
	if value.len == 1 {
		ctx.increment_line(1)
	} else if value.len >= 2 && command_arguments.len == 0 && is_number_from_string(value) {
		ctx.increment_line(parse_number(value))
	} else {
		ctx.print_help('Invalid arguments')
	}
}

// Decrement line pointer
fn vaed_handle_decrement_line(mut ctx Vaed_context, value string, command_arguments []string) {
	if value.len == 1 {
		ctx.decrement_line(1)
	} else if value.len >= 2 && command_arguments.len == 0 && is_number_from_string(value) {
		ctx.decrement_line(-parse_number(value))
	} else {
		ctx.print_help('Invalid arguments')
	}
}
