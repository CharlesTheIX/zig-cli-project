const rl = @import("raylib");
const hex = @import("./helpers/hex.zig");
const gm = @import("./components/game.zig");
const ply = @import("./components/player.zig");
const btn = @import("./components/button.zig");

pub fn main() !void {
    const is_resizeable = false;
    const has_full_screen_toggle = false;

    rl.initWindow(800, 420, "Pong");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    if (is_resizeable == true) rl.setWindowState(rl.ConfigFlags{ .window_resizable = true });

    var player_1 = ply.createHuman(ply.Option.One);
    var player_2 = ply.createCpu(ply.Option.Two);
    var player_3 = ply.createInactivePlayer();
    var player_4 = ply.createInactivePlayer();
    var players = [4]*ply.Player{ &player_1, &player_2, &player_3, &player_4 };
    var game = try gm.createGame(&players);

    while (!rl.windowShouldClose()) {
        if (has_full_screen_toggle == true and rl.isKeyPressed(.f)) rl.toggleFullscreen();

        try game.update();

        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(hex.hexToColor("#000000FF"));

        try game.draw();
    }
}
