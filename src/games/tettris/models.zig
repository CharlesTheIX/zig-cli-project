const math = std.math;
const std = @import("std");
const rl = @import("raylib");
const gbl = @import("./globals.zig");

const Direction = enum { Up, Down, Left, Right, Drop };

const Shape = struct {
    matrix: *rl.Matrix,
    texture: *rl.Texture,
    position: rl.Vector2,
    direction: Direction,

    pub fn init(matrix: *rl.Matrix, texture: *rl.Texture) Shape {
        const position = rl.Vector2.init(0, 0);
        return Shape{ .matrix = matrix, .texture = texture, .position = position, .direction = Direction.Down };
    }

    pub fn update(self: Shape, frame_count: *i32) void {
        if (frame_count.* >= rl.getFPS()) {
            self.translate(.Down);
            return;
        }

        if (rl.isKeyPressed(.j)) self.rotate(.Left);
        if (rl.isKeyPressed(.l)) self.rotate(.Right);
        if (rl.isKeyPressed(.w)) self.translate(.Up);
        if (rl.isKeyPressed(.s)) self.translate(.Down);
        if (rl.isKeyPressed(.a)) self.translate(.Left);
        if (rl.isKeyPressed(.d)) self.translate(.Right);
        if (rl.isKeyPressed(.space)) self.translate(.Drop);
    }

    pub fn rotate(self: Shape, direction: Direction) void {
        var next_matrix = self.matrix;
        var rotation: f32 = 0;

        switch (direction) {
            .Left => rotation = math.pi / 2.0,
            .Right => rotation = math.pi / -2.0,
            else => return,
        }

        next_matrix = next_matrix.rotateX(rotation);
        //TODO: Check potential collisions

        self.matrix.* = next_matrix;
        self.direction = direction;
    }

    pub fn translate(self: Shape, direction: Direction) void {
        var next_position = self.position;
        var translation = rl.Vector2.init(0, 0);

        switch (direction) {
            // .Up => translation -= 16,
            .Down => translation.y += 16,
            .Left => translation.x -= 16,
            .Right => translation.x += 16,
            .Drop => return, // TODO: Create to drop functionality
            else => return,
        }

        next_position = next_position.add(translation);
        //TODO: Check for potential collisions

        self.position = next_position;
    }
};

pub const Board = struct {
    state: [][]u1,

    pub fn init(rows: u8, columns: u8) Board {
        var init_state = [_][]u1{};
        for (rows) |row| {
            for (columns) |column| init_state[row][column] = 0;
        }
        return Board{ .state = init_state };
    }
};
