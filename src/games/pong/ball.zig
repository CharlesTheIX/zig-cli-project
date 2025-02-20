const rl = @import("raylib");

pub const Ball = struct {
    radius: f32,
    color: rl.Color,
    velocity: rl.Vector2,
    position: rl.Vector2,

    pub fn init() Ball {
        return Ball{
            .radius = 10,
            .color = rl.Color.green,
            .velocity = rl.Vector2.init(5, 5),
            .position = rl.Vector2.init(400, 210),
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

    pub fn update(self: *Ball) void {
        handleCollisions(self);
        self.position.x += self.velocity.x;
        self.position.y += self.velocity.y;
    }

    fn handleCollisions(self: *Ball) void {
        const window_left = self.position.x - self.radius <= 0;
        const window_right = @as(i32, @intFromFloat(self.position.x + self.radius)) >= rl.getScreenWidth();
        const window_top = self.position.y - self.radius <= 0;
        const window_bottom = @as(i32, @intFromFloat(self.position.y + self.radius)) >= rl.getScreenHeight();

        if (window_left or window_right) {
            // self.velocity.x *= -1;

            if (self.position.x - (2 * self.radius) <= 0)
                return;
        }

        if (window_top or window_bottom) {
            self.velocity.y *= -1;
            return;
        }
    }
};
