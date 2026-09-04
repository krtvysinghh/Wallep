import SwiftUI

public struct CompactGalleryGrid: View {
    public let columns = [GridItem(.adaptive(minimum: 280, maximum: 380), spacing: 18)]
    
    public init() {}
    
    public var body: some View {
        LazyVGrid(columns: columns, spacing: 18) {
            Text("Grid Ready")
        }
    }
}
