const rl = @import("raylib");
const hex = @import("./hex.zig");
const mdl = @import("./models.zig");
const gbl = @import("./globals.zig");

pub fn init() !void {
    var time: u32 = 0;
    var speed: u8 = 1;
    var level: u8 = 1;
    var frame_count: i32 = 0;
    var dev_mode = false;
    const is_resizeable = false;
    const has_full_screen_toggle = false;
    var game_mode = gbl.GameState.Start;
    var board = mdl.Board.init(10, 5);
    const background_color = hex.hexToColor(gbl.default_window_background_hex);
    const my_matrix = rl.Matrix{ .m0 = 1, .m1 = 0, .m4 = 0, .m5 = 1 };

    rl.initWindow(gbl.screen_width, gbl.screen_height, gbl.screen_title);
    rl.setWindowState(rl.ConfigFlags{ .window_resizable = is_resizeable == true });
    rl.setTargetFPS(gbl.fps);
    defer rl.closeWindow();

    const image = try rl.loadImage(gbl.sprite_sheet_path);
    var texture = try rl.loadTextureFromImage(image);
    defer rl.unloadTexture(texture);
    rl.unloadImage(image);

    const shape = mdl.Shape.init(my_matrix, &texture);

    while (!rl.windowShouldClose()) {
        if (has_full_screen_toggle == true and rl.isKeyPressed(.f)) rl.toggleFullscreen();
        if (rl.isKeyPressed(.q)) gbl.toggleDevMode(&dev_mode);

        gbl.handleUpdate(&game_mode, &shape, &board, &frame_count, &time, &speed, &level);

        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(background_color);

        gbl.handleDraw(&game_mode);
        gbl.handleDrawDev(&dev_mode, &frame_count, &time);
    }
}
