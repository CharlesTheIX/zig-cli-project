const mem = std.mem;
const std = @import("std");
const file = @import("./file.zig");
const sc = @import("./helpers/shellCommands.zig");
const http = @import("../commands/http/init.zig");
const stdout = std.io.getStdOut().writer();

const FileFunction = enum { Help, Todo, Start, Endpoints, Invalid };

pub fn controller(args: []const u8) !void {
    if (args.len == 0) return try stdout.print("FUNCTION Required: Please use '-help' OR '-h' FUNCTION for HELP with this COMMAND\n", .{});

    var arg_parts = mem.splitSequence(u8, args, " ");
    const function = stringToFileFunction(arg_parts.first());

    switch (function) {
        .Help => return try help(),
        .Todo => return try todo(),
        .Endpoints => return endpoints(),
        .Invalid => return try stdout.print("Invalid FUNCTION: Please use '-help' OR '-h' FUNCTION for HELP with this COMMAND\n", .{}),
        .Start => {
            var port: u16 = 4221;
            var host: []const u8 = "127.0.0.1";

            switch (function) {
                .Start => {
                    while (arg_parts.next()) |part| {
                        if (mem.eql(u8, part[0..2], "--")) {
                            var key_value = mem.splitSequence(u8, part, "=");
                            const key = key_value.first();
                            const value = key_value.rest();

                            if (mem.eql(u8, key, "--host") or mem.eql(u8, key, "--h")) host = value;
                            if (mem.eql(u8, key, "--port") or mem.eql(u8, key, "--p")) port = try std.fmt.parseInt(u16, value, 10);
                        } else continue;
                    }

                    try http.init(host, port);
                },
                else => return,
            }
        },
    }
}

fn stringToFileFunction(string: []const u8) FileFunction {
    if (mem.eql(u8, string, "-todo")) return .Todo;
    if (mem.eql(u8, string, "-help") or mem.eql(u8, string, "-h")) return .Help;
    if (mem.eql(u8, string, "-start") or mem.eql(u8, string, "-s")) return .Start;
    if (mem.eql(u8, string, "-endpoints") or mem.eql(u8, string, "-e")) return .Endpoints;
    return .Invalid;
}

fn help() !void {
    try sc.clearBuffer();
    try file.controller("-r --path=./src/commands/http/inc/help.md");
}

fn todo() !void {
    try sc.clearBuffer();
    try file.controller("-u --path=./src/commands/http/inc/todo.md");
}

fn endpoints() !void {
    try sc.clearBuffer();
    try file.controller("-r --path=./src/commands/http/inc/endpoints.md");
}
