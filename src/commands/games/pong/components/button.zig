const std = @import("std");
const rl = @import("raylib");
const gm = @import("./game.zig");

const ButtonType = enum { Default, Start };

pub const Button = struct {
    scale: f32,
    body: rl.Rectangle,
    texture: rl.Texture2D,
    button_type: ButtonType,

    pub fn draw(self: Button) void {
        rl.drawTexture(
            self.texture,
            @as(i32, @intFromFloat(self.body.x)),
            @as(i32, @intFromFloat(self.body.y)),
            rl.Color.white,
        );
    }

    pub fn unload(self: *Button) void {
        self.texture.unload();
    }

    pub fn update(self: Button, game: *gm.Game) void {
        handlePressed(self, game);
    }

    fn handlePressed(self: Button, game: *gm.Game) void {
        if (!rl.isMouseButtonPressed(rl.MouseButton.left)) return;

        const isCollision = rl.checkCollisionPointRec(rl.getMousePosition(), self.body);
        if (!isCollision) return;

        switch (self.button_type) {
            .Start => {
                game.*.state = gm.State.Play;
            },
            else => return,
        }
    }
};

pub fn createStartButton(position: rl.Vector2, image_path: [*:0]const u8, scale: f32) !Button {
    var image = try rl.loadImage(image_path);
    defer image.unload();

    const image_width = @as(f32, @floatFromInt(image.width)) * scale;
    const image_height = @as(f32, @floatFromInt(image.height)) * scale;
    rl.imageResize(
        &image,
        @as(i32, @intFromFloat(image_width)),
        @as(i32, @intFromFloat(image_height)),
    );

    return Button{
        .scale = scale,
        .button_type = .Start,
        .texture = try rl.Texture2D.fromImage(image),
        .body = rl.Rectangle.init(position.x, position.x, image_width, image_height),
    };
}

pub fn createTextureButton(position: rl.Vector2, image_path: [*:0]const u8, scale: f32) !Button {
    var image = try rl.loadImage(image_path);
    defer image.unload();

    const image_width = @as(f32, @floatFromInt(image.width)) * scale;
    const image_height = @as(f32, @floatFromInt(image.height)) * scale;
    rl.imageResize(
        &image,
        @as(i32, @intFromFloat(image_width)),
        @as(i32, @intFromFloat(image_height)),
    );

    return Button{
        .scale = scale,
        .button_type = .Default,
        .texture = try rl.Texture2D.fromImage(image),
        .body = rl.Rectangle.init(position.x, position.x, image_width, image_height),
    };
}
