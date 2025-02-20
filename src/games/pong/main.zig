const rl = @import("raylib");
const hex = @import("./hex.zig");
const bl = @import("./ball.zig");
const ply = @import("./player.zig");
const bg = @import("./background.zig");

pub fn main() !void {
    var ball = bl.Ball.init();
    const is_resizeable = false;
    const has_full_screen_toggle = false;
    var background = bg.Background.init();
    var player_1 = ply.Player.createHuman(ply.Option.One);
    var player_2 = ply.Player.createCpu(ply.Option.Two);
    var players = [2]*ply.Player{ &player_1, &player_2 };

    rl.initWindow(800, 420, "Pong");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    if (is_resizeable == true) rl.setWindowState(rl.ConfigFlags{ .window_resizable = true });

    while (!rl.windowShouldClose()) {
        if (has_full_screen_toggle == true and rl.isKeyPressed(.f)) rl.toggleFullscreen();
        update(&ball, &players);
        draw(&ball, &players, &background);
    }
}

fn update(ball: *bl.Ball, players: *[2]*ply.Player) void {
    for (players.*) |p| p.*.update(ball);
    ball.*.update();
}

fn draw(ball: *bl.Ball, players: *[2]*ply.Player, background: *bg.Background) void {
    rl.beginDrawing();
    defer rl.endDrawing();
    rl.clearBackground(hex.hexToColor("#000000FF"));

    background.*.draw();
    ball.*.draw();
    for (players.*) |p| p.*.draw();
}
