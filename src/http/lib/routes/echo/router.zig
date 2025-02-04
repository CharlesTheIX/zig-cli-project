const net = std.net;
const mem = std.mem;
const std = @import("std");
const get_all = @import("./get-all.zig");
const misc_routes = @import("../misc.zig");
const requests = @import("../../requests.zig");

pub fn router(connection: net.Server.Connection, method: requests.Method, children: []const u8, query: ?[]const u8, body: ?[]const u8) !void {
    _ = query;
    var child_parts = mem.splitSequence(u8, children, "/");
    const call = child_parts.first();
    const id = child_parts.rest();

    if (mem.eql(u8, call, "")) return root(connection, method);
    if (mem.eql(u8, call, "get-all")) return get_all.route(connection, method, id, body);

    return try misc_routes.notFound(connection);
}

fn root(connection: net.Server.Connection, method: requests.Method) !void {
    switch (method) {
        requests.Method.GET => return get(connection),
        else => return try misc_routes.methodNotAllowed(connection),
    }
}

fn get(connection: net.Server.Connection) !void {
    const content = "result-echo";
    const allocator = std.heap.page_allocator;
    const result = try std.fmt.allocPrint(allocator, "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-length: {d}\r\n\r\n{s}", .{ content.len, content });
    _ = try connection.stream.write(result);
    defer allocator.free(result);
}
