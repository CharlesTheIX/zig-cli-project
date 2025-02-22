const mem = std.mem;
const std = @import("std");
const process = std.process;
const file = @import("../file.zig");
const stdout = std.io.getStdOut().writer();

pub fn shellCommands(command: []const u8, args: []const u8) !void {
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

pub fn clearBuffer() !void {
    try shellCommands("clear", "");
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

pub fn openEditor(editor: file.Editor, path: []const u8) !void {
    switch (editor) {
        .Nvim => return try shellCommands("nvim", path),
        else => return try stdout.print("Invalid Editor.\n", .{}),
    }
}
