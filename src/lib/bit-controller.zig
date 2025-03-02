const mem = std.mem;
const std = @import("std");
const file = @import("./file.zig");
const sc = @import("./helpers/shell-commands.zig");

const Function = enum { Help, Todo, Find, Get, Invalid };

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

            switch (function) {
                .Find => {
                    var number: u64 = undefined;

                    while (true) {
                        var buffer: [1024]u8 = undefined;
                        try stdout.print("\x1b[32mFind: \x1b[0m ", .{});
                        content = try stdin.readUntilDelimiter(&buffer, '\n');

                        number = std.fmt.parseInt(u64, content, 10) catch |err| {
                            return std.debug.print("Failed to parse number {}\n", .{err});
                        };
                        break;
                    }

                    const byte_size = @ceil(@log2(@as(f64, @floatFromInt(number))));
                    return try stdout.print("{}\n", .{@as(u64, @intFromFloat(byte_size))});
                },
                .Get => {
                    while (content.len == 0) {
                        var buffer: [1024]u8 = undefined;
                        try stdout.print("\x1b[32mType: \x1b[0m ", .{});
                        content = try stdin.readUntilDelimiter(&buffer, '\n');
                    }

                    const byte_type = content[0];
                    const size = content[1..];
                    const number = std.fmt.parseInt(u32, size, 10) catch |err| {
                        return std.debug.print("Failed to parse number {}.\n", .{err});
                    };

                    if (number > 64) return try stdout.print("The value {any} is larger than 64, please use a smaller integer.\n", .{number});

                    if (byte_type == 'u') {
                        const value = std.math.pow(u65, 2, number) - 1;

                        return try stdout.print("{any}\n", .{value});
                    } else if (byte_type == 'i') {
                        const value = std.math.pow(u65, 2, number);
                        const min = value / 2;
                        const max = min - 1;

                        return try stdout.print("-{any} to {any}\n", .{ min, max });
                    } else if (byte_type == 'f') {
                        return try stdout.print("Float types are yet to be implemented.\n", .{});
                    } else {
                        return std.debug.print("{any} is not a valid byte type.\n", .{byte_type});
                    }
                },
                else => return,
            }
        },
    }
}

fn stringToFunction(string: []const u8) Function {
    if (mem.eql(u8, string, "-todo")) return .Todo;
    if (mem.eql(u8, string, "-get") or mem.eql(u8, string, "-g")) return .Get;
    if (mem.eql(u8, string, "-help") or mem.eql(u8, string, "-h")) return .Help;
    if (mem.eql(u8, string, "-find") or mem.eql(u8, string, "-f")) return .Find;
    return .Invalid;
}

fn help() !void {
    try sc.clearBuffer();
    try file.controller("-r --path=./src/commands/bit-calculator/inc/help.md");
}

fn todo() !void {
    try sc.clearBuffer();
    try file.controller("-u --path=./src/commands/bit-controller/inc/todo.md");
}
