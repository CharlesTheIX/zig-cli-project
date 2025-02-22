const mem = std.mem;
const std = @import("std");
const file = @import("./file.zig");
const http = @import("../commands/http/init.zig");
const sc = @import("./helpers/shell-commands.zig");

const Function = enum { Help, Todo, Start, Endpoints, Invalid };

pub fn controller(args: []const u8) !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    if (args.len == 0) return try stdout.print("FUNCTION Required: Please use '-help' OR '-h' FUNCTION for HELP with this COMMAND\n", .{});

    var arg_parts = mem.splitSequence(u8, args, " ");
    const function = stringToFunction(arg_parts.first());

    switch (function) {
        .Help => return try help(),
        .Todo => return try todo(),
        .Endpoints => return endpoints(),
        .Invalid => return try stdout.print("Invalid FUNCTION: Please use '-help' OR '-h' FUNCTION for HELP with this COMMAND\n", .{}),
        .Start => {
            var port: u16 = 0;
            var host: []const u8 = "";

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

                    while (host.len == 0) {
                        var buffer: [1024]u8 = undefined;
                        try stdout.print("\x1b[32mHost ⚡\x1b[0m ", .{});
                        host = try stdin.readUntilDelimiter(&buffer, '\n');

                        if (host.len == 0) host = "127.0.0.1";
                    }

                    while (port == 0) {
                        var buffer: [1024]u8 = undefined;
                        try stdout.print("\x1b[32mPort ⚡\x1b[0m ", .{});
                        const port_input = try stdin.readUntilDelimiter(&buffer, '\n');

                        if (port_input.len == 0) {
                            port = 4221;
                        } else {
                            port = try std.fmt.parseInt(u16, port_input, 10);
                        }
                    }

                    try http.init(host, port);
                },
                else => return,
            }
        },
    }
}

fn stringToFunction(string: []const u8) Function {
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
