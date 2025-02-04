const fs = std.fs;
const mem = std.mem;
const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

const AcceptedExtension = enum { Txt, JSON, Invalid };
const Function = enum { Help, Read, Write, Update, Delete, Copy, Invalid };

pub fn controller(args: []const u8) !void {
    if (args.len == 0) return try stdout.print("FileFunction Required;\nPlease ues '-h' or '-help' FileFunction for help with this Command;\n", .{});

    var arg_parts = mem.splitSequence(u8, args, " ");
    const function = stringToFileFunction(arg_parts.first());

    if (function == .Help) return try help();
    if (function == .Invalid) return try stdout.print("Invalid FileFunction;\nPlease use '-h' or '-help' FileFunction for help with this Command;\n", .{});

    const options = arg_parts.rest();

    switch (function) {
        .Read => return try read(options),
        .Copy => return try copy(options),
        .Write => return try write(options),
        .Update => return try update(options),
        .Delete => return try delete(options),
        else => return,
    }
}

pub fn stringToFileFunction(string: []const u8) Function {
    if (mem.eql(u8, string, "-h") or mem.eql(u8, string, "-help")) return .Help;
    if (mem.eql(u8, string, "-r") or mem.eql(u8, string, "-read")) return .Read;
    if (mem.eql(u8, string, "-c") or mem.eql(u8, string, "-copy")) return .Copy;
    if (mem.eql(u8, string, "-w") or mem.eql(u8, string, "-write")) return .Write;
    if (mem.eql(u8, string, "-u") or mem.eql(u8, string, "-update")) return .Update;
    if (mem.eql(u8, string, "-d") or mem.eql(u8, string, "-delete")) return .Delete;
    return .Invalid;
}

fn help() !void {
    try read("--path=./src/cli/inc/help_file.txt");
}

fn read(args: []const u8) !void {
    var arg_parts = mem.splitSequence(u8, args, " ");
    var path: []const u8 = "./src/cli/inc/help_file.txt";

    while (arg_parts.next()) |part| {
        if (mem.eql(u8, part, "")) break;

        if (mem.eql(u8, part[0..2], "--")) {
            var key_value = mem.splitSequence(u8, part, "=");
            const key = key_value.first();
            const value = key_value.rest();

            if (mem.eql(u8, key, "--path")) path = value;
        } else continue;
    }

    const extension = getExtension(path);

    if (extension == .Invalid) return try stdout.print("Invalid AcceptedExtension.\n", .{});

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

    try stdout.writeAll(buffer);
    try stdout.writeAll("\n");
}

fn write(args: []const u8) !void {
    var arg_parts = mem.splitSequence(u8, args, " ");
    var content: []const u8 = "This is a test.";
    var path: []const u8 = "./.local/test.txt";

    while (arg_parts.next()) |part| {
        if (mem.eql(u8, part, "") or part.len == 1) break;

        if (mem.eql(u8, part[0..2], "--")) {
            var key_value = mem.splitSequence(u8, part, "=");
            const key = key_value.first();
            const value = key_value.rest();

            if (mem.eql(u8, key, "--path")) path = value;
            if (mem.eql(u8, key, "--content")) content = arg_parts.rest();
        } else continue;
    }

    const extension = getExtension(path);

    if (extension == .Invalid) return try stdout.print("{s} is not an AcceptedExtension, and cannot be read.\n", .{path});

    const abs_path: []const u8 = try getAbsPath(path);
    var file = fs.createFileAbsolute(abs_path, .{ .read = true }) catch {
        return try stdout.print("Could not create the file: {s}\n", .{abs_path});
    };
    defer file.close();

    var fileWriter = file.writer();
    _ = try fileWriter.writeAll(content);
    _ = try fileWriter.writeAll("\n");
    try stdout.print("File Created: {s}\n", .{abs_path});
}

