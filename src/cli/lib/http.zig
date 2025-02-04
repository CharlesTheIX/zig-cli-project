const fs = std.fs;
const mem = std.mem;
const std = @import("std");
const file = @import("./file.zig");
const http = @import("../../http/init.zig");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

const FileFunction = enum { Help, Start, Invalid };

pub fn controller(args: []const u8) !void {
    if (args.len == 0) return try stdout.print("FileFunction Required;\nPlease ues '-h' or '-help' FileFunction for help with this Command;\n", .{});

    var arg_parts = mem.splitSequence(u8, args, " ");
    const function = stringToFileFunction(arg_parts.first());

    if (function == .Help) return try help();
    if (function == .Invalid) return try stdout.print("Invalid FileFunction;\nPlease use '-h' or '-help' FileFunction for help with this Command;\n", .{});

    var port: u16 = 4221;
    var host: []const u8 = "127.0.0.1";

    switch (function) {
        .Start => {
            while (arg_parts.next()) |part| {
                if (mem.eql(u8, part[0..2], "--")) {
                    var key_value = mem.splitSequence(u8, part, "=");
                    const key = key_value.first();
                    const value = key_value.rest();

                    if (mem.eql(u8, key, "--host")) host = value;
                    if (mem.eql(u8, key, "--port")) port = try std.fmt.parseInt(u16, value, 10);
                } else continue;
            }

            try http.init(host, port);
        },
        else => return,
    }
}

fn stringToFileFunction(string: []const u8) FileFunction {
    if (mem.eql(u8, string, "-h") or mem.eql(u8, string, "-help")) return .Help;
    if (mem.eql(u8, string, "-s") or mem.eql(u8, string, "-start")) return .Start;
    return .Invalid;
}

fn help() !void {
    try file.controller("-r --path=./src/cli/inc/help_http.txt");
}
