const net = std.net;
const mem = std.mem;
const std = @import("std");
const headers = @import("./headers.zig");
const misc_routes = @import("./routes/misc.zig");
const echo_route = @import("./routes/echo/router.zig");
const test_route = @import("./routes/test/router.zig");
const pg_tables_route = @import("./routes/pg-tables/router.zig");

pub const Route = enum { Health, PgTables, Echo, Test, NotFound };
pub const Method = enum { GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS, TRACE, CONNECT, Invalid };

pub fn controller(connection: net.Server.Connection, request: []const u8, header: []const u8, body: ?[]const u8) !void {
    var request_parts = mem.splitSequence(u8, request, " ");
    const method = stringToMethod(request_parts.next());
    const target = request_parts.next();
    // const protocol = iterator.next();
    // _ = protocol;
    _ = header;

    var target_parts = mem.splitSequence(u8, target.?, "?");
    const path = target_parts.first();
    const query = target_parts.rest();

    var path_parts = mem.splitSequence(u8, path, "/");
    _ = path_parts.next();

    const route = stringToRoute(path_parts.next());
    const children = path_parts.rest();

    switch (route) {
        .Health => return try misc_routes.success(connection, method),
        .Echo => return try echo_route.router(connection, method, children, query, body),
        .Test => return try test_route.router(connection, method, children, query, body),
        .PgTables => return try pg_tables_route.router(connection, method, children, query, body),
        else => return try misc_routes.notFound(connection),
    }
}

fn stringToMethod(string: ?[]const u8) Method {
    if (mem.eql(u8, string.?, "GET")) return .GET;
    if (mem.eql(u8, string.?, "PUT")) return .PUT;
    if (mem.eql(u8, string.?, "POST")) return .POST;
    if (mem.eql(u8, string.?, "HEAD")) return .HEAD;
    if (mem.eql(u8, string.?, "PATCH")) return .PATCH;
    if (mem.eql(u8, string.?, "TRACE")) return .TRACE;
    if (mem.eql(u8, string.?, "DELETE")) return .DELETE;
    if (mem.eql(u8, string.?, "OPTIONS")) return .OPTIONS;
    if (mem.eql(u8, string.?, "CONNECT")) return .CONNECT;
    return .Invalid;
}

fn stringToRoute(string: ?[]const u8) Route {
    if (mem.eql(u8, string.?, "echo")) return .Echo;
    if (mem.eql(u8, string.?, "test")) return .Test;
    if (mem.eql(u8, string.?, "health")) return .Health;
    return .NotFound;
}
