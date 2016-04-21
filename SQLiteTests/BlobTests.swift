import XCTest
import SQLite

class BlobTests : XCTestCase {

    func test_toHex() {
        let bytesArray: [UInt8] = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 150, 250, 255]
        let bytes = UnsafeMutablePointer<UInt8>.alloc(bytesArray.count)
        
        for idx in 0..<bytesArray.count {
            bytes.advancedBy(idx).memory = bytesArray[idx]
        }
        
        let blob = Blob(bytes: bytes, length: bytesArray.count)
        XCTAssertEqual(blob.toHex(), "000a141e28323c46505a6496faff")
    }

}
