import SwiftUI

public struct SoundscapesView: View {
    @ObservedObject var soundManager = SoundtrackManager.shared
    let soundscapes = ["Rain on Glass", "Emerald Forest Wind", "Deep Cosmic Drone", "Tokyo Midnight Street", "Ocean Waves at Sunset"]
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ambient Soundscapes")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(soundscapes, id: \.self) { sound in
                HStack {
                    Image(systemName: soundManager.isAmbientPlaying && soundManager.currentSoundscape == sound ? "speaker.wave.3.fill" : "speaker.fill")
                        .foregroundColor(.indigo)
                    Text(sound)
                        .font(.subheadline)
                    Spacer()
                    Button(soundManager.isAmbientPlaying && soundManager.currentSoundscape == sound ? "Stop" : "Play") {
                        if soundManager.isAmbientPlaying && soundManager.currentSoundscape == sound {
                            soundManager.stopAmbient()
                        } else {
                            soundManager.playAmbient(named: sound)
                        }
                    }
                }
                .padding(12)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(8)
            }
        }
        .padding(24)
    }
}
