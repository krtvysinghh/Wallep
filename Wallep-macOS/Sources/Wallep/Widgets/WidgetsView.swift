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
                    Text("Supercharge your desktop with elegant clock overlays, live system telemetry, and quotes.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                // Clock Widget Config
                VStack(alignment: .leading, spacing: 14) {
                    Toggle("Enable Desktop Clock Overlay", isOn: $widgetManager.showClock)
                        .font(.headline)
                    
                    if widgetManager.showClock {
                        Picker("Clock Style", selection: $widgetManager.clockStyle) {
                            ForEach(ClockStyle.allCases) { style in
                                Text(style.rawValue).tag(style)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
                .cornerRadius(12)
                
                // Telemetry & Weather Config
                VStack(alignment: .leading, spacing: 14) {
                    Text("System Monitors & Weather")
                        .font(.headline)
                    
                    Toggle("Show Live CPU & RAM Telemetry", isOn: $widgetManager.showSystemMonitor)
                    Toggle("Show Local Weather & Temperature", isOn: $widgetManager.showWeather)
                    Toggle("Show Daily Motivational Quotes", isOn: $widgetManager.showDailyQuote)
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
                .cornerRadius(12)
                
                // Appearance Sliders
                VStack(alignment: .leading, spacing: 14) {
                    Text("Appearance & Opacity")
                        .font(.headline)
                    
                    HStack {
                        Text("Widget Opacity")
                        Slider(value: $widgetManager.widgetOpacity, in: 0.2...1.0)
                        Text("\(Int(widgetManager.widgetOpacity * 100))%")
                            .frame(width: 45)
                    }
                    
                    HStack {
                        Text("Widget Scale")
                        Slider(value: $widgetManager.widgetScale, in: 0.7...1.3)
                        Text(String(format: "%.1fx", widgetManager.widgetScale))
                            .frame(width: 45)
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor).opacity(0.5))
                .cornerRadius(12)
            }
            .padding(24)
        }
    }
}
