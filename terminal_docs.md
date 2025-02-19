# Terminal docs

This is for the std.posix (px) namespace that seems to control the terminal

## Values

```ts
const px = std.posix;
const std = @import("std");

pub fn main () !void {
  // Exits the terminal session
  px.exit();

  // This value is an error union that you can use to test
  // if the terminal can access a file with specific permissions
  px.access(files_path, mode);
  px.accessZ(file_path, mode);

  // EXAMPLE
    const mode = 777;
    const path: []const u8 = "/Users/davidcharles/.gitStdCommitMessage";
  _ = px.access(path, mode) catch {
    return try stdout.print("denied\n", .{});
  };
  return try stdout.print("accessed\n", .{});

  const path: *const [40:0]u8 = "/Users/davidcharles/.gitStdCommitMessage";
  _ = px.accessZ(path, mode) catch {
    return try stdout.print("denied\n", .{});
  };
  return try stdout.print("accessed\n", .{});

  // This value is an error union that you can use to change the directory
  // equivalent to the 'cd command'
  px.chdir(files_path);
  px.chdirZ(file_path);

  // EXAMPLE
    const path: []const u8 = "/Users/davidcharles/.gitStdCommitMessage";
  _ = px.chdir("/Users/davidcharles/...") catch {
    return try stdout.print("denied\n", .{});
  };
  return try stdout.print("accessed\n", .{});

  const path: *const [40:0]u8 = "/Users/davidcharles/.gitStdCommitMessage";
  _ = px.chdirZ(path) catch {
    return try stdout.print("denied\n", .{});
  };
  return try stdout.print("accessed\n", .{});

}
```
