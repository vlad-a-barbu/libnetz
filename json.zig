const std = @import("std");
const t = std.testing;

const Request = struct {
    method: []u8,
    number: f64,
    const ExpectedMethod = "isPrime";
};

fn isPrime(n: f64) bool {
    if (n < 2 or @trunc(n) != n)
        return false;
    const nn = @as(usize, @intFromFloat(@trunc(n)));
    const lim = @as(usize, @intFromFloat(@sqrt(n))) + 1;
    for (2..lim) |d| {
        if (@mod(nn, d) == 0)
            return false;
    }
    return true;
}

pub const RequestError = error{Malformed};

pub fn handlePrimeRequest(allocator: std.mem.Allocator, line: []const u8) RequestError!bool {
    const req = std.json.parseFromSlice(Request, allocator, line, .{}) catch {
        return RequestError.Malformed;
    };
    defer req.deinit();
    if (std.mem.startsWith(u8, req.value.method, Request.ExpectedMethod) and
        req.value.method.len == Request.ExpectedMethod.len)
    {
        return isPrime(req.value.number);
    } else {
        return RequestError.Malformed;
    }
}

test "prime time prereq" {
    const reqJson =
        \\{"method": "isPrime", "number": 199}
    ;
    const res = try handlePrimeRequest(t.allocator, reqJson);
    try t.expect(res);
}
