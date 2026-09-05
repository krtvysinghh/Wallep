import SwiftUI

public struct WidgetsView: View {
    @ObservedObject var widgetManager = DesktopWidgetManager.shared
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 6) {
                    Text("Desktop Widgets & HUDs")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Supercharge your desktop with elegant clock overlays, live system telemetry, and quotes.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.65))
                }
                
                // Clock Widget Config
                VStack(alignment: .leading, spacing: 16) {
                    Toggle("Enable Desktop Clock Overlay", isOn: $widgetManager.showClock)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    if widgetManager.showClock {
                        Picker("Clock Style", selection: $widgetManager.clockStyle) {
                            ForEach(ClockStyle.allCases) { style in
                                Text(style.rawValue).tag(style)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .padding(18)
                .glassmorphicSurface(cornerRadius: 16)
                
                // Telemetry & Weather Config
                VStack(alignment: .leading, spacing: 16) {
                    Text("System Monitors & Weather")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Toggle("Show Live CPU & RAM Telemetry", isOn: $widgetManager.showSystemMonitor)
                        .foregroundColor(.white)
                    Toggle("Show Local Weather & Temperature", isOn: $widgetManager.showWeather)
                        .foregroundColor(.white)
                    Toggle("Show Daily Motivational Quotes", isOn: $widgetManager.showDailyQuote)
                        .foregroundColor(.white)
                }
                .padding(18)
                .glassmorphicSurface(cornerRadius: 16)
                
                // Appearance Sliders
                VStack(alignment: .leading, spacing: 16) {
                    Text("Appearance & Opacity")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack {
                        Text("Widget Opacity")
                            .foregroundColor(.white.opacity(0.85))
                        Slider(value: $widgetManager.widgetOpacity, in: 0.2...1.0)
                        Text("\(Int(widgetManager.widgetOpacity * 100))%")
                            .foregroundColor(.white)
                            .frame(width: 45)
                    }
                    
                    HStack {
                        Text("Widget Scale")
                            .foregroundColor(.white.opacity(0.85))
                        Slider(value: $widgetManager.widgetScale, in: 0.7...1.3)
                        Text(String(format: "%.1fx", widgetManager.widgetScale))
                            .foregroundColor(.white)
                            .frame(width: 45)
                    }
                }
                .padding(18)
                .glassmorphicSurface(cornerRadius: 16)
            }
            .padding(24)
        }
    }
}
