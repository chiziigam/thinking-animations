import SwiftUI
import ThinkingAnimations
#if os(macOS)
import AppKit

struct DemoApp: App {
    init() { NSApplication.shared.setActivationPolicy(.regular); NSApplication.shared.activate(ignoringOtherApps: true) }
    var body: some Scene {
        WindowGroup("ThinkingAnimations") {
            ThinkingGallery().frame(minWidth: 560, minHeight: 560)
        }
    }
}
DemoApp.main()
#endif
