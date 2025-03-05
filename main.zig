const std = @import("std");
const j = @import("json.zig");

fn echo(conn: std.net.Server.Connection) void {
    defer conn.stream.close();
    var buff: [0x100]u8 = undefined;
    while (true) {
        const n = conn.stream.read(&buff) catch 0;
        if (n == 0) break;
        _ = conn.stream.write(buff[0..n]) catch break;
    }
}

const ByteArrayList = std.ArrayList(u8);

fn readline(result: *ByteArrayList, stream: std.net.Stream) void {
    result.clearRetainingCapacity();
    var buff: [0x100]u8 = undefined;
    while (true) {
        const n = stream.read(&buff) catch 0;
        if (n == 0) break;
        const chunk = buff[0..n];
        result.appendSlice(chunk) catch break;
        if (chunk[chunk.len - 1] == '\n')
            break;
    }
}

fn prime_time(allocator: std.mem.Allocator, conn: std.net.Server.Connection) void {
    defer conn.stream.close();
    var linebuff = ByteArrayList.init(allocator);
    defer linebuff.deinit();

    readline(&linebuff, conn.stream);
    std.debug.print("[{d} bytes] request: <<{s}>>\n", .{ linebuff.items.len, linebuff.items });

    if (j.handlePrimeRequest(allocator, linebuff.items)) |prime| {
        std.debug.print("prime: {any}\n", .{prime});
    } else |err| {
        std.debug.print("error: {any}\n", .{err});
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const deinit_status = gpa.deinit();
        std.debug.assert(deinit_status == .ok);
    }
    const allocator = gpa.allocator();

    const addr = std.net.Address.initIp4(.{ 0, 0, 0, 0 }, 3000);
    var server = try addr.listen(.{ .reuse_address = true });
    while (true) {
        const conn = try server.accept();
        const th = try std.Thread.spawn(.{}, prime_time, .{ allocator, conn });
        th.detach();
    }
}
