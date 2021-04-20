import XCTest
@testable import BinaryReader

final class BinaryReaderTests: XCTestCase {
    func testLittleEndian() {
        let d = Data(base64Encoded: "Af8CAP//AwAAAP////8=")!
        var reader = BinaryReader(data: d, endian: .little)
        XCTAssertEqual(reader.uint8(), 1)
        XCTAssertEqual(reader.int8(), -1)
        XCTAssertEqual(reader.uint16(), 2)
        XCTAssertEqual(reader.int16(), -1)
        XCTAssertEqual(reader.uint32(), 3)
        XCTAssertEqual(reader.isEnd, false)
        XCTAssertEqual(reader.int32(), -1)
        XCTAssertEqual(reader.isEnd, true)
    }
    
    func testBigEndian() {
        let d = Data(base64Encoded: "Af8AAv//AAAAA/////8=")!
        var reader = BinaryReader(data: d, endian: .big)
        XCTAssertEqual(reader.uint8(), 1)
        XCTAssertEqual(reader.int8(), -1)
        XCTAssertEqual(reader.uint16(), 2)
        XCTAssertEqual(reader.int16(), -1)
        XCTAssertEqual(reader.uint32(), 3)
        XCTAssertEqual(reader.isEnd, false)
        XCTAssertEqual(reader.int32(), -1)
        XCTAssertEqual(reader.isEnd, true)
    }
    
    func testBothEndian() {
        let d = Data(base64Encoded: "AQACAwAAAAAAAAAAAAAE")!
        var reader = BinaryReader(data: d)
        reader.endian = .big
        XCTAssertEqual(reader.uint8(), 1)
        XCTAssertEqual(reader.uint16(), 2)
        reader.endian = .little
        XCTAssertEqual(reader.uint32(), 3)
        reader.endian = .big
        XCTAssertEqual(reader.uint64(), 4)
    }
    
    func testCStr() {
        let d = "ABC\u{00}".data(using: .utf8)!
        var reader = BinaryReader(data: d)
        reader.pointer += 1
        let d2 = reader.bytes(count: 3)
        var reader2 = BinaryReader(data: d2)
        XCTAssertEqual(reader2.cStr(), "BC")
    }

    static var allTests = [
        ("testLittleEndian", testLittleEndian),
        ("testBigEndian", testBigEndian),
        ("testBothEndian", testBothEndian),
        ("testCStr", testCStr),
    ]
}
