const game_test = @import("./test/main.zig");

pub fn init() !void {
    const target_game = game_test;
    try target_game.main();
}
