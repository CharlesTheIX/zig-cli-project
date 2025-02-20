const rl = @import("raylib");

pub const Background = struct {
    pub fn init() Background {
        return Background{};
    }

    pub fn draw(self: Background) void {
        _ = self;
        rl.drawLine(@divFloor(rl.getScreenWidth(), 2), 0, @divFloor(rl.getScreenWidth(), 2), rl.getScreenHeight(), rl.Color.white);
    }
};
