const cli = @import("cli/init.zig");

pub fn main() !void {
    try cli.init();
}
