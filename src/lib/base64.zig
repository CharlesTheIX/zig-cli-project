const mem = std.mem;
const std = @import("std");
const file = @import("./file.zig");
const sc = @import("./helpers/shell-commands.zig");
const b64 = @import("../commands/base64/init.zig");

const Function = enum { Help, Todo, Encode, Decode, Invalid };

pub fn controller(args: []const u8) !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    if (args.len == 0) return try stdout.print("FUNCTION Required: Please use '-help' OR '-h' FUNCTION for HELP with this COMMAND\n", .{});

    var arg_parts = mem.splitSequence(u8, args, " ");
    const function = stringToFunction(arg_parts.first());

    switch (function) {
        .Help => return try help(),
        .Todo => return try todo(),
        .Invalid => return try stdout.print("FUNCTION Required: Please use '-help' OR '-h' FUNCTION for HELP with this COMMAND\n", .{}),
        else => {
            var content: []const u8 = "";
            const base64 = b64.Base64.init();
            var memory_buffer: [1000]u8 = undefined;

            var fba = std.heap.FixedBufferAllocator.init(&memory_buffer);
            const allocator = fba.allocator();

            while (content.len == 0) {
                var buffer: [1024]u8 = undefined;
                try stdout.print("\x1b[32mContent ⚡\x1b[0m ", .{});
                content = try stdin.readUntilDelimiter(&buffer, '\n');
            }

            switch (function) {
                .Encode => {
                    const encoding = try base64.encode(allocator, content);
                    return try stdout.print("Encoding: {s}\n", .{encoding});
                },
                .Decode => {
                    const decoding = try base64.decode(allocator, content);
                    return try stdout.print("Decoding: {s}\n", .{decoding});
                },
                else => return,
            }
        },
    }
}

fn stringToFunction(string: []const u8) Function {
    if (mem.eql(u8, string, "-todo")) return .Todo;
    if (mem.eql(u8, string, "-help") or mem.eql(u8, string, "-h")) return .Help;
    if (mem.eql(u8, string, "-encode") or mem.eql(u8, string, "-e")) return .Encode;
    if (mem.eql(u8, string, "-decode") or mem.eql(u8, string, "-d")) return .Decode;
    return .Invalid;
}

fn help() !void {
    try sc.clearBuffer();
    try file.controller("-r --path=./src/commands/base64/inc/help.md");
}

fn todo() !void {
    try sc.clearBuffer();
    try file.controller("-u --path=./src/commands/base64/inc/todo.md");
}
