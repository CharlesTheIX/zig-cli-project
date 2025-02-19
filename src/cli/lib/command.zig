const mem = std.mem;
const std = @import("std");
const process = std.process;
const exit = @import("./exit.zig");
const file = @import("./file.zig");
const http = @import("./http.zig");
const b64 = @import("./base64.zig");
const games = @import("./games.zig");
const stdout = std.io.getStdOut().writer();

const Command = enum { Help, Exit, File, Http, Games, Base64, Invalid };

pub fn controller(command: []const u8, args: []const u8) !void {
    const commandType = stringToCommand(command);
    switch (commandType) {
        .Help => try help(),
        .Games => try games.controller(),
        .Exit => try exit.controller(0),
        .File => try file.controller(args),
        .Http => try http.controller(args),
        .Base64 => try b64.controller(args),
        .Invalid => try shellCommands(command, args),
    }
}

pub fn stringToCommand(string: []const u8) Command {
    if (mem.eql(u8, string, "help")) return .Help;
    if (mem.eql(u8, string, "file")) return .File;
    if (mem.eql(u8, string, "http")) return .Http;
    if (mem.eql(u8, string, "b64")) return .Base64;
    if (mem.eql(u8, string, "games")) return .Games;
    if (mem.eql(u8, string, "exit") or mem.eql(u8, string, ":q")) return .Exit;
    return .Invalid;
}

fn getCommandIsInPATH(command: []const u8) ![]const u8 {
    var return_value: []const u8 = "";
    const allocator = std.heap.page_allocator;
    const env = try process.getEnvMap(allocator);
    const path = env.get("PATH") orelse "";
    var path_dirs = mem.splitSequence(u8, path, ":");

    while (path_dirs.next()) |dir| {
        const full_path = try std.fs.path.join(allocator, &[_][]const u8{ dir, command });

        // Some paths in my PATH are not abs, this line skips those non-abs paths
        if (mem.eql(u8, full_path[0..1], "/") == false) continue;

        const bin_file = std.fs.openFileAbsolute(full_path, .{ .mode = .read_only }) catch continue;
        defer bin_file.close();

        const mode = bin_file.mode() catch continue;
        const is_exe_file = mode & 0b001 != 0;

        if (is_exe_file) {
            return_value = full_path;
            break;
        }
    }

    return return_value;
}

fn help() !void {
    try file.controller("-r --path=./src/cli/inc/help.txt");
}

fn shellCommands(command: []const u8, args: []const u8) !void {
    const path = try getCommandIsInPATH(command);

    if (mem.eql(u8, path, "")) return try stdout.print("Shell Command Not Found\n", .{});

    if (mem.eql(u8, command, "pwd")) {
        const allocator = std.heap.page_allocator;
        const args_array = &[2][]const u8{ "pwd", "-L" };
        var child_process = process.Child.init(args_array, allocator);
        _ = try child_process.spawnAndWait();
        return;
    }

    var count: u8 = 1;
    var arg_parts = mem.splitSequence(u8, args, " ");

    while (arg_parts.next()) |part| {
        _ = part;
        count += 1;
    }

    const allocator = std.heap.page_allocator;
    const args_array = try allocator.alloc([]const u8, count);
    defer allocator.free(args_array);

    count = 1;
    arg_parts.reset();
    args_array[0] = command;

    while (arg_parts.next()) |part| {
        args_array[count] = part;
        count += 1;
    }

    var child_process = process.Child.init(args_array, allocator);
    _ = try child_process.spawnAndWait();
}
