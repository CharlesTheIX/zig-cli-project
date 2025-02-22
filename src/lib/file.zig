const fs = std.fs;
const mem = std.mem;
const std = @import("std");
const sc = @import("./helpers/shellCommands.zig");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

pub const Editor = enum { Invalid, Nvim, Code };
const FileType = enum { Txt, MD, JSON, Invalid };
const Function = enum { Help, Todo, Read, Write, Update, Delete, Copy, Invalid };

pub fn controller(args: []const u8) !void {
    if (args.len == 0) return try stdout.print("FUNCTION Required: Please use '-help' OR '-h' FUNCTION for HELP with this COMMAND.\n", .{});

    var arg_parts = mem.splitSequence(u8, args, " ");
    const function = stringToFunction(arg_parts.first());

    switch (function) {
        .Help => return try help(),
        .Todo => return try todo(),
        .Invalid => return try stdout.print("FUNCTION Required: Please use '-help' OR '-h' FUNCTION for HELP with this COMMAND.\n", .{}),
        else => {
            const options = arg_parts.rest();

            switch (function) {
                .Read => return try read(options),
                .Copy => return try copy(options),
                .Write => return try write(options),
                .Update => return try update(options),
                .Delete => return try delete(options),
                else => return,
            }
        },
    }
}

fn stringToFunction(string: []const u8) Function {
    if (mem.eql(u8, string, "-todo")) return .Todo;
    if (mem.eql(u8, string, "-help") or mem.eql(u8, string, "-h")) return .Help;
    if (mem.eql(u8, string, "-read") or mem.eql(u8, string, "-r")) return .Read;
    if (mem.eql(u8, string, "-copy") or mem.eql(u8, string, "-c")) return .Copy;
    if (mem.eql(u8, string, "-write") or mem.eql(u8, string, "-w")) return .Write;
    if (mem.eql(u8, string, "-update") or mem.eql(u8, string, "-u")) return .Update;
    if (mem.eql(u8, string, "-delete") or mem.eql(u8, string, "-d")) return .Delete;
    return .Invalid;
}

fn help() !void {
    try sc.clearBuffer();
    try read("--path=./src/inc/file-help.md");
}

fn todo() !void {
    try sc.clearBuffer();
    try update("--path=./src/inc/file-todo.md");
}

fn read(args: []const u8) !void {
    var arg_parts = mem.splitSequence(u8, args, " ");
    var path: []const u8 = "";

    while (arg_parts.next()) |part| {
        if (mem.eql(u8, part, "")) break;

        if (mem.eql(u8, part[0..2], "--")) {
            var key_value = mem.splitSequence(u8, part, "=");
            const key = key_value.first();
            const value = key_value.rest();

            if (mem.eql(u8, key, "--path") or mem.eql(u8, key, "--p")) path = value;
        } else continue;
    }

    if (path.len == 0) return try stdout.print("Argument Required: --path\n", .{});

    const file_type = getFileType(path);

    if (file_type == .Invalid) return try stdout.print("Invalid File Type.\n", .{});

    const abs_path: []const u8 = try getAbsPath(path);

    var file = fs.openFileAbsolute(abs_path, .{ .mode = .read_only }) catch {
        return try stdout.print("File not found: {s}\n", .{abs_path});
    };
    defer file.close();

    const file_size = try file.getEndPos();
    const allocator = std.heap.page_allocator;
    const buffer = try allocator.alloc(u8, file_size);
    defer allocator.free(buffer);

    const file_bytes = try file.readAll(buffer);
    std.debug.assert(file_bytes == file_size);

    try sc.clearBuffer();
    try stdout.writeAll(buffer);
    try stdout.writeAll("\n");
}

fn write(args: []const u8) !void {
    var arg_parts = mem.splitSequence(u8, args, " ");
    var path: []const u8 = "";
    var editor = Editor.Nvim;

    while (arg_parts.next()) |part| {
        if (mem.eql(u8, part, "") or part.len == 1) break;

        if (mem.eql(u8, part[0..2], "--")) {
            var key_value = mem.splitSequence(u8, part, "=");
            const key = key_value.first();
            const value = key_value.rest();

            if (mem.eql(u8, key, "--path") or mem.eql(u8, key, "--p")) path = value;
            if (mem.eql(u8, key, "--editor") or mem.eql(u8, key, "--e")) editor = getEditor(value);
        } else continue;
    }

    if (path.len == 0) return try stdout.print("Argument Required: --path\n", .{});

    const file_type = getFileType(path);

    if (file_type == .Invalid) return try stdout.print("Invalid File Type\n", .{});

    const abs_path: []const u8 = try getAbsPath(path);
    try sc.openEditor(editor, abs_path);
}

