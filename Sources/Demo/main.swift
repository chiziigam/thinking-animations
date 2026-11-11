import SwiftUI
import ThinkingAnimations
#if os(macOS)
import AppKit

@MainActor func renderPNG(to path: String) {
    let times: [Double] = [0.4, 1.3, 2.2, 3.1, 4.0]
    let view = VStack(alignment: .leading, spacing: 10) {
        ForEach(ThinkingStyle.allCases) { style in
            HStack(spacing: 14) {
                Text(style.title).font(.system(size: 12)).frame(width: 100, alignment: .leading)
                ForEach(times, id: \.self) { ThinkingAnimation(style, size: 56, color: .black, time: $0) }
            }
        }
    }.padding(20).background(Color.white)
    let renderer = ImageRenderer(content: view)
    renderer.scale = 1.5
    if let image = renderer.nsImage, let tiff = image.tiffRepresentation,
       let rep = NSBitmapImageRep(data: tiff), let png = rep.representation(using: .png, properties: [:]) {
        try? png.write(to: URL(fileURLWithPath: path))
    }
}

struct DemoApp: App {
    init() { NSApplication.shared.setActivationPolicy(.regular); NSApplication.shared.activate(ignoringOtherApps: true) }
    var body: some Scene {
        WindowGroup("ThinkingAnimations") {
            ThinkingGallery().frame(minWidth: 560, minHeight: 560)
        }
    }
}

if let i = CommandLine.arguments.firstIndex(of: "--png"), CommandLine.arguments.count > i + 1 {
    MainActor.assumeIsolated { renderPNG(to: CommandLine.arguments[i + 1]) }
} else {
    DemoApp.main()
}
#endif
