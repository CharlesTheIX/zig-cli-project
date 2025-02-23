const std = @import("std");
const rl = @import("raylib");
const gm = @import("./game.zig");
const rand = @import("../helpers/random.zig");

pub const Ball = struct {
    radius: f32,
    color: rl.Color,
    velocity: rl.Vector2,
    position: rl.Vector2,

    pub fn init() Ball {
        const rand_velocity_x = @as(f32, @floatFromInt(rand.randomNumber(7, 10)));
        const rand_velocity_y = @as(f32, @floatFromInt(rand.randomNumber(2, 7)));

        return Ball{
            .radius = 10,
            .color = rl.Color.green,
            .position = rl.Vector2.init(400, 210),
            .velocity = rl.Vector2.init(rand_velocity_x, rand_velocity_y),
        };
    }

    pub fn draw(self: Ball) void {
        rl.drawCircle(
            @intFromFloat(self.position.x),
            @intFromFloat(self.position.y),
            self.radius,
            self.color,
        );
    }

    pub fn update(self: *Ball, game: *gm.Game) void {
        const window_left = self.position.x - self.radius <= 0;
        const window_right = @as(i32, @intFromFloat(self.position.x + self.radius)) >= rl.getScreenWidth();
        const window_top = self.position.y - self.radius <= 0;
        const window_bottom = @as(i32, @intFromFloat(self.position.y + self.radius)) >= rl.getScreenHeight();

        if (window_left or window_right) {
            if (window_right) game.*.players.*[0].*.score += 1;
            if (window_left) game.*.players.*[1].*.score += 1;

            game.*.rally_count = 0;
            self.position.x = 400;
            self.position.y = 210;
            self.velocity.x = blk: {
                var rand_no = @as(f32, @floatFromInt(rand.randomNumber(5, 8)));
                if (rand.randomBoolean()) rand_no *= -1;
                break :blk rand_no;
            };
            self.velocity.y = blk: {
                var rand_no = @as(f32, @floatFromInt(rand.randomNumber(2, 7)));
                if (rand.randomBoolean()) rand_no *= -1;
                break :blk rand_no;
            };
        }

        if (window_top or window_bottom) self.velocity.y *= -1;

        self.position.x += self.velocity.x;
        self.position.y += self.velocity.y;
    }
};
