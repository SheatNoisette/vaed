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
 * 							   VAED STRUCT FUNCTIONS
 ******************************************************************************/

// Get the current line pointed by the cursor
fn (ctx Vaed_context) get_line() string {
	return ctx.file_buffer[ctx.current_line - 1]
}

// Load a file from the path, store it in the buffer and return the buffer size
fn (mut ctx Vaed_context) load_file(path string) !int {
	if !os.exists(path) {
		println('File does not exist')
		return 0
	}

	file := os.read_lines(path) or {
		println('Could not open file')
		return 0
	}

	ctx.file_buffer = file
	ctx.file_path = path
	ctx.current_line = u32(file.len)
	return ctx.count_chars()
}

// Count the number of chars in the file buffer (including newlines)
fn (ctx Vaed_context) count_chars() int {
	mut count := 0
	for line in ctx.file_buffer {
		count += line.len + 1 // +1 for the newline
	}
	return count
}

// Change current line
fn (mut ctx Vaed_context) change_line(line u32) {
	if line > 0 && line <= u32(ctx.file_buffer.len) {
		ctx.current_line = line
	} else {
		ctx.print_help('Line out of range')
	}
}

// Increment current line
fn (mut ctx Vaed_context) increment_line(value int) {
	if ctx.current_line + u32(value) > 0
		&& ctx.current_line + u32(value) <= u32(ctx.file_buffer.len) {
		ctx.current_line += u32(value)
	} else {
		ctx.print_help('Line out of range increment - Got $value - max {ctx.file_buffer.len}')
	}
}

// Decrement current line
fn (mut ctx Vaed_context) decrement_line(value int) {
	if ctx.current_line - u32(value) > 0
		&& ctx.current_line - u32(value) <= u32(ctx.file_buffer.len) {
		ctx.current_line -= u32(value)
	} else {
		ctx.print_help('Line out of range decrement - Got $value - max {ctx.file_buffer.len}')
	}
}

// Print ? or a verbose help message
fn (ctx Vaed_context) print_help(message string) {
	if ctx.help_mode {
		println(message)
	} else {
		println('?')
	}
}
