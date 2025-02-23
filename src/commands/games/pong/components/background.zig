const rl = @import("raylib");
const gm = @import("./game.zig");

pub const Background = struct {
    pub fn init() Background {
        return Background{};
    }

    pub fn draw(self: Background, game: *gm.Game) void {
        _ = self;
        switch (game.*.state) {
            .Play => {
                rl.drawLine(@divFloor(rl.getScreenWidth(), 2), 0, @divFloor(rl.getScreenWidth(), 2), rl.getScreenHeight(), rl.Color.white);
                return;
            },
            else => return,
        }
    }
};
