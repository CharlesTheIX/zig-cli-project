const rl = @import("raylib");
const mdl = @import("./models.zig");

pub const GameState = enum { Start, Loading, Playing, Menu };

pub const fps = 60;
pub const screen_width = 800;
pub const screen_height = 420;
pub const screen_title = "Tettris";
pub const default_window_background_hex = "#00000055";

pub const texture_sheet_padding = 16;
pub const sprite_sheet_path = "./src/game/assets/MASTER.png";

pub fn handleDrawDev(dev_mode: *bool, frame_count: *i32, game_time: *u32) void {
    if (dev_mode.* != true) return;
    rl.drawText(rl.textFormat(("FPS: %i"), .{rl.getFPS()}), 8, 8, 10, rl.Color.white);
    rl.drawText(rl.textFormat(("Game Time: %i s"), .{game_time.*}), 8, 44, 10, rl.Color.white);
    rl.drawText(rl.textFormat(("Frame Count: %i"), .{frame_count.*}), 8, 32, 10, rl.Color.white);
    rl.drawText(rl.textFormat(("Frame Tick: %02.02f ms"), .{rl.getFrameTime()}), 8, 20, 10, rl.Color.white);
}

pub fn handleUpdate(game_mode: *GameState, shape: *mdl.Shape, board: *[10][5]u1, frame_count: *i32, game_time: *u32, game_speed: *u8, game_level: *u8) void {
    frame_count.* += 1;
    _ = game_speed;
    _ = game_level;
    _ = board;

    if (frame_count.* > rl.getFPS()) {
        frame_count.* = 0;
        game_time.* += 1;
    }

    switch (game_mode.*) {
        .Start => {},
        .Loading => {},
        .Menu => {},
        .Playing => {
            shape.*.update(frame_count);
        },
    }
}

pub fn handleDraw(game_mode: *GameState) void {
    switch (game_mode.*) {
        .Start => {},
        .Loading => {},
        .Menu => {},
        .Playing => {},
    }
}

pub fn toggleDevMode(dev_mode: *bool) void {
    if (dev_mode.* == true) {
        dev_mode.* = false;
    } else {
        dev_mode.* = true;
    }
}
