//
// SQLite.swift
// https://github.com/stephencelis/SQLite.swift
// Copyright © 2014-2015 Stephen Celis.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

public final class Blob {

    public let bytes: UnsafePointer<Void>
    public let length: Int
    private let freeWhenDone: Bool

    public init(bytes: UnsafePointer<Void>, length: Int, freeWhenDone: Bool = true) {
        self.bytes = bytes
        self.length = length
        self.freeWhenDone = freeWhenDone
    }
    
    deinit {
        if self.freeWhenDone {
            UnsafeMutablePointer<Void>(self.bytes).dealloc(self.length)
        }
    }

    public func toHex() -> String {
        let bytes = UnsafePointer<UInt8>(self.bytes)
        
        var hex = ""
        for idx in 0..<self.length {
            let byte = bytes.advancedBy(idx).memory
            if byte < 16 {
                hex += "0"
            }
            hex += String(byte, radix: 16, uppercase: false)
        }
        return hex
    }

}

extension Blob : CustomStringConvertible {

    public var description: String {
        return "x'\(toHex())'"
    }

}

extension Blob : Equatable {

}

public func ==(lhs: Blob, rhs: Blob) -> Bool {
    return lhs.bytes == rhs.bytes
}
