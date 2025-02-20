const pong = @import("./pong/main.zig");
const game_test = @import("./test/main.zig");

pub fn init() !void {
    const target_game = pong;
    try target_game.main();
}
