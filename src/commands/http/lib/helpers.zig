pub fn trimTrailingAA(input: []const u8) []const u8 {
    var end_index = input.len;
    while (end_index > 0 and input[end_index - 1] == 0xAA) end_index -= 1;
    return input[0..end_index];
}
