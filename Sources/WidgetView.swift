import SwiftUI

struct WidgetView: View {
    private let frames: [NSImage] = (1...8).compactMap { i in
        Bundle.module.url(forResource:"bell\(i)", withExtension: "png", subdirectory: "BellFrames")
            .flatMap { NSImage(contentsOf: $0) }
        }
    @State private var frameIndex = 0
    @State private var isRinging = false
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing:12) {
            Image(nsImage: frames[frameIndex])
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .onReceive(timer) { _ in
                    guard isRinging else { return }
                    frameIndex = (frameIndex+1) % frames.count
                }
                .onReceive(NotificationCenter.default.publisher(for: .ringBell)) { _ in
                    ring()
                }
        }
        .padding()

    }

    private func ring() { 
        isRinging = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isRinging = false 
            frameIndex = 0
        }
    }
}

extension Notification.Name {
    static let ringBell = Notification.Name("ringBell")
}