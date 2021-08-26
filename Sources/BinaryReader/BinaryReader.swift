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
    
    @inline(__always)
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
    
    public mutating func cStr(encoding: String.Encoding = .utf8) -> String {
        let prefixedData = data.suffix(from: data.startIndex + Int(pointer))
        let endIndex = prefixedData.firstIndex(of: 0)!
        let stringData = prefixedData[prefixedData.startIndex..<endIndex]
        pointer += UInt(stringData.count) + 1
        return String(data: stringData, encoding: encoding)!
    }
    
    public mutating func uint8() -> UInt8 {
        let b = bytes(count: 1).withUnsafeBytes { $0.load(as: UInt8.self) }
        return b
    }
    @inline(__always)
    public mutating func int8() -> Int8 {
        return .init(bitPattern: uint8())
    }
    @inline(__always)
    public mutating func bool() -> Bool {
        return uint8() != 0
    }
    
    public mutating func uint16() -> UInt16 {
        let b: UInt16 = bytes(count: 2).withUnsafeBytes { $0.pointee }
        switch endian {
        case .little:
            return .init(littleEndian: b)
        case .big:
            return .init(bigEndian: b)
        }
    }
    @inline(__always)
    public mutating func int16() -> Int16 {
        return .init(bitPattern: uint16())
    }
    
    public mutating func uint32() -> UInt32 {
        let b: UInt32 = bytes(count: 4).withUnsafeBytes { $0.pointee }
        switch endian {
        case .little:
            return .init(littleEndian: b)
        case .big:
            return .init(bigEndian: b)
        }
    }
    @inline(__always)
    public mutating func int32() -> Int32 {
        return .init(bitPattern: uint32())
    }
    
    public mutating func uint64() -> UInt64 {
        let b: UInt64 = bytes(count: 8).withUnsafeBytes { $0.pointee }
        switch endian {
        case .little:
            return .init(littleEndian: b)
        case .big:
            return .init(bigEndian: b)
        }
    }
    @inline(__always)
    public mutating func int64() -> Int64 {
        return .init(bitPattern: uint64())
    }
    
    @inline(__always)
    public mutating func float32() -> Float32 {
        return .init(bitPattern: uint32())
    }
    
    @inline(__always)
    public mutating func float64() -> Float64 {
        return .init(bitPattern: uint64())
    }
    
    public mutating func align(_ n: UInt) {
        let add = pointer % n
        if add > 0 {
            pointer += n - add
        }
    }
}