fn update(args: []const u8) !void {
    var arg_parts = mem.splitSequence(u8, args, " ");
    var path: []const u8 = "";
    var editor = Editor.Nvim;

    while (arg_parts.next()) |part| {
        if (mem.eql(u8, part, "")) break;

        if (mem.eql(u8, part[0..2], "--")) {
            var key_value = mem.splitSequence(u8, part, "=");
            const key = key_value.first();
            const value = key_value.rest();

            if (mem.eql(u8, key, "--path") or mem.eql(u8, key, "--p")) path = value;
            if (mem.eql(u8, key, "--editor") or mem.eql(u8, key, "--e")) editor = getEditor(value);
        } else continue;
    }

    if (path.len == 0) return try stdout.print("Argument Required: --path\n", .{});

    const file_type = getFileType(path);

    if (file_type == .Invalid) return try stdout.print("Invalid File Type.\n", .{});

    const abs_path: []const u8 = try getAbsPath(path);
    try sc.openEditor(editor, abs_path);
}

fn delete(args: []const u8) !void {
    var arg_parts = mem.splitSequence(u8, args, " ");
    var path: []const u8 = "";

    while (arg_parts.next()) |part| {
        if (mem.eql(u8, part, "")) break;

        if (mem.eql(u8, part[0..2], "--")) {
            var key_value = mem.splitSequence(u8, part, "=");
            const key = key_value.first();
            const value = key_value.rest();

            if (mem.eql(u8, key, "--path") or mem.eql(u8, key, "--p")) path = value;
        } else continue;
    }

    if (path.len == 0) return try stdout.print("Required Arguments: --path\n", .{});

    const file_type = getFileType(path);

    if (file_type == .Invalid) return try stdout.print("Invalid File Type.\n", .{});

    const abs_path: []const u8 = try getAbsPath(path);
    _ = fs.deleteFileAbsolute(abs_path) catch {
        return try stdout.print("File not found: {s}\n", .{abs_path});
    };
    try stdout.print("File Deleted: {s}\n", .{abs_path});
}

fn copy(args: []const u8) !void {
    var arg_parts = mem.splitSequence(u8, args, " ");
    var from: []const u8 = "";
    var to: []const u8 = "";

    while (arg_parts.next()) |part| {
        if (mem.eql(u8, part, "")) break;

        if (mem.eql(u8, part[0..2], "--")) {
            var key_value = mem.splitSequence(u8, part, "=");
            const key = key_value.first();
            const value = key_value.rest();

            if (mem.eql(u8, key, "--from") or mem.eql(u8, key, "--f")) from = value;
            if (mem.eql(u8, key, "--to") or mem.eql(u8, key, "--t")) to = value;
        } else continue;
    }

    if (from.len == 0 or to.len == 0) return try stdout.print("Argument Required: --from --to\n", .{});

    const file_type = getFileType(from);

    if (file_type == .Invalid) return try stdout.print("Invalid File Type.\n", .{});

    const abs_to_path: []const u8 = try getAbsPath(to);
    const abs_from_path: []const u8 = try getAbsPath(from);
    _ = fs.copyFileAbsolute(abs_from_path, abs_to_path, .{}) catch {
        return try stdout.print("File not found: {s}\n", .{abs_from_path});
    };
    try stdout.print("File copied:\nfrom: {s}\nto: {s}\n", .{ abs_from_path, abs_to_path });
}

fn getFileType(path: []const u8) FileType {
    if (path.len == 0) return .Invalid;

    var path_parts = mem.splitSequence(u8, path, "/");
    var file_name: []const u8 = undefined;

    while (path_parts.next()) |part| file_name = part;

    var file_name_parts = mem.splitSequence(u8, file_name, ".");
    var file_type: []const u8 = "";

    while (file_name_parts.next()) |part| file_type = part;

    if (mem.eql(u8, file_type, "md")) return .MD;
    if (mem.eql(u8, file_type, "txt")) return .Txt;
    if (mem.eql(u8, file_type, "json")) return .JSON;
    return .Invalid;
}

fn getEditor(editor: []const u8) Editor {
    _ = editor;
    return .Nvim;
}

fn getAbsPath(path: []const u8) ![]const u8 {
    const path_first_char = path[0..1];

    if (mem.eql(u8, path_first_char, "/")) return path;

    const allocator = std.heap.page_allocator;

    if (mem.eql(u8, path_first_char, "~")) {
        const env = try std.process.getEnvMap(allocator);
        const home_path = env.get("HOME") orelse "";
        return try fs.path.join(allocator, &[_][]const u8{ home_path, "/", path[1..] });
    }

    var count: u8 = 0;
    var cwd_path: []const u8 = "";
    var path_parts = mem.splitSequence(u8, path, "/");

    while (path_parts.next()) |part| {
        if (mem.eql(u8, part, ".")) {
            count += 2;
            cwd_path = try fs.path.join(allocator, &[_][]const u8{ cwd_path, "." });
        } else if (mem.eql(u8, part, "..")) {
            if (count == 0) cwd_path = try fs.path.join(allocator, &[_][]const u8{ cwd_path, ".." });
            if (count >= 2) cwd_path = try fs.path.join(allocator, &[_][]const u8{ cwd_path, "/.." });
            count += 3;
        } else break;
    }

    const cwd = try fs.cwd().realpathAlloc(allocator, cwd_path);
    defer allocator.free(cwd);
    return try fs.path.join(allocator, &[_][]const u8{ cwd, "/", path[count..] });
}
