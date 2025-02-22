// const rl = @import("raylib");
// const gbl = @import("./globals.zig");

// const Direction = enum { Up, Down, Left, Right };

// pub const Player = struct {
//     game_speed: *u4,
//     texture: *rl.Texture,
//     direction: Direction,
//     player_frame_count: u8,
//     current_frame_index: u8,

//     const width = 16;
//     const height = 32;
//     const reset_value = 30;
//     const frames = [16][2]u32{ .{ 0, 0 }, .{ 1, 0 }, .{ 2, 0 }, .{ 3, 0 }, .{ 4, 0 }, .{ 5, 0 }, .{ 6, 0 }, .{ 7, 0 }, .{ 8, 0 }, .{ 9, 0 }, .{ 10, 0 }, .{ 11, 0 }, .{ 12, 0 }, .{ 13, 0 }, .{ 14, 0 }, .{ 15, 0 } };

//     var position = rl.Vector2.init((gbl.screen_width - width) / 2, (gbl.screen_height - height) / 2);
//     var current_frame = rl.Rectangle.init(@as(f32, @floatFromInt(frames[0][0] * width + gbl.texture_sheet_padding)), @as(f32, @floatFromInt(frames[0][1] * height + gbl.texture_sheet_padding)), width, height);

//     pub fn init(texture: *rl.Texture, game_speed: *u4) Player {
//         return Player{ .game_speed = game_speed, .texture = texture, .player_frame_count = 0, .current_frame_index = 0, .direction = Direction.Down };
//     }

//     pub fn handlePlayerInputs(self: *Player) void {
//         var is_moving = true;
//         var delta = self.game_speed.*;
//         var next_position = [2]f32{ position.x, position.y };

//         if (rl.isKeyDown(.right_shift) or rl.isKeyDown(.left_shift)) delta *= 2;

//         self.player_frame_count += delta;

//         if (self.player_frame_count > reset_value) self.player_frame_count = 0;

//         switch (gbl.movement_type) {
//             .OneDirection2D => {
//                 if (rl.isKeyDown(.w) or rl.isKeyDown(.up)) {
//                     self.direction = Direction.Up;
//                     next_position[1] -= @floatFromInt(delta);
//                 } else if (rl.isKeyDown(.s) or rl.isKeyDown(.down)) {
//                     self.direction = Direction.Down;
//                     next_position[1] += @floatFromInt(delta);
//                 } else if (rl.isKeyDown(.a) or rl.isKeyDown(.left)) {
//                     self.direction = Direction.Left;
//                     next_position[0] -= @floatFromInt(delta);
//                 } else if (rl.isKeyDown(.d) or rl.isKeyDown(.right)) {
//                     self.direction = Direction.Right;
//                     next_position[0] += @floatFromInt(delta);
//                 } else {
//                     is_moving = false;
//                 }
//             },
//             .MultiDirection2D => {
//                 if (rl.isKeyDown(.w) or rl.isKeyDown(.up)) {
//                     self.direction = Direction.Up;
//                     next_position[1] -= @floatFromInt(delta);
//                 }

//                 if (rl.isKeyDown(.s) or rl.isKeyDown(.down)) {
//                     self.direction = Direction.Down;
//                     next_position[1] += @floatFromInt(delta);
//                 }

//                 if (rl.isKeyDown(.a) or rl.isKeyDown(.left)) {
//                     self.direction = Direction.Left;
//                     next_position[0] -= @floatFromInt(delta);
//                 }

//                 if (rl.isKeyDown(.d) or rl.isKeyDown(.right)) {
//                     self.direction = Direction.Right;
//                     next_position[0] += @floatFromInt(delta);
//                 }
//             },
//         }

//         const collision = getPlayerCollisions(&next_position);

//         if (collision == true) {
//             // is_moving = false;
//             next_position[0] = position.x;
//             next_position[1] = position.y;
//         }

//         if (is_moving == true) setNextFrame();

//         position.x = next_position[0];
//         position.y = next_position[1];
//     }

//     pub fn draw(self: Player) void {
//         self.texture.*.drawRec(current_frame, position, rl.Color.white);
//     }

//     fn getPlayerCollisions(next_position: *[2]f32) bool {
//         var collision = false;
//         const window_x_range = [2]u16{ 0, gbl.screen_width };
//         const window_y_range = [2]u16{ 0, gbl.screen_height };

//         if (next_position[0] <= window_x_range[0] or next_position[0] + width >= window_x_range[1]) collision = true;
//         if (next_position[1] <= window_y_range[0] or next_position[1] + height >= window_y_range[1]) collision = true;
//         return collision;
//     }

//     fn setNextFrame(self: Player) void {
//         var step: u8 = 0;
//         const frame_ratio = @divFloor(reset_value, 4);

//         if (self.player_frame_count < frame_ratio) {
//             step = 0;
//         } else if (self.player_frame_count < 2 * frame_ratio) {
//             step = 1;
//         } else if (self.player_frame_count < 3 * frame_ratio) {
//             step = 2;
//         } else {
//             step = 3;
//         }

//         switch (self.direction) {
//             .Up => self.current_frame_index = 4 + step,
//             .Down => self.current_frame_index = 0 + step,
//             .Left => self.current_frame_index = 8 + step,
//             .Right => self.current_frame_index = 12 + step,
//         }

//         current_frame.x = @as(f32, @floatFromInt(frames[self.current_frame_index][0] * width + gbl.texture_sheet_padding));
//         current_frame.y = @as(f32, @floatFromInt(frames[self.current_frame_index][1] * height + gbl.texture_sheet_padding));
//     }
// };