fn update(args: []const u8) !void {
    var arg_parts = mem.splitSequence(u8, args, " ");
    var content: []const u8 = "A new line test";
    var path: []const u8 = "./.local/test.txt";

    while (arg_parts.next()) |part| {
        if (mem.eql(u8, part, "")) break;

        if (mem.eql(u8, part[0..2], "--")) {
            var key_value = mem.splitSequence(u8, part, "=");
            const key = key_value.first();
            const value = key_value.rest();

            if (mem.eql(u8, key, "--path")) path = value;
            if (mem.eql(u8, key, "--content")) content = value;
        } else continue;
    }

    const extension = getExtension(path);

    if (extension == .Invalid) return try stdout.print("Invalid AcceptedExtension.\n", .{});

    const abs_path: []const u8 = try getAbsPath(path);
    var file = fs.openFileAbsolute(abs_path, .{ .mode = .read_write }) catch {
        return try stdout.print("File not found: {s}\n", .{abs_path});
    };
    defer file.close();

    try file.seekFromEnd(0);
    var fileWriter = file.writer();
    _ = try fileWriter.writeAll(content);
    _ = try fileWriter.writeAll("\n");
    try stdout.print("Update File: {s}\n", .{abs_path});
}

fn delete(args: []const u8) !void {
    var arg_parts = mem.splitSequence(u8, args, " ");
    var path: []const u8 = "./.local/test.txt";

    while (arg_parts.next()) |part| {
        if (mem.eql(u8, part, "")) break;

        if (mem.eql(u8, part[0..2], "--")) {
            var key_value = mem.splitSequence(u8, part, "=");
            const key = key_value.first();
            const value = key_value.rest();

            if (mem.eql(u8, key, "--path")) path = value;
        } else continue;
    }

    const extension = getExtension(path);

    if (extension == .Invalid) return try stdout.print("{s} is not an AcceptedExtension, and cannot be read.\n", .{path});

    const abs_path: []const u8 = try getAbsPath(path);
    _ = fs.deleteFileAbsolute(abs_path) catch {
        return try stdout.print("File not found: {s}\n", .{abs_path});
    };
    try stdout.print("File Deleted: {s}\n", .{abs_path});
}

fn copy(args: []const u8) !void {
    var arg_parts = mem.splitSequence(u8, args, " ");
    var from_path: []const u8 = "./.local/test.txt";
    var to_path: []const u8 = "./.local/test-1.txt";

    while (arg_parts.next()) |part| {
        if (mem.eql(u8, part, "")) break;

        if (mem.eql(u8, part[0..2], "--")) {
            var key_value = mem.splitSequence(u8, part, "=");
            const key = key_value.first();
            const value = key_value.rest();

            if (mem.eql(u8, key, "--from-path")) from_path = value;
            if (mem.eql(u8, key, "--to-path")) to_path = value;
        } else continue;
    }

    const extension = getExtension(from_path);

    if (extension == .Invalid) return try stdout.print("{s} is not an AcceptedExtension, and cannot be read.\n", .{from_path});

    const abs_to_path: []const u8 = try getAbsPath(to_path);
    const abs_from_path: []const u8 = try getAbsPath(from_path);
    _ = fs.copyFileAbsolute(abs_from_path, abs_to_path, .{}) catch {
        return try stdout.print("File not found: {s}\n", .{abs_from_path});
    };

    try stdout.print("File copied:\nfrom: {s}\nto: {s}\n", .{ abs_from_path, abs_to_path });
}

fn getExtension(path: []const u8) AcceptedExtension {
    var path_parts = mem.splitSequence(u8, path, "/");
    var file_name: []const u8 = undefined;

    while (path_parts.next()) |part| file_name = part;

    var file_name_parts = mem.splitSequence(u8, file_name, ".");
    var extension: []const u8 = "";

    while (file_name_parts.next()) |part| extension = part;

    if (mem.eql(u8, extension, "txt")) return .Txt;
    if (mem.eql(u8, extension, "json")) return .JSON;
    return .Invalid;
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
