const std = @import("std");

pub fn getUserInput(buffer: *[1024]u8) ![]u8 {
    return std.io.getStdIn().reader().readUntilDelimiter(buffer, '\n');
}
