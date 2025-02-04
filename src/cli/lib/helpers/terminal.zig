const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn clearScreen() !void {
    try stdout.print("\x1b[2\x1b[H", .{});
}
