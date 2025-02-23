const std = @import("std");

pub fn randomNumber(min: i32, max: i32) i32 {
    var seed: u64 = undefined;
    std.crypto.random.bytes(std.mem.asBytes(&seed));
    var rng = std.rand.DefaultPrng.init(seed);
    const random = rng.random();
    return random.intRangeAtMost(i32, min, max);
}

pub fn randomBoolean() bool {
    var seed: u64 = undefined;
    std.crypto.random.bytes(std.mem.asBytes(&seed));
    var rng = std.rand.DefaultPrng.init(seed);
    const random = rng.random();
    return random.boolean();
}
