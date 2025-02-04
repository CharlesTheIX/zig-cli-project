// const pg = @import("pg");
const net = std.net;
const mem = std.mem;
const std = @import("std");
const misc_routes = @import("../misc.zig");
const requests = @import("../../requests.zig");

const AllowedRoutes = enum { Create, Invalid };

pub fn router(connection: net.Server.Connection, method: requests.Method, children: []const u8, query: ?[]const u8, body: ?[]const u8) !void {
    _ = query;
    var child_parts = mem.splitSequence(u8, children, "/");
    const route = stringToAllowedRoutes(child_parts.first());
    const id = child_parts.rest();
    _ = id;

    switch (route) {
        .Create => return create(connection, method, body),
        .Invalid => return try misc_routes.notFound(connection),
    }
}

fn stringToAllowedRoutes(string: []const u8) AllowedRoutes {
    if (mem.eql(u8, string, "create")) return .Create;
    return .Invalid;
}

fn create(connection: net.Server.Connection, method: requests.Method, body: ?[]const u8) !void {
    _ = body;
    if (method != .POST) return try misc_routes.methodNotAllowed(connection);

    // const allocator = std.heap.page_allocator;
    // const connection_info = "host=localhost user=your_user password=your_password dbname=your_database";
    // var client = try pg.Client.connect(allocator, connection_info);
    // defer client.deinit();

    // const sql =
    //     \\CREATE TABLE IF NOT EXISTS users (
    //     \\    id SERIAL PRIMARY KEY,
    //     \\    name TEXT NOT NULL,
    //     \\    email TEXT UNIQUE NOT NULL
    //     \\);
    // ;

    // _ = try client.exec(sql);
    // const result = try std.fmt.allocPrint(allocator, "HTTP/1.1 204 OK\r\n\r\n", .{});
    // defer allocator.free(result);
    // _ = try connection.stream.write(result);
}
