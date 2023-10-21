import Foundation

extension Encodable {
    /// Convert to data using JSONEncoder
    var jsonData: Data? {
        try? JSONEncoder().encode(self)
    }
}
