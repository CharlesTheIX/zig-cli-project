const rl = @import("raylib");
const bl = @import("./ball.zig");

pub const PlayerType = enum { Human, Cpu };
pub const Option = enum { One, Two, Three, Four };

pub const Player = struct {
    score: u32,
    option: Option,
    color: rl.Color,
    body: rl.Rectangle,
    velocity: rl.Vector2,
    player_type: PlayerType,

    pub fn createHuman(option: Option) Player {
        var x: f32 = 0;
        var y: f32 = 160;
        var width: f32 = 16;
        const score: u32 = 0;
        var height: f32 = 100;

        switch (option) {
            .One => {},
            .Two => {
                x = 784;
            },
            .Three => {
                x = 350;
                y = 0;
                width = 100;
                height = 16;
            },
            .Four => {
                x = 350;
                y = 404;
                width = 100;
                height = 16;
            },
        }

        return Player{
            .score = score,
            .option = option,
            .color = rl.Color.white,
            .player_type = .Human,
            .velocity = rl.Vector2.init(0, 0),
            .body = rl.Rectangle.init(x, y, width, height),
        };
    }

    pub fn createCpu(option: Option) Player {
        var x: f32 = 0;
        var y: f32 = 160;
        var width: f32 = 16;
        const score: u32 = 0;
        var height: f32 = 100;

        switch (option) {
            .One => {},
            .Two => {
                x = 784;
            },
            .Three => {
                x = 350;
                y = 0;
                width = 100;
                height = 16;
            },
            .Four => {
                x = 350;
                y = 404;
                width = 100;
                height = 16;
            },
        }

        return Player{
            .score = score,
            .option = option,
            .color = rl.Color.white,
            .player_type = PlayerType.Cpu,
            .velocity = rl.Vector2.init(0, 0),
            .body = rl.Rectangle.init(x, y, width, height),
        };
    }

    pub fn draw(self: Player) void {
        rl.drawRectangle(
            @intFromFloat(self.body.x),
            @intFromFloat(self.body.y),
            @intFromFloat(self.body.width),
            @intFromFloat(self.body.height),
            self.color,
        );
    }

    pub fn update(self: *Player, ball: *bl.Ball) void {
        switch (self.player_type) {
            .Human => {
                handlePlayerMovement(self);
            },
            .Cpu => {},
        }

        handleBallCollision(self.*, ball);
    }

    fn handlePlayerMovement(self: *Player) void {
        self.velocity.x = 0;
        self.velocity.y = 0;

        switch (self.option) {
            .One => {
                if (rl.isKeyDown(.w)) {
                    self.velocity.y = 5;
                    self.body.y -= self.velocity.y;
                } else if (rl.isKeyDown(.s)) {
                    self.velocity.y = 5;
                    self.body.y += self.velocity.y;
                }

                if (self.body.y < 0) {
                    self.body.y = 0;
                } else if (self.body.y + self.body.height > 420) {
                    self.body.y = 420 - self.body.height;
                }
            },
            else => {
                return;
            },
        }
    }

    fn handleBallCollision(self: Player, ball: *bl.Ball) void {
        const collision = rl.checkCollisionCircleRec(
            ball.position,
            ball.radius,
            self.body,
        );

        if (!collision) return;

        const direction_up = ball.*.velocity.y > 0 and ball.*.position.y < self.body.y;
        const direction_down = ball.*.velocity.y < 0 and ball.*.position.y > self.body.y + self.body.height;
        const direction_left = ball.*.velocity.x > 0 and ball.*.position.x < self.body.x;
        const direction_right = ball.*.velocity.x < 0 and ball.*.position.x > self.body.x + self.body.width;

        if (direction_up or direction_down) ball.*.velocity.y *= -1;

        if (direction_left or direction_right) ball.*.velocity.x *= -1;
    }
};
