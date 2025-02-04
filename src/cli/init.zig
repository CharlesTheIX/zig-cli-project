const std = @import("std");
const file = @import("./lib/file.zig");
const cmd = @import("./lib/command.zig");

pub fn init() !void {
    var buffer: [1024]u8 = undefined;
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    try cmd.controller("clear", "");
    try file.controller("-r --path=./src/cli/inc/intro.txt");

    while (true) {
        try stdout.print("⚡ ", .{});
        const input = try stdin.readUntilDelimiter(&buffer, '\n');
        var commands = std.mem.splitSequence(u8, input, " ");
        const command = commands.first();
        const args = commands.rest();
        try cmd.controller(command, args);
    }
}
