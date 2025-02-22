const std = @import("std");

pub fn controller(status: u8) !void {
    try std.process.exit(status);
}
