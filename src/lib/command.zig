const mem = std.mem;
const std = @import("std");
const exit = @import("./exit.zig");
const file = @import("./file.zig");
const http = @import("./http.zig");
const b64 = @import("./base64.zig");
const games = @import("./games.zig");
const bc = @import("./bit-controller.zig");
const sc = @import("./helpers/shell-commands.zig");

const Command = enum {
    Help,
    Todo,
    Exit,
    File,
    Http,
    Games,
    Base64,
    BitController,
    Invalid,
};

pub fn controller(command: []const u8, args: []const u8) !void {
    const commandType = stringToCommand(command);
    switch (commandType) {
        .Help => try help(),
        .Todo => try todo(),
        .Exit => try exit.controller(0),
        .File => try file.controller(args),
        .Http => try http.controller(args),
        .Base64 => try b64.controller(args),
        .Games => try games.controller(args),
        .BitController => try bc.controller(args),
        .Invalid => try sc.shellCommands(command, args),
    }
}

pub fn stringToCommand(string: []const u8) Command {
    if (mem.eql(u8, string, "help")) return .Help;
    if (mem.eql(u8, string, "todo")) return .Todo;
    if (mem.eql(u8, string, "file")) return .File;
    if (mem.eql(u8, string, "http")) return .Http;
    if (mem.eql(u8, string, "b64")) return .Base64;
    if (mem.eql(u8, string, "games")) return .Games;
    if (mem.eql(u8, string, "bc")) return .BitController;
    if (mem.eql(u8, string, "exit") or mem.eql(u8, string, ":q")) return .Exit;
    return .Invalid;
}

fn help() !void {
    try sc.clearBuffer();
    try file.controller("-r --path=./src/inc/help.md");
}

fn todo() !void {
    try sc.clearBuffer();
    try file.controller("-u --path=./src/inc/todo.md");
}
