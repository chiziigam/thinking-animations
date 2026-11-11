import SwiftUI

/// Shows all eight animations in a grid. Used by the previews and the demo.
public struct ThinkingGallery: View {
    public init() {}

    public var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 24)], spacing: 32) {
                ForEach(ThinkingStyle.allCases) { style in
                    VStack(spacing: 12) {
                        ThinkingAnimation(style, size: 72)
                        Text(style.title).font(.footnote).foregroundStyle(.secondary)
                    }
                }
            }
            .padding(24)
        }
    }
}

#Preview("Gallery") { ThinkingGallery() }
#Preview("Indicator") { ThinkingIndicator(size: 48).padding() }
