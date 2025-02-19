// const rl = @import("raylib");
// const hex = @import("./hex.zig");
// const mdl = @import("./models.zig");
// const gbl = @import("./globals.zig");

pub fn main() !void {
    // var game_time: u32 = 0;
    // var game_speed: u4 = 1;
    // var frame_count: i32 = 0;
    // var dev_mode = false;
    // const is_resizeable = false;
    // const has_full_screen_toggle = false;
    // var game_mode = gbl.GameState.Start;
    // const background_color = hex.hexToColor(gbl.default_window_background_hex);

    // rl.initWindow(gbl.screen_width, gbl.screen_height, gbl.screen_title);
    // defer rl.closeWindow();

    // const image = try rl.loadImage(gbl.sprite_sheet_path);
    // var texture = try rl.loadTextureFromImage(image);
    // defer rl.unloadTexture(texture);
    // rl.setTargetFPS(gbl.fps);
    // rl.unloadImage(image);

    // if (is_resizeable == true) rl.setWindowState(rl.ConfigFlags{ .window_resizable = true });

    // var player = mdl.Player.init(&texture, &game_speed);

    // while (!rl.windowShouldClose()) {
    //     if (has_full_screen_toggle == true and rl.isKeyPressed(.f)) rl.toggleFullscreen();
    //     if (rl.isKeyPressed(.q)) gbl.toggleDevMode(&dev_mode);

    //     gbl.handleUpdate(&game_mode, &player, &frame_count, &game_time);

    //     rl.beginDrawing();
    //     defer rl.endDrawing();
    //     rl.clearBackground(background_color);
    //     gbl.handleDraw(&game_mode, &player);
    //     gbl.handleDrawDev(&dev_mode, &frame_count, &game_time);
    // }
}
