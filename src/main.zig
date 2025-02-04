const cli = @import("cli/init.zig");
const http = @import("http/init.zig");

pub fn main() !void {
    try cli.init();
}
