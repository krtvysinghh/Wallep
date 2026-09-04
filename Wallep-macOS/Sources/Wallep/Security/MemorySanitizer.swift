import Foundation

public struct MemorySanitizer {
    public static func zeroBuffer(pointer: UnsafeMutableRawPointer, count: Int) {
        memset(pointer, 0, count)
    }
}
