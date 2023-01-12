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

test "error union" {
    const maybe_err: AllocationError!u16 = 10;
    const no_err = maybe_err catch 0;

    try expect(@TypeOf(no_err) == u16);
    try expect(no_err == 10);
}

fn failingFunction() error{Oops}! void {
    return error.Oops;
}
 
test "returning an error" {
    failingFunction() catch |err| {
        try expect(err == error.Oops);
        return;
    };
}
  
fn failFn() error{Oops}!i32 {
    try failingFunction();
    return 12;
}
 
test "try" {
    var v = failFn() catch |err| {
        try expect(err == error.Oops);
        return;
    };
    try expect(v == 12);
}
 

var problem: u32 = 98;  
fn failFnCounter() error {Oops}! void {
    errdefer problem += 1;
    try failingFunction();
}

test "errDefer" {
    failFnCounter() catch |err| {
        try expect(err == error.Oops);
        try expect(problem == 99);
        return;
    };
}
 
fn createFile()! void {
    return error.AccessDenied;
}
 
test "inferred error set" {
    const x: error{AccessDenied}! void = createFile();
    _ = x catch {};
} 

// merge error site
const A = error{ NotDir, PathNotFound};
const B = error{ OutOfMemory, PathNotFound};
const C = A || B;


test "switch statement" {
    var x: i8 = 10;
    switch (x) {
        -1...1 => {
            x = -x;
        },
        10...100 => {
            x = @divExact(x, 10);
        },
        else => {},
    }
    try expect(x == 1);
}