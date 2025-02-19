// const rl = @import("raylib");
// const mdl = @import("./models.zig");

// pub const GameType = enum { TopDown, Platform };
// pub const GameState = enum { Start, Loading, Playing, Menu };
// pub const MovementType = enum { OneDirection2D, MultiDirection2D };

// pub const fps = 60;
// pub const screen_width = 800;
// pub const screen_height = 420;
// pub const screen_title = "David's Game";
// pub const default_window_background_hex = "#00000055";

// pub const texture_sheet_padding = 16;
// pub const sprite_sheet_path = "./src/game/assets/MASTER.png";

// pub const movement_type = MovementType.OneDirection2D;

// pub fn handleDrawDev(dev_mode: *bool, frame_count: *i32, game_time: *u32) void {
//     if (dev_mode.* != true) return;
//     rl.drawText(rl.textFormat(("FPS: %i"), .{rl.getFPS()}), 8, 8, 10, rl.Color.white);
//     rl.drawText(rl.textFormat(("Game Time: %i s"), .{game_time.*}), 8, 44, 10, rl.Color.white);
//     rl.drawText(rl.textFormat(("Frame Count: %i"), .{frame_count.*}), 8, 32, 10, rl.Color.white);
//     rl.drawText(rl.textFormat(("Frame Tick: %02.02f ms"), .{rl.getFrameTime()}), 8, 20, 10, rl.Color.white);
// }

// pub fn handleUpdate(game_mode: *GameState, player: *mdl.Player, frame_count: *i32, game_time: *u32) void {
//     frame_count.* += 1;

//     if (frame_count.* >= rl.getFPS()) {
//         frame_count.* = 0;
//         game_time.* += 1;
//     }

//     switch (game_mode.*) {
//         .Start => {
//             player.*.handlePlayerInputs();
//         },
//         .Loading => {},
//         .Menu => {},
//         .Playing => {},
//     }
// }

// pub fn handleDraw(game_mode: *GameState, player: *mdl.Player) void {
//     switch (game_mode.*) {
//         .Start => {
//             player.*.draw();
//         },
//         .Loading => {},
//         .Menu => {},
//         .Playing => {
//             player.*.draw();
//         },
//     }
// }

// pub fn toggleDevMode(dev_mode: *bool) void {
//     if (dev_mode.* == true) {
//         dev_mode.* = false;
//     } else {
//         dev_mode.* = true;
//     }
// }
