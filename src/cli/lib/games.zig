const games = @import("../../games/init.zig");

pub fn controller() !void {
    try games.init();
}
