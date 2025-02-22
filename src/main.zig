const std = @import("std");
const file = @import("./lib/file.zig");
const cmd = @import("./lib/command.zig");
const sc = @import("./lib/helpers/shell-commands.zig");

pub fn main() !void {
    var buffer: [1024]u8 = undefined;
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    try sc.clearBuffer();
    try file.controller("-r --path=./src/inc/intro.md");

    while (true) {
        try stdout.print("\x1b[33m⚡ ", .{});
        const input = try stdin.readUntilDelimiter(&buffer, '\n');
        try stdout.print("\x1b[0m", .{});
        var commands = std.mem.splitSequence(u8, input, " ");
        const command = commands.first();
        const args = commands.rest();
        try cmd.controller(command, args);
    }
}
