const rl = @import("raylib");

pub fn hexToColor(hex: []const u8) rl.Color {
    if ((hex.len != 7 and hex.len != 9) or hex[0] != '#') return rl.Color.black;
    return rl.Color{ .r = parseHexByte(hex[1], hex[2]), .g = parseHexByte(hex[3], hex[4]), .b = parseHexByte(hex[5], hex[6]), .a = if (hex.len == 9) parseHexByte(hex[7], hex[8]) else 255 };
}

fn parseHexByte(hight: u8, low: u8) u8 {
    return (hexDigitToInt(hight) * 16) + hexDigitToInt(low);
}

fn hexDigitToInt(digit: u8) u8 {
    return switch (digit) {
        '0'...'9' => digit - '0',
        'A'...'F' => digit - 'A' + 10,
        'a'...'f' => digit - 'a' + 10,
        else => @panic("Invalid hex digit"),
    };
}
