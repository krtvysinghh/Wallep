import Foundation

public final class MIMEValidator {
    public static func validateVideoFile(at url: URL) -> Bool {
        guard let handle = try? FileHandle(forReadingFrom: url) else { return false }
        defer { try? handle.close() }
        
        let data = handle.readData(ofLength: 12)
        guard data.count >= 8 else { return false }
        
        // Check for 'ftyp' box in MP4/MOV container header
        let sub = data.subdata(in: 4..<8)
        let ftyp = String(data: sub, encoding: .ascii)
        return ftyp == "ftyp" || url.pathExtension.lowercased() == "webm"
    }
}
