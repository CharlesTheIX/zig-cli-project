const net = std.net;
const mem = std.mem;
const std = @import("std");
const helpers = @import("./lib/helpers.zig");
const headers = @import("./lib/headers.zig");
const requests = @import("./lib/requests.zig");
const misc_routes = @import("./lib/routes/misc.zig");
const stdout = std.io.getStdOut().writer();

pub fn init(host: []const u8, port: u16) !void {
    const address = try net.Address.resolveIp(host, port);
    var listener = try address.listen(.{
        .reuse_address = true,
    });
    defer listener.deinit();

    try stdout.print("Listening on {s} port: {d}\n\n", .{ host, port });

    while (true) {
        const connection = try listener.accept();
        defer connection.stream.close();

        const allocator = std.heap.page_allocator;
        const input = try allocator.alloc(u8, 1024);
        defer allocator.free(input);

        _ = try connection.stream.read(input);
        var input_parts = mem.splitSequence(u8, input, "\r\n\r\n");
        const head = helpers.trimTrailingAA(input_parts.first());
        var head_parts = mem.splitSequence(u8, head, "\r\n");
        const http_request = head_parts.first();
        const http_headers = helpers.trimTrailingAA(head_parts.rest());
        const headers_valid = headers.controller(http_headers);

        if (!headers_valid) return misc_routes.serverError(connection);

        const body = helpers.trimTrailingAA(input_parts.rest());
        try requests.controller(connection, http_request, http_headers, body);
    }
}
