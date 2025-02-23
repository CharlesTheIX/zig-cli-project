const bl = @import("./ball.zig");
const tm = @import("./timmer.zig");
const ply = @import("./player.zig");
const bg = @import("./background.zig");
const sb = @import("./scoreboard.zig");

const Mode = enum { Default };
const State = enum { Start, Play, Complete, Pause };

pub const Game = struct {
    mode: Mode,
    state: State,
    ball: *bl.Ball,
    rally_count: u32,
    serve_count: u32,
    players: *[4]*ply.Player,
    background: *bg.Background,
    scoreboard: *sb.Scoreboard,

    pub fn init(
        players: *[4]*ply.Player,
        ball: *bl.Ball,
        background: *bg.Background,
        scoreboard: *sb.Scoreboard,
    ) Game {
        return Game{
            .ball = ball,
            .rally_count = 0,
            .serve_count = 0,
            .state = .Start,
            .mode = .Default,
            .players = players,
            .background = background,
            .scoreboard = scoreboard,
        };
    }

    pub fn update(self: *Game) !void {
        switch (self.state) {
            .Start => {},
            .Play => {
                try self.scoreboard.*.update();
                for (self.players.*) |p| try p.*.update(self);
                self.ball.*.update(self);
                return;
            },
            else => return,
        }
    }

    pub fn draw(self: *Game) !void {
        self.background.*.draw(self);

        switch (self.state) {
            .Start => {},
            .Play => {
                self.ball.*.draw();
                try self.scoreboard.*.draw(self);
                for (self.players.*) |p| p.*.draw();
                return;
            },
            else => return,
        }
    }
};
