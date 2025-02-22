const std = @import("std");
const term = @import("./helpers/terminal.zig");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

pub fn controller(options: [][]const u8) !void {
    const option = try getOptionFromInput(&options);
    try stdout.print("\n", .{});

    switch (option) {
        1 => try stdout.print("Hello world!\n", .{}),
        2 => try stdout.print("Goodbye world!\n", .{}),
        3 => return,
        else => @panic("Unexpected option"),
    }

    try stdout.print("\n", .{});
}

fn getOptionFromInput(options: *const [][]const u8) !u8 {
    var index: u8 = 0;

    for (options, 1..) |option, i| try stdout.print("{d}: {s}\n", .{ i, option });

    while (true) {
        var buffer: [1024]u8 = undefined;
        const input = try stdin.readUntilDelimiter(&buffer, '\n');
        var input_parts = std.mem.splitSequence(u8, input, " ");
        const target = input_parts.first();

        if (std.mem.eql(u8, target, "1")) {
            index = 1;
            break;
        }

        if (std.mem.eql(u8, target, "2")) {
            index = 2;
            break;
        }

        if (std.mem.eql(u8, target, "3")) {
            index = 3;
            break;
        }

        try stdout.print("Not a valid Option.\n", .{});
        continue;
    }

    return index;
}
