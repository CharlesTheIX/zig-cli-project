const rl = @import("raylib");
const gm = @import("./game.zig");

pub const Background = struct {
    pub fn draw(self: Background) void {
        _ = self;
        rl.drawLine(
            @divFloor(rl.getScreenWidth(), 2),
            0,
            @divFloor(rl.getScreenWidth(), 2),
            rl.getScreenHeight(),
            rl.Color.white,
        );
    }
};

pub fn createBackground() Background {
    return Background{};
}
