# BinaryReader

Read Binary in Swift.

## Usage

```swift
import Foundation
import BinaryReader

let data = try! Data(contentsOf: URL(fileURLWithPath: "./example.png"))
var reader = BinaryReader(data: data, endian: .big)

assert(reader.uint64() == 0x89504E470D0A1A0A)
assert(reader.uint32() == 13)
assert(reader.uint32() == 0x49484452)
let width = reader.uint32()
let height = reader.uint32()

print("PNG Size: \(width)x\(height)")
```

## Supported Environments

Swift `5.3..<6.0`

latest macOS (and other Apple's OS like iOS), Linux and Windows are supported.