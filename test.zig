const expect = @import("std").testing.expect;

test "if statement" {
    const a = true;
    var x: u16 = 0;
    if (a) {
        x += 1;
    } else {
        x += 2;
    }
    try expect (x == 1);
}

test "if statement expression" {
    const a = true;
    var x: u16 = 0;
    x += if (a) 1 else 2;
    try expect(x == 1);
}
 
test "while" {
    var i: u8  = 2;
    while (i < 100) {
        i *= 2;
    }
    try expect (i == 128);
}
 
test "while with continue" {
    var sum: u8 = 0;
    var i: u8 = 0;
    while (i <= 3) : (i += 1) {
        if (i == 2) continue;
        sum += i;
    }
    try expect (sum == 4);
}
 
test "while with break" {
    var sum: u8 = 0;
    var i: u8 = 0;
    while (i <= 3): (i += 1) {
        if (i == 2) break;
        sum += i;
    }
    try expect(sum == 1);
}
 
test "for" {
    const string = [_]u8{'a', 'b', 'c'};

    for (string) |char, index| {
        _ = char;
        _ = index;
    }
}
  
fn addFive(x: u32) u32 {
    return x + 5;
}

test "func" {
    const y = addFive(5);
    try expect(@TypeOf(y) == u32);
    // try expect(y == 5);
}

fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n-1) + fibonacci(n-2);
}

test "fn recursion" {
    const x = fibonacci(10);
    try expect (x == 55);
}
 
test "defer" {
    var x: i16 = 5;
    {
        defer x += 2;
        try expect (x == 5);
    }
    try expect (x == 7);
}
 
test "multiple defer" {
    var x: f32 = 5;
    {
        defer x += 2;
        defer x /= 2;
    }
    try expect (x == 4.5);
}

const FileOpenError = error{
    AccessDenied,
    OutOfMemory,
    FileNotFound,
};

const AllocationError = error{OutOfMemory};
 
test "error" {
    const err: FileOpenError = AllocationError.OutOfMemory;
    try expect (err == FileOpenError.OutOfMemory);
}