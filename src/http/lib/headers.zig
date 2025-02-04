const mem = std.mem;
const std = @import("std");

pub const HeaderType = enum { UserAgent, Accept, Host, AcceptEncoding, Connection, CacheControl, PostmanToken, ContentType, Invalid };

pub fn controller(headers: []const u8) bool {
    var headers_parts = mem.splitSequence(u8, headers, "\r\n");
    var return_value = false;

    while (headers_parts.next()) |part| {
        var key_value = mem.splitSequence(u8, part, ": ");
        const key = stringToHeaderType(key_value.first());
        const value = key_value.rest();

        switch (key) {
            .Host => {
                return_value = getIsValidHost(value);
            },
            .Accept => {
                return_value = getIsValidAccept(value);
            },
            .UserAgent => {
                return_value = getIsValidUserAgent(value);
            },
            .Connection => {
                return_value = getIsValidConnection(value);
            },
            .ContentType => {
                return_value = getIsValidContentType(value);
            },
            .CacheControl => {
                return_value = getIsValidCacheControl(value);
            },
            .PostmanToken => {
                return_value = getIsValidPostmanToken(value);
            },
            .AcceptEncoding => {
                return_value = getIsValidAcceptEncoding(value);
            },
            .Invalid => continue,
        }
    }

    return return_value;
}

pub fn getHeader(headers: []const u8, header_type: HeaderType) ?[]const u8 {
    var headers_parts = mem.splitSequence(u8, headers, "\r\n");

    while (headers_parts.next()) |part| {
        var key_value = mem.splitSequence(u8, part, ": ");
        const key = stringToHeaderType(key_value.first());
        const value = key_value.rest();

        if (key == header_type) return value;
    }

    return null;
}

fn stringToHeaderType(string: []const u8) HeaderType {
    if (mem.eql(u8, string, "Host")) return .Host;
    if (mem.eql(u8, string, "Accept")) return .Accept;
    if (mem.eql(u8, string, "User-Agent")) return .UserAgent;
    if (mem.eql(u8, string, "Connection")) return .Connection;
    if (mem.eql(u8, string, "Content-Type")) return .ContentType;
    if (mem.eql(u8, string, "Cache-Control")) return .CacheControl;
    if (mem.eql(u8, string, "Postman-Token")) return .PostmanToken;
    if (mem.eql(u8, string, "Accept-Encoding")) return .AcceptEncoding;
    return .Invalid;
}

fn getIsValidHost(value: []const u8) bool {
    _ = value;
    return true;
}

fn getIsValidAccept(value: []const u8) bool {
    _ = value;
    return true;
}

fn getIsValidUserAgent(value: []const u8) bool {
    _ = value;
    return true;
}

fn getIsValidConnection(value: []const u8) bool {
    _ = value;
    return true;
}

fn getIsValidContentType(value: []const u8) bool {
    _ = value;
    return true;
}

fn getIsValidCacheControl(value: []const u8) bool {
    _ = value;
    return true;
}

fn getIsValidPostmanToken(value: []const u8) bool {
    _ = value;
    return true;
}

fn getIsValidAcceptEncoding(value: []const u8) bool {
    _ = value;
    return true;
}
