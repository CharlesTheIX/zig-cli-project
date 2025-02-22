const net = std.net;
const std = @import("std");
const requests = @import("../requests.zig");

pub fn success(connection: net.Server.Connection, method: requests.Method) !void {
    switch (method) {
        requests.Method.GET => _ = try connection.stream.write("HTTP/1.1 200 OK\r\n\r\n"),
        else => return methodNotAllowed(connection),
    }
}

pub fn notFound(connection: net.Server.Connection) !void {
    _ = try connection.stream.write("HTTP/1.1 404 Not Found\r\n\r\n");
}

pub fn methodNotAllowed(connection: net.Server.Connection) !void {
    _ = try connection.stream.write("HTTP/1.1 403 Method Not allowed\r\n\r\n");
}

pub fn serverError(connection: net.Server.Connection) !void {
    _ = try connection.stream.write("HTTP/1.1 500 Server Error\r\n\r\n");
}
