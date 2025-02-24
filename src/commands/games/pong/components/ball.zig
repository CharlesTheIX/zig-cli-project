const std = @import("std");
const rl = @import("raylib");
const gm = @import("./game.zig");
const rand = @import("../helpers/random.zig");

pub const Ball = struct {
    radius: f32,
    color: rl.Color,
    position: rl.Vector2,
    velocity: rl.Vector2,
    min_velocity: rl.Vector2,
    max_velocity: rl.Vector2,
    acceleration: rl.Vector2,

    pub fn draw(self: Ball) void {
        rl.drawCircle(
            @intFromFloat(self.position.x),
            @intFromFloat(self.position.y),
            self.radius,
            self.color,
        );
    }

    pub fn update(self: *Ball, game: *gm.Game) !void {
        const window_left = self.position.x - self.radius <= 0;
        const window_right = @as(i32, @intFromFloat(self.position.x + self.radius)) >= rl.getScreenWidth();
        const window_top = self.position.y - self.radius <= 0;
        const window_bottom = @as(i32, @intFromFloat(self.position.y + self.radius)) >= rl.getScreenHeight();

        if (window_left or window_right) {
            var player_index: u2 = 0;
            if (window_right) player_index = 0;
            if (window_left) player_index = 1;
            handleGoal(self, game, player_index);
            return;
        }

        if (window_top or window_bottom) self.velocity.y *= -1;

        try updateAcceleration(self, game);
        self.position = self.position.add(self.velocity);
    }

    fn handleGoal(self: *Ball, game: *gm.Game, player_index: u2) void {
        game.*.rally_count = 0;
        game.*.players[player_index].*.score += 1;

        self.acceleration = rl.Vector2.init(0, 0);
        self.position = rl.Vector2.init(400, 210);
        self.velocity.x = blk: {
            var rand_no = @as(f32, @floatFromInt(rand.randomNumber(
                @as(i32, @intFromFloat(self.min_velocity.x)),
                @as(i32, @intFromFloat(self.max_velocity.x)),
            )));
            if (rand.randomBoolean()) rand_no *= -1;
            break :blk rand_no;
        };
        self.velocity.y = blk: {
            var rand_no = @as(f32, @floatFromInt(rand.randomNumber(
                @as(i32, @intFromFloat(self.min_velocity.y)),
                @as(i32, @intFromFloat(self.max_velocity.y)),
            )));
            if (rand.randomBoolean()) rand_no *= -1;
            break :blk rand_no;
        };
    }

    fn updateAcceleration(self: *Ball, game: *gm.Game) !void {
        const ball_accel = blk: {
            var multiplier_x: f32 = 1;
            var multiplier_y: f32 = 1;

            if (self.velocity.x < 0) multiplier_x = -1;
            if (self.velocity.y < 0) multiplier_y = -1;

            const accel = rl.Vector2.init(multiplier_x, multiplier_y);
            break :blk accel.multiply(game.*.resistance);
        };

        self.acceleration = self.acceleration.add(ball_accel);

        try std.io.getStdOut().writer().print("{d} {d}\n", .{ self.velocity.x, self.velocity.y });
        try std.io.getStdOut().writer().print("{d} {d}\n", .{ self.acceleration.x, self.acceleration.y });
        self.velocity = self.velocity.add(self.acceleration);
        try std.io.getStdOut().writer().print("{d} {d}\n", .{ self.velocity.x, self.velocity.y });

        if (self.velocity.x < self.min_velocity.x) self.velocity.x = self.min_velocity.x;
        if (self.velocity.x > self.max_velocity.x) self.velocity.x = self.max_velocity.x;
        if (self.velocity.y < self.min_velocity.y) self.velocity.y = self.min_velocity.y;
        if (self.velocity.y > self.max_velocity.y) self.velocity.y = self.max_velocity.y;
    }
};

pub fn createBall(position: rl.Vector2, radius: u32) Ball {
    const min_velocity = rl.Vector2.init(2, 2);
    const max_velocity = rl.Vector2.init(5, 5);
    const rand_velocity_x = blk: {
        var value = @as(f32, @floatFromInt(rand.randomNumber(
            @as(i32, @intFromFloat(min_velocity.x)),
            @as(i32, @intFromFloat(max_velocity.x)),
        )));
        if (rand.randomBoolean()) value *= -1;
        break :blk value;
    };
    const rand_velocity_y = blk: {
        var value = @as(f32, @floatFromInt(rand.randomNumber(
            @as(i32, @intFromFloat(min_velocity.y)),
            @as(i32, @intFromFloat(max_velocity.y)),
        )));
        if (rand.randomBoolean()) value *= -1;
        break :blk value;
    };

    return Ball{
        .position = position,
        .color = rl.Color.green,
        .min_velocity = min_velocity,
        .max_velocity = max_velocity,
        .radius = @as(f32, @floatFromInt(radius)),
        .acceleration = rl.Vector2.init(0, 0),
        .velocity = rl.Vector2.init(rand_velocity_x, rand_velocity_y),
    };
}
