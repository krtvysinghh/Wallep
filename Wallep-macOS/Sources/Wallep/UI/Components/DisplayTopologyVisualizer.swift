import SwiftUI

public struct DisplayTopologyVisualizer: View {
    public init() {}
    
    public var body: some View {
        HStack {
            Image(systemName: "rectangle.inset.filled.and.cursorarrow")
            Text("Auto-Scaled per Monitor")
                .font(.caption)
        }
    }
}
