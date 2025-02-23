const rl = @import("raylib");
const bl = @import("./ball.zig");
const tm = @import("./timmer.zig");
const ply = @import("./player.zig");
const btn = @import("./button.zig");
const bg = @import("./background.zig");
const sb = @import("./scoreboard.zig");

const Mode = enum { Default };
pub const State = enum { Start, Play, Complete, Pause };

pub const Game = struct {
    mode: Mode,
    state: State,
    ball: bl.Ball,
    rally_count: u32,
    serve_count: u32,
    players: *[4]*ply.Player,
    start_button: btn.Button,
    background: bg.Background,
    scoreboard: sb.Scoreboard,

    pub fn draw(self: *Game) !void {
        switch (self.state) {
            .Start => return drawStartState(self),
            .Play => return try drawPlayState(self),
            .Pause => return try drawPauseState(self),
            .Complete => return drawCompleteState(self),
        }
    }

    pub fn unload(self: *Game) void {
        self.start_button.unload();
    }

    pub fn update(self: *Game) !void {
        switch (self.state) {
            .Start => return updateStartState(self),
            .Play => return try updatePlayState(self),
            .Pause => return updatePauseState(self),
            .Complete => return updateCompleteState(self),
        }
    }

    fn drawCompleteState(self: *Game) void {
        _ = self;
    }

    fn drawPauseState(self: *Game) !void {
        try drawPlayState(self);
    }

    fn drawPlayState(self: *Game) !void {
        self.background.draw();
        self.ball.draw();
        try self.scoreboard.draw(self);
        for (self.players) |p| p.draw();
    }

    fn drawStartState(self: *Game) void {
        self.start_button.draw();
    }

    fn updateCompleteState(self: *Game) void {
        _ = self;
    }

    fn updatePauseState(self: *Game) void {
        if (rl.isKeyPressed(.p)) {
            self.state = .Play;
            return;
        }
    }

    fn updatePlayState(self: *Game) !void {
        if (rl.isKeyPressed(.p)) {
            self.state = .Pause;
            return;
        }

        try self.scoreboard.update();
        for (self.players.*) |p| try p.*.update(self);
        self.ball.update(self);
    }

    fn updateStartState(self: *Game) void {
        self.start_button.update(self);
    }
};

pub fn createGame(players: *[4]*ply.Player) !Game {
    const start_button = try btn.createStartButton(
        rl.Vector2.init(0, 0),
        "./src/commands/games/pong/assets/desktop-haunter.jpg",
        0.5,
    );

    return Game{
        .rally_count = 0,
        .serve_count = 0,
        .state = .Start,
        .mode = .Default,
        .players = players,
        .start_button = start_button,
        .background = bg.createBackground(),
        .scoreboard = sb.createScoreboard(),
        .ball = bl.createBall(rl.Vector2.init(400, 210), 10),
    };
}
