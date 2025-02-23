const std = @import("std");
const rl = @import("raylib");
const gm = @import("./game.zig");
const tm = @import("./timmer.zig");
const ply = @import("./player.zig");

pub const Scoreboard = struct {
    font_size: u10,
    timmer: tm.Timmer,

    pub fn draw(self: Scoreboard, game: *gm.Game) !void {
        try drawTimmer(self);
        try drawScoreBoard(self, game);
        try drawRallyCount(self, game);
    }

    pub fn update(self: *Scoreboard) !void {
        self.timmer.update();
    }

    fn drawRallyCount(self: Scoreboard, game: *gm.Game) !void {
        var rally_count_buffer: [32:0]u8 = undefined;
        const rally_count = try std.fmt.bufPrintZ(&rally_count_buffer, "Rally Count: {d}", .{game.*.rally_count});
        const rally_count_width = rl.measureText(rally_count, self.font_size);
        var delta_rally_count: i32 = 0;
        delta_rally_count = 12;
        _ = rally_count_width;

        rl.drawText(rally_count, delta_rally_count, 12, self.font_size, rl.Color.white);
    }

    fn drawScoreBoard(self: Scoreboard, game: *gm.Game) !void {
        for (game.*.players, 0..) |player, index| {
            if (player.player_type == .Inactive) continue;

            var delta_name: i32 = 0;
            var delta_score: i32 = 0;
            var name_buffer: [32:0]u8 = undefined;
            var score_buffer: [32:0]u8 = undefined;
            const name = try std.fmt.bufPrintZ(&name_buffer, "{s}", .{player.name});
            const score = try std.fmt.bufPrintZ(&score_buffer, "{d}", .{player.score});
            const name_width = rl.measureText(name, self.font_size);
            const score_width = rl.measureText(score, 3 * self.font_size);

            switch (index) {
                0 => {
                    delta_name = 400 - name_width - self.font_size;
                    delta_score = 400 - score_width - self.font_size;
                },
                1 => {
                    delta_name = 400 + self.font_size;
                    delta_score = 400 + self.font_size;
                },
                else => continue,
            }

            rl.drawText(name, delta_name, self.font_size, self.font_size, rl.Color.white);
            rl.drawText(score, delta_score, 3 * self.font_size, 3 * self.font_size, rl.Color.white);
        }
    }

    fn drawTimmer(self: *Scoreboard) !void {
        try self.timmer.draw();
    }
};

pub fn createScoreboard() Scoreboard {
    return Scoreboard{
        .font_size = 12,
        .timmer = tm.createTimmer(400, 210, false),
    };
}
