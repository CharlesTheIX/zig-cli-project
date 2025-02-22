const std = @import("std");

pub const Base64 = struct {
    table: *const [64]u8,

    pub fn init() Base64 {
        const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const lower = "abcdefghijklmnopqrstuvwxyz";
        const numbers_symbols = "0123456789+/";
        return Base64{
            .table = upper ++ lower ++ numbers_symbols,
        };
    }

    pub fn encode(self: Base64, allocator: std.mem.Allocator, input: []const u8) ![]u8 {
        if (input.len == 0) return "";

        const output_length = try getEncodeLength(input);
        var output = try allocator.alloc(u8, output_length);
        var buffer = [3]u8{ 0, 0, 0 };
        var i_output: u64 = 0;
        var count: u8 = 0;

        for (input, 0..) |_, i| {
            buffer[count] = input[i];
            count += 1;

            if (count == 3) {
                output[i_output] = self.getCharacterAt(buffer[0] >> 2);
                output[i_output + 1] = self.getCharacterAt(((buffer[0] & 0x03) << 4) + (buffer[1] >> 4));
                output[i_output + 2] = self.getCharacterAt(((buffer[1] & 0x0f) << 2) + (buffer[2] >> 6));
                output[i_output + 3] = self.getCharacterAt(buffer[2] & 0x3f);
                i_output += 4;
                count = 0;
            }
        }

        if (count == 1) {
            output[i_output] = self.getCharacterAt(buffer[0] >> 2);
            output[i_output + 1] = self.getCharacterAt((buffer[0] & 0x03) << 4);
            output[i_output + 2] = '=';
            output[i_output + 3] = '=';
        }

        if (count == 2) {
            output[i_output] = self.getCharacterAt(buffer[0] >> 2);
            output[i_output + 1] = self.getCharacterAt(((buffer[0] & 0x03) << 4) + (buffer[1] >> 4));
            output[i_output + 2] = self.getCharacterAt((buffer[1] & 0x0f) << 2);
            output[i_output + 3] = '=';
            i_output += 4;
        }

        return output;
    }

    pub fn decode(self: Base64, allocator: std.mem.Allocator, input: []const u8) ![]u8 {
        if (input.len == 0) return "";

        const output_length = try getDecodeLength(input);
        var output = try allocator.alloc(u8, output_length);
        var buffer = [4]u8{ 0, 0, 0, 0 };
        var i_output: u64 = 0;
        var count: u8 = 0;

        for (0..input.len) |i| {
            buffer[count] = self.getCharacterIndex(input[i]);
            count += 1;

            if (count == 4) {
                output[i_output] = (buffer[0] << 2) + (buffer[1] >> 4);

                if (buffer[2] != 64) output[i_output + 1] = (buffer[1] << 4) + (buffer[2] >> 2);
                if (buffer[3] != 64) output[i_output + 2] = (buffer[2] << 6) + buffer[3];

                i_output += 3;
                count = 0;
            }
        }

        return output;
    }

    fn getCharacterAt(self: Base64, index: u8) u8 {
        return self.table[index];
    }

    fn getCharacterIndex(self: Base64, character: u8) u8 {
        var index: u8 = 0;
        while (index < 64) {
            if (self.getCharacterAt(index) == character) break;
            index += 1;
        }
        return index;
    }
};

fn getEncodeLength(input: []const u8) !usize {
    if (input.len < 3) return 4;

    const length: usize = try std.math.divCeil(usize, input.len, 3);
    return length * 4;
}

fn getDecodeLength(input: []const u8) !usize {
    if (input.len < 4) return 3;

    const length: usize = try std.math.divFloor(usize, input.len, 4);
    return length * 3;
}
