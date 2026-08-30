import SwiftUI

public struct RealTimeFilterPreviewCanvas: View {
    @Binding var brightness: Double
    @Binding var contrast: Double
    @Binding var saturation: Double
    
    public init(brightness: Binding<Double>, contrast: Binding<Double>, saturation: Binding<Double>) {
        self._brightness = brightness
        self._contrast = contrast
        self._saturation = saturation
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.indigo.opacity(0.3))
                    .frame(height: 220)
                Image(systemName: "wand.and.stars")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            .colorMultiply(Color(hue: 0.7, saturation: saturation, brightness: 1.0 + brightness))
            .contrast(contrast)
        }
    }
}
