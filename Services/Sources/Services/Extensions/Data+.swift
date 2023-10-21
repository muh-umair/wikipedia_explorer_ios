import Foundation

extension Data {
    /// Init with content of a file
    init?(contentOfFile fileName: String, fileExtension: String = "json") throws {
        guard let bundle = Bundle.module.url(forResource: fileName, withExtension: fileExtension) else {
            return nil
        }
        try self.init(contentsOf: bundle)
    }
}
