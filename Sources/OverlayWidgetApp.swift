import SwiftUI
import AppKit

@main
struct OverlayWidgetApp: App {
    @State private var floatingPanel: FloatingWidgetPanel?
    private let sigSource: DispatchSourceSignal

    init() {
        NSApplication.shared.setActivationPolicy(.accessory)
        signal(SIGUSR1, SIG_IGN)
        let source = DispatchSource.makeSignalSource(signal: SIGUSR1, queue: .main)
        source.setEventHandler {
            NotificationCenter.default.post(name: .ringBell, object: nil)
        }
        source.resume()
        self.sigSource = source
    }

    var body: some Scene{
        WindowGroup {
            Color.clear
                .onAppear {
                    setupFloatingWidget()
                }
        }
    }

    private func setupFloatingWidget() {
        guard floatingPanel == nil else { return }
        let screenRect = NSScreen.main?.visibleFrame ?? NSRect(x: 100, y: 100, width: 200, height: 120)
        let panelRect = NSRect(
            x: screenRect.maxX - 220,
            y: screenRect.maxY - 140,
            width: 200,
            height: 120
        )

        let panel = FloatingWidgetPanel(contentRect: panelRect)
        let hostingView = NSHostingView(rootView: WidgetView())

        panel.contentView = hostingView
        panel.orderFrontRegardless()

        self.floatingPanel = panel
    }
}