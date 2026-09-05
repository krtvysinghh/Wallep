import SwiftUI

public struct DesktopWidgetView: View {
    @ObservedObject var widgetManager = DesktopWidgetManager.shared
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Top-Leading: Clock & Date & Weather
            VStack(alignment: .leading, spacing: 8) {
                if widgetManager.showClock {
                    renderClock()
                }
                
                if widgetManager.showWeather {
                    HStack(spacing: 8) {
                        Image(systemName: "sun.max.fill")
                            .foregroundColor(.yellow)
                        Text("\(widgetManager.currentTemp) • \(widgetManager.weatherCondition)")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                }
                
                Spacer()
            }
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            // Top-Trailing: System Monitors HUD
            VStack(alignment: .trailing, spacing: 10) {
                if widgetManager.showSystemMonitor {
                    VStack(alignment: .trailing, spacing: 6) {
                        HStack(spacing: 8) {
                            Text("CPU")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.secondary)
                            Text(String(format: "%.1f%%", widgetManager.cpuUsage))
                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                                .foregroundColor(.green)
                        }
                        
                        HStack(spacing: 8) {
                            Text("RAM")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.secondary)
                            Text(String(format: "%.1f GB", widgetManager.memoryUsage))
                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                                .foregroundColor(.cyan)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(14)
                }
                
                Spacer()
            }
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            
            // Bottom-Leading: Daily Quote
            VStack(alignment: .leading, spacing: 4) {
                Spacer()
                if widgetManager.showDailyQuote {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\"\(widgetManager.dailyQuote)\"")
                            .font(.system(size: 14, weight: .medium, design: .serif))
                            .italic()
                            .foregroundColor(.white.opacity(0.95))
                        Text("— \(widgetManager.quoteAuthor)")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.white.opacity(0.65))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(14)
                }
            }
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
        .opacity(widgetManager.widgetOpacity)
        .scaleEffect(widgetManager.widgetScale)
        .onReceive(timer) { input in
            currentTime = input
        }
    }
    
    @ViewBuilder
    private func renderClock() -> some View {
        let formatter = DateFormatter()
        let dateFormatter = DateFormatter()
        let _ = formatter.dateFormat = "HH:mm"
        let _ = dateFormatter.dateFormat = "EEEE, MMMM d"
        
        VStack(alignment: .leading, spacing: -4) {
            Text(formatter.string(from: currentTime))
                .font(.system(size: 64, weight: .thin, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
            
            Text(dateFormatter.string(from: currentTime).uppercased())
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .tracking(2.0)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}
