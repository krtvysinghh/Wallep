import Cocoa
import AppKit
import AVFoundation
import CoreGraphics

public final class DefaultWallpaperGenerator {
    public static let shared = DefaultWallpaperGenerator()
    
    public struct Preset {
        public let id: String
        public let title: String
        public let category: WallpaperCategory
        public let author: String
        public let colors: [NSColor]
        public let likes: Int
    }
    
    public let presets: [Preset] = [
        Preset(
            id: "default_cyberpunk",
            title: "Neon Cyberpunk Horizon",
            category: .cyberpunk,
            author: "Wallep Studio",
            colors: [
                NSColor(calibratedRed: 0.08, green: 0.02, blue: 0.18, alpha: 1.0),
                NSColor(calibratedRed: 0.45, green: 0.05, blue: 0.40, alpha: 1.0),
                NSColor(calibratedRed: 0.10, green: 0.40, blue: 0.85, alpha: 1.0)
            ],
            likes: 1420
        ),
        Preset(
            id: "default_aurora",
            title: "Nordic Emerald Aurora",
            category: .nature,
            author: "Nature Lab",
            colors: [
                NSColor(calibratedRed: 0.01, green: 0.08, blue: 0.10, alpha: 1.0),
                NSColor(calibratedRed: 0.05, green: 0.35, blue: 0.28, alpha: 1.0),
                NSColor(calibratedRed: 0.15, green: 0.70, blue: 0.50, alpha: 1.0)
            ],
            likes: 980
        ),
        Preset(
            id: "default_nebula",
            title: "Deep Cosmos Nebula Loop",
            category: .space,
            author: "Interstellar",
            colors: [
                NSColor(calibratedRed: 0.03, green: 0.03, blue: 0.08, alpha: 1.0),
                NSColor(calibratedRed: 0.25, green: 0.08, blue: 0.45, alpha: 1.0),
                NSColor(calibratedRed: 0.05, green: 0.20, blue: 0.60, alpha: 1.0)
            ],
            likes: 1150
        ),
        Preset(
            id: "default_sunset",
            title: "Pacific Horizon Sunset",
            category: .minimalist,
            author: "Apex Minimal",
            colors: [
                NSColor(calibratedRed: 0.12, green: 0.04, blue: 0.08, alpha: 1.0),
                NSColor(calibratedRed: 0.65, green: 0.20, blue: 0.15, alpha: 1.0),
                NSColor(calibratedRed: 0.90, green: 0.50, blue: 0.20, alpha: 1.0)
            ],
            likes: 830
        )
    ]
    
    private init() {}
    
    public func ensureDefaultWallpapers(in directory: URL, completion: @escaping ([WallpaperItem]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            var items: [WallpaperItem] = []
            
            for preset in self.presets {
                let videoURL = directory.appendingPathComponent("\(preset.id).mp4")
                let thumbURL = directory.appendingPathComponent("\(preset.id).jpg")
                
                if !FileManager.default.fileExists(atPath: videoURL.path) {
                    self.renderPresetVideo(preset: preset, destinationURL: videoURL)
                }
                
                if !FileManager.default.fileExists(atPath: thumbURL.path) {
                    self.renderThumbnail(preset: preset, destinationURL: thumbURL)
                }
                
                let fileAttrs = try? FileManager.default.attributesOfItem(atPath: videoURL.path)
                let rawBytes = (fileAttrs?[.size] as? NSNumber)?.int64Value ?? 0
                let mb = max(1.0, Double(rawBytes) / (1024.0 * 1024.0))
                
                let item = WallpaperItem(
                    id: preset.id,
                    title: preset.title,
                    category: preset.category,
                    resolution: "3840x2160 (Native 4K)",
                    duration: 6.0,
                    fileSize: "\(String(format: "%.1f", mb))MB",
                    thumbnailURL: thumbURL.path,
                    videoURL: videoURL,
                    author: preset.author,
                    likes: preset.likes,
                    isFavorite: true,
                    isCustom: false
                )
                items.append(item)
            }
            
            DispatchQueue.main.async {
                completion(items)
            }
        }
    }
    
    private func renderThumbnail(preset: Preset, destinationURL: URL) {
        let size = CGSize(width: 640, height: 360)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let ctx = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: Int(size.width) * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return }
        
        let cgColors = preset.colors.map { $0.cgColor } as CFArray
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: [0.0, 0.5, 1.0]) else { return }
        
        ctx.drawLinearGradient(
            gradient,
            start: CGPoint(x: 0, y: 0),
            end: CGPoint(x: size.width, y: size.height),
            options: []
        )
        
        if let image = ctx.makeImage() {
            let rep = NSBitmapImageRep(cgImage: image)
            if let data = rep.representation(using: .jpeg, properties: [:]) {
                try? data.write(to: destinationURL)
            }
        }
    }
    
    private func renderPresetVideo(preset: Preset, destinationURL: URL) {
        let width = 1920
        let height = 1080
        let fps: Int32 = 30
        let totalFrames = 180 // 6 seconds loop
        
        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try? FileManager.default.removeItem(at: destinationURL)
            }
            
            let writer = try AVAssetWriter(outputURL: destinationURL, fileType: .mp4)
            
            let videoSettings: [String: Any] = [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: width,
                AVVideoHeightKey: height,
                AVVideoCompressionPropertiesKey: [
                    AVVideoAverageBitRateKey: 6_000_000,
                    AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel
                ]
            ]
            
            let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
            let adaptor = AVAssetWriterInputPixelBufferAdaptor(
                assetWriterInput: writerInput,
                sourcePixelBufferAttributes: [
                    kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32ARGB),
                    kCVPixelBufferWidthKey as String: width,
                    kCVPixelBufferHeightKey as String: height
                ]
            )
            
            writer.add(writerInput)
            writer.startWriting()
            writer.startSession(atSourceTime: .zero)
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let cgColors = preset.colors.map { $0.cgColor } as CFArray
            let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: [0.0, 0.5, 1.0])!
            
            for frameIndex in 0..<totalFrames {
                while !writerInput.isReadyForMoreMediaData {
                    usleep(1000)
                }
                
                var pixelBuffer: CVPixelBuffer?
                CVPixelBufferCreate(
                    kCFAllocatorDefault,
                    width,
                    height,
                    kCVPixelFormatType_32ARGB,
                    nil,
                    &pixelBuffer
                )
                
                guard let buffer = pixelBuffer else { continue }
                
                CVPixelBufferLockBaseAddress(buffer, [])
                let pxData = CVPixelBufferGetBaseAddress(buffer)
                
                let context = CGContext(
                    data: pxData,
                    width: width,
                    height: height,
                    bitsPerComponent: 8,
                    bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                    space: colorSpace,
                    bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
                )!
                
                // Animate gradient angle over time for continuous fluid motion
                let progress = CGFloat(frameIndex) / CGFloat(totalFrames)
                let angle = progress * .pi * 2.0
                let startX = CGFloat(width) * (0.5 + 0.5 * cos(angle))
                let startY = CGFloat(height) * (0.5 + 0.5 * sin(angle))
                let endX = CGFloat(width) * (0.5 - 0.5 * cos(angle))
                let endY = CGFloat(height) * (0.5 - 0.5 * sin(angle))
                
                context.drawLinearGradient(
                    gradient,
                    start: CGPoint(x: startX, y: startY),
                    end: CGPoint(x: endX, y: endY),
                    options: []
                )
                
                CVPixelBufferUnlockBaseAddress(buffer, [])
                
                let frameTime = CMTime(value: Int64(frameIndex), timescale: fps)
                adaptor.append(buffer, withPresentationTime: frameTime)
            }
            
            writerInput.markAsFinished()
            
            let semaphore = DispatchSemaphore(value: 0)
            writer.finishWriting {
                semaphore.signal()
            }
            semaphore.wait()
        } catch {
            print("[Wallep] Error generating preset video: \(error)")
        }
    }
}
