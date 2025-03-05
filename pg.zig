const std = @import("std");
const p = std.debug.print;

pub fn main() !void {
    const n: f32 = 1024.32;
    const nn = @as(usize, @intFromFloat(@trunc(n)));
    const lim = @as(usize, @intFromFloat(@sqrt(n))) + 1;
    for (2..lim) |d| {
        if (@mod(nn, d) == 0)
            p("{d}\n", .{d});
    }
}
