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
 
// test "out of bound" {
//     const a = [3]u8{1,2,3};
//     var index: u8 = 5;
//     const b = a[index];
//     _ = b;
// }


// test "out of bound unsafety" {
//     @setRuntimeSafety(false);
//     const a = [3]u8{1,2,3};
//     var index: u8 = 5;
//     const b = a[index];
//     _ = b;
// }

 
test "unreachable" {
    const x : i32 = 2;
    const y : u32 = if (x == 2) 5 else unreachable;
    _ = y;
} 
  
fn ascilToUpper(x: u8) u8 {
    return switch (x) {
        'a' ... 'z' => x + 'A' - 'a',
        'A' ... 'Z' => x,
        else => unreachable,
    };
}

test "unreachable switch" {
    try expect(ascilToUpper('a') == 'A');
    try expect(ascilToUpper('b') == 'B');
}

fn increment(num: *u8) void {
    num.* += 1;
}
 
test "pointers" {
    var x : u8 = 1;
    increment(&x);
    try expect (x == 2);
}
 
// test "naughty pointer" {
//     var x : u16 = 0;
//     var y : *u8 = @intToPtr(*u8, x);
//     _ = y;
// }
 
test "const pointers" {
    // const x : u8 = 1;
    var x : u8 = 1;
    var y = &x;
    y.* += 1;
}
 
test "usize" {
    try expect(@sizeOf(usize) == @sizeOf(*u8));
    try expect(@sizeOf(isize) == @sizeOf(*u8));
}

fn total(values: []const u8) usize {
    var sum : usize = 0;
    for (values) |v| sum += v;
    return sum;
} 
 
test "slice" {
    const array = [_]u8{1,2,3,5,6};
    const slice = array[0..3];
    try expect(total(slice) == 6);
}

test "slice2" {
    const array = [_]u8{1,2,3,5,6};
    const slice = array[0..3];
    try expect(@TypeOf(slice) == *const [3]u8);
}
 
test "slice3" {
    var array = [_]u8{1,2,3,4,5};
    var slice = array[0..];
    _ = slice;
}

const Direction = enum {north, south, east, west};
const Value = enum(u2) {zero, one, two};
 
test "enum ordinal value" {
    try expect(@enumToInt(Value.zero) == 0);
    try expect(@enumToInt(Value.one) == 1);
    try expect(@enumToInt(Value.two) == 2);
}
 
const Value2 = enum(u32) {
    hundred = 100,
    million = 100000,
};


test "set enum ordinal value" {
    try expect(@enumToInt(Value2.hundred) == 100);
}

const Suit = enum {
    clubs,
    spades,
    pub fn isClubs(self: Suit) bool {
        return self == Suit.clubs;
    }
}; 
 
test "enum method" {
    try expect(Suit.spades.isClubs() == Suit.isClubs(.spades));
}

const Mode = enum {
    var count : i32 = 0;
    on,
    off,
};
 
test "hmm" {
    Mode.count += 1;
    try expect(Mode.count == 1);
}

const Vec3 = struct {
    x: f32, y: f32, z: f32
};

test "struct usage" {
    const my_vec = Vec3 { 
        .x = 0,
        .y = 50,
        .z = 50,
    };
    _ = my_vec;
}

const Vec4 = struct {
    x: f32, y: f32, z: f32 = 0, w: f32 = undefined
};

test "test struct default" {
    const my_vec = Vec4{
        .x = 25,
        .y = -50,
    };
    _ = my_vec;
}

const Stuff = struct {
    x: i32,
    y: i32,
    fn swap(self: *Stuff) void  {
        const tmp = self.x;
        self.x = self.y;
        self.y = tmp;
    }
}; 

test "automatic dereference" {
    var thing = Stuff{.x = 10, .y = 20};
    thing.swap();
    try expect(thing.x == 20);
    try expect(thing.y == 10);
}

const Result = union {
    int: f64,
    float: f64,
    bool: bool,
}

test "simple union" {
    var result = Result{ .int = 1234 };
    // result.float = 12.34;
}

const Tag = enum {a, b, c};

const Tagged = union(Tag) {a: u8, b: f32, c: bool};

test "switch on tag union" {
    var value = Tagged{.b = 1.5};
    switch(value) {
        .a => |*byte| byte.* += 1,
        .b => |*float| float.* *= 2,
        .c => |*b| b.* = !b.*;
    }
} 