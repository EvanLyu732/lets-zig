const std = @import("std");

const constant: i32 = 5;
var variable: u32 = 5000;

const inferred_constant = @as(i32, 5);

pub fn main() void {
    std.debug.print("hello , {s} \n", .{"World"});
}