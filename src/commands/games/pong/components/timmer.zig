const std = @import("std");
const rl = @import("raylib");

pub const Timmer = struct {
    time: u24,
    count: u6,
    hidden: bool,
    font_size: u10,
    position: rl.Vector2,

    pub fn init(x: f32, y: f32, hidden: bool) Timmer {
        return Timmer{
            .time = 0,
            .count = 0,
            .font_size = 36,
            .hidden = hidden,
            .position = rl.Vector2.init(x, y),
        };
    }

    pub fn update(self: *Timmer) void {
        self.count += 1;
        if (self.count + 1 <= 60) return;
        self.count = 0;
        self.time += 1;
    }

    pub fn draw(self: Timmer) !void {
        if (self.hidden) return;

        var timmer_buffer: [32:0]u8 = undefined;
        const minutes = std.math.floor(@as(f32, @floatFromInt(self.time / 60)));
        const seconds = self.time % 60;
        const timmer = try std.fmt.bufPrintZ(&timmer_buffer, "{d}:{d}", .{ minutes, seconds });
        const timmer_width = rl.measureText(timmer, self.font_size);
        const delta_timmer_x = @as(i32, @intFromFloat(self.position.x - @as(f32, @floatFromInt(@divFloor(timmer_width, 2)))));
        const delta_timmer_y = @as(i32, @intFromFloat(self.position.y - @as(f32, @floatFromInt(self.font_size))));

        rl.drawText(timmer, delta_timmer_x, delta_timmer_y, self.font_size, rl.Color.white);
    }
};
