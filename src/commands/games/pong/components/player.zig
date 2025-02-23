const std = @import("std");
const rl = @import("raylib");
const gm = @import("./game.zig");

pub const PlayerType = enum { Human, Cpu, Inactive };
pub const Option = enum { One, Two, Three, Four, Invalid };

pub const Player = struct {
    score: u32,
    option: Option,
    color: rl.Color,
    name: []const u8,
    body: rl.Rectangle,
    velocity: rl.Vector2,
    player_type: PlayerType,
    min_velocity: rl.Vector2,
    max_velocity: rl.Vector2,
    acceleration: rl.Vector2,

    pub fn draw(self: Player) void {
        if (self.player_type == .Inactive) return;

        rl.drawRectangle(
            @intFromFloat(self.body.x),
            @intFromFloat(self.body.y),
            @intFromFloat(self.body.width),
            @intFromFloat(self.body.height),
            self.color,
        );
    }

    pub fn update(self: *Player, game: *gm.Game) !void {
        switch (self.player_type) {
            .Human => {
                handlePlayerMovement(self);
            },
            .Cpu => {
                try handleCpuMovement(self, game);
            },
            .Inactive => return,
        }

        handleBallCollision(self.*, game);
    }

    fn handleBallCollision(self: Player, game: *gm.Game) void {
        const collision = rl.checkCollisionCircleRec(
            game.*.ball.position,
            game.*.ball.radius,
            self.body,
        );

        if (!collision) return;

        const direction_up = game.*.ball.velocity.y > 0 and game.*.ball.position.y < self.body.y;
        const direction_down = game.*.ball.velocity.y < 0 and game.*.ball.position.y > self.body.y + self.body.height;
        const direction_left = game.*.ball.velocity.x > 0 and game.*.ball.position.x < self.body.x;
        const direction_right = game.*.ball.velocity.x < 0 and game.*.ball.position.x > self.body.x + self.body.width;

        if (direction_up or direction_down) game.*.ball.velocity.y *= -1;

        if (direction_left or direction_right) game.*.ball.velocity.x *= -1;

        game.*.rally_count += 1;
    }

    fn handleCpuMovement(self: *Player, game: *gm.Game) !void {
        self.velocity.x = 0;
        self.velocity.y = 0;

        try std.io.getStdOut().writer().print("{d}, {d}\n", .{ self.body.y, game.*.ball.position.y });

        if (self.body.y + @divFloor(self.body.height, 2) > game.*.ball.position.y) {
            self.velocity.y = -5;
            self.body.y += self.velocity.y;
        } else if (self.body.y < game.*.ball.position.y) {
            self.velocity.y = 5;
            self.body.y += self.velocity.y;
        }

        if (self.body.y < 0) {
            self.body.y = 0;
        } else if (self.body.y + self.body.height >= 420) {
            self.body.y = 420 - self.body.height;
        }
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
            },
            else => return,
        }

        if (self.body.y < 0) {
            self.body.y = 0;
        } else if (self.body.y + self.body.height > 420) {
            self.body.y = 420 - self.body.height;
        }
    }
};

pub fn createCpu(option: Option) Player {
    var x: f32 = 0;
    var y: f32 = 160;
    var width: f32 = 16;
    const score: u32 = 0;
    var height: f32 = 100;
    var name: []const u8 = "CPU 1";

    switch (option) {
        .One => {},
        .Two => {
            x = 784;
            name = "CPU 2";
        },
        .Three => {
            x = 350;
            y = 0;
            width = 100;
            height = 16;
            name = "CPU 3";
        },
        .Four => {
            x = 350;
            y = 404;
            width = 100;
            height = 16;
            name = "CPU 4";
        },
        else => return createInactivePlayer(),
    }

    return Player{
        .score = score,
        .name = name,
        .option = option,
        .color = rl.Color.white,
        .player_type = .Cpu,
        .velocity = rl.Vector2.init(0, 0),
        .acceleration = rl.Vector2.init(0, 0),
        .min_velocity = rl.Vector2.init(3, 3),
        .max_velocity = rl.Vector2.init(12, 12),
        .body = rl.Rectangle.init(x, y, width, height),
    };
}

pub fn createHuman(option: Option) Player {
    var x: f32 = 0;
    var y: f32 = 160;
    var width: f32 = 16;
    const score: u32 = 0;
    var height: f32 = 100;
    var name: []const u8 = "Player one";

    switch (option) {
        .One => {},
        .Two => {
            x = 784;
            name = "Player 2";
        },
        .Three => {
            x = 350;
            y = 0;
            width = 100;
            height = 16;
            name = "Player 3";
        },
        .Four => {
            x = 350;
            y = 404;
            width = 100;
            height = 16;
            name = "Player 4";
        },
        else => return createInactivePlayer(),
    }

    return Player{
        .score = score,
        .name = name,
        .option = option,
        .color = rl.Color.white,
        .player_type = .Human,
        .velocity = rl.Vector2.init(0, 0),
        .acceleration = rl.Vector2.init(0, 0),
        .min_velocity = rl.Vector2.init(5, 5),
        .max_velocity = rl.Vector2.init(10, 10),
        .body = rl.Rectangle.init(x, y, width, height),
    };
}

pub fn createInactivePlayer() Player {
    return Player{
        .score = 0,
        .name = "",
        .option = .Invalid,
        .color = rl.Color.blank,
        .player_type = .Inactive,
        .velocity = rl.Vector2.init(0, 0),
        .acceleration = rl.Vector2.init(0, 0),
        .min_velocity = rl.Vector2.init(0, 0),
        .max_velocity = rl.Vector2.init(0, 0),
        .body = rl.Rectangle.init(0, 0, 0, 0),
    };
}
