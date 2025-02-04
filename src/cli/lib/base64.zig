const mem = std.mem;
const std = @import("std");
const file = @import("./file.zig");
const b64 = @import("../../base64/init.zig");
const stdout = std.io.getStdOut().writer();

const Function = enum { Help, Encode, Decode, Invalid };

pub fn controller(args: []const u8) !void {
    if (args.len == 0) return try stdout.print("FileFunction Required;\nPlease ues '-h' or '-help' FileFunction for help with this Command;\n", .{});

    var arg_parts = mem.splitSequence(u8, args, " ");
    const function = stringToFileFunction(arg_parts.first());

    if (function == .Help) return try help();
    if (function == .Invalid) return try stdout.print("Invalid FileFunction;\nPlease use '-h' or '-help' FileFunction for help with this Command;\n", .{});

    var content: []const u8 = "TEST";
    const base64 = b64.Base64.init();
    var memory_buffer: [1000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&memory_buffer);
    const allocator = fba.allocator();

    while (arg_parts.next()) |part| {
        if (mem.eql(u8, part[0..2], "--")) {
            var key_value = mem.splitSequence(u8, part, "=");
            const key = key_value.first();
            const value = key_value.rest();

            if (mem.eql(u8, key, "--content")) content = value;
        } else continue;
    }

    switch (function) {
        .Encode => {
            const encoding = try base64.encode(allocator, content);
            return try stdout.print("Encoding: {s}\n", .{encoding});
        },
        .Decode => {
            const decoding = try base64.decode(allocator, content);
            return try stdout.print("Decoding: {s}\n", .{decoding});
        },
        else => return,
    }
}

fn help() !void {
    try file.controller("-r --path=./src/cli/inc/help_base64.txt");
}

pub fn stringToFileFunction(string: []const u8) Function {
    if (mem.eql(u8, string, "-h") or mem.eql(u8, string, "-help")) return .Help;
    if (mem.eql(u8, string, "-e") or mem.eql(u8, string, "-encode")) return .Encode;
    if (mem.eql(u8, string, "-d") or mem.eql(u8, string, "-decode")) return .Decode;
    return .Invalid;
}
