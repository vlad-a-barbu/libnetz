const std = @import("std");
const t = std.testing;

test "prime time prereq" {
    const j =
        \\{"method": "isPrime", "number": 199}
    ;
    _ = j;
    //Req.parse(j);
}
