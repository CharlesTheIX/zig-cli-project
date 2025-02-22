const std = @import("std");
const games = @import("../commands/games/init.zig");
const stdout = std.io.getStdOut().writer();

pub fn controller(args: []const u8) !void {
    if (args.len == 0) return try stdout.print("FUNCTION Required: Please use '-help' OR '-h' FUNCTION for HELP with this COMMAND\n", .{});

    var arg_parts = std.mem.splitSequence(u8, args, " ");
    const game = games.stringToGame(arg_parts.first());

    switch (game) {
        .Invalid => return try stdout.print("Invalid FUNCTION: Please use '-help' OR '-h' FUNCTION for HELP with this COMMAND\n", .{}),
        else => return games.init(game),
    }
}
