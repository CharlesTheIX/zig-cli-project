const net = std.net;
const std = @import("std");
const misc_routes = @import("../misc.zig");
const requests = @import("../../requests.zig");

pub fn router(connection: net.Server.Connection, method: requests.Method, children: ?[]const u8, query: ?[]const u8, body: ?[]const u8) !void {
    _ = body;
    _ = query;
    _ = children;
    const allocator = std.heap.page_allocator;

    switch (method) {
        requests.Method.GET => {
            const content = "result-test";
            const result = try std.fmt.allocPrint(allocator, "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-length: {d}\r\n\r\n{s}", .{ content.len, content });
            _ = try connection.stream.write(result);
            defer allocator.free(result);
        },
        else => return try misc_routes.methodNotAllowed(connection),
    }
}
