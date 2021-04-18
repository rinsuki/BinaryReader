//
//  File.swift
//  
//
//  Created by user on 2020/01/07.
//

import Foundation

public struct BinaryReader {
    public let data: Data
    public var pointer: UInt = 0
    public var endian: Endian = .little

    public enum Endian {
        case little
        case big
    }
    
    public init(data: Data, pointer: UInt = 0, endian: Endian = .little) {
        self.data = data
        self.pointer = pointer
        self.endian = endian
    }
    
    public var isEnd: Bool {
        return pointer == data.count
    }
    
    public mutating func bytes(count: UInt) -> Data {
        if count == 0 {
            return Data()
        }
        let startIndex = data.startIndex.advanced(by: Int(pointer))
        let ret = data[startIndex..<startIndex.advanced(by: Int(count))]
        pointer += count
        return ret
    }
    
    public func bytes(start: UInt, count: UInt) -> Data {
        let startIndex = data.startIndex.advanced(by: Int(start))
        return data[startIndex..<startIndex.advanced(by: Int(count))]
    }
    
    public func endianConvert(from: Data) -> Data {
        switch endian {
        case .little:
            return Data(from)
        case .big:
            return Data(from.reversed())
        }
    }
    
    public mutating func cStr(encoding: String.Encoding = .utf8) -> String {
        let prefixedData = data.suffix(from: Int(pointer))
        let endIndex = prefixedData.firstIndex(of: 0)!
        let stringData = prefixedData[prefixedData.startIndex..<endIndex]
        pointer += UInt(stringData.count) + 1
        return String(data: stringData, encoding: encoding)!
    }
    
    public mutating func uint8() -> UInt8 {
        let b = bytes(count: 1)
        return b.first!
    }
    public mutating func int8() -> Int8 {
        return .init(bitPattern: uint8())
    }
    public mutating func bool() -> Bool {
        return uint8() != 0
    }
    
    public mutating func uint16() -> UInt16 {
        let b = endianConvert(from: bytes(count: 2))
        let v = UInt16(b[0]) | UInt16(b[1]) << 8
        return v
    }
    public mutating func int16() -> Int16 {
        return .init(bitPattern: uint16())
    }
    
    public mutating func uint32() -> UInt32 {
        let b = endianConvert(from: bytes(count: 4))
        return UInt32(b[0]) | UInt32(b[1]) << 8 | UInt32(b[2]) << 16 | UInt32(b[3]) << 24
    }
    public mutating func int32() -> Int32 {
        return .init(bitPattern: uint32())
    }
    
    public mutating func uint64() -> UInt64 {
        let b = endianConvert(from: bytes(count: 8))
        let lower: UInt64 = UInt64(b[0]) | UInt64(b[1]) << 8 | UInt64(b[2]) << 16 | UInt64(b[3]) << 24
        let upper: UInt64 = UInt64(b[4]) << 32 | UInt64(b[5]) << 40 | UInt64(b[6]) << 48 | UInt64(b[7]) << 56
        return lower | upper
    }
    public mutating func int64() -> Int64 {
        return .init(bitPattern: uint64())
    }
    
    public mutating func float32() -> Float32 {
        return .init(bitPattern: uint32())
    }
    
    public mutating func float64() -> Float64 {
        return .init(bitPattern: uint64())
    }
}
