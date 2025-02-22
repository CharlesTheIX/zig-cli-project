const mem = std.mem;
const std = @import("std");
const pong = @import("./pong/main.zig");
const file = @import("../../lib/file.zig");
const sc = @import("../../lib/helpers/shellCommands.zig");

pub const Game = enum { Help, Todo, List, Pong, Invalid };

pub fn init(game: Game) !void {
    switch (game) {
        .Help => return help(),
        .Todo => return todo(),
        .List => return list(),
        .Pong => return pong.main(),
        .Invalid => return try std.io.getStdOut().writer().print("Invalid GAME: Please use '-help' OR '-h' FUNCTION for HELP with this COMMAND\n", .{}),
    }
}

pub fn stringToGame(string: []const u8) Game {
    if (mem.eql(u8, string, "-pong")) return .Pong;
    if (mem.eql(u8, string, "-todo")) return .Todo;
    if (mem.eql(u8, string, "-help") or mem.eql(u8, string, "-h")) return .Help;
    if (mem.eql(u8, string, "-list") or mem.eql(u8, string, "-l")) return .List;
    return .Invalid;
}

fn help() !void {
    try sc.clearBuffer();
    try file.controller("-r --path=./src/commands/games/inc/help.md");
}

fn todo() !void {
    try sc.clearBuffer();
    try file.controller("-u --path=./src/commands/games/inc/todo.md");
}

fn list() !void {
    try sc.clearBuffer();
    try file.controller("-r --path=./src/commands/games/inc/games.md");
}
