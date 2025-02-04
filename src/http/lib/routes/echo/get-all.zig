const net = std.net;
const std = @import("std");
const misc_routes = @import("../misc.zig");
const requests = @import("../../requests.zig");

pub fn route(connection: net.Server.Connection, method: requests.Method, id: ?[]const u8, body: ?[]const u8) !void {
    switch (method) {
        requests.Method.GET => return get(connection, id, body),
        else => return try misc_routes.methodNotAllowed(connection),
    }
}

fn get(connection: net.Server.Connection, id: ?[]const u8, body: ?[]const u8) !void {
    _ = id;
    _ = body;
    const content = "result-echo-get-all";
    const allocator = std.heap.page_allocator;
    const result = try std.fmt.allocPrint(allocator, "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-length: {d}\r\n\r\n{s}", .{ content.len, content });
    _ = try connection.stream.write(result);
    defer allocator.free(result);
}
