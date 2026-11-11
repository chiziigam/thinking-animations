import SwiftUI

/// Rotates through all of them animations, one every `ThinkingTiming.interval` seconds,
/// with a cross-fade. The order is shuffled per `since` date and never repeats
/// the same animation twice in a row. Interruptible: remove the view and it stops.
public struct ThinkingIndicator: View {
    public var since: Date
    public var size: CGFloat
    public var color: Color

    @State private var index = 0

    public init(since: Date = .now, size: CGFloat = 24, color: Color = .primary) {
        self.since = since
        self.size = size
        self.color = color
    }

    public var body: some View {
        ZStack {
            ThinkingAnimation(Self.style(at: index, since: since), size: size, color: color)
                .id(index)
                .transition(.opacity)
        }
        .frame(width: size, height: size)
        .onAppear { index = Self.current(since) }
        .task {
            while !Task.isCancelled {
                let elapsed = Date().timeIntervalSince(since)
                let wait = ThinkingTiming.interval - elapsed.truncatingRemainder(dividingBy: ThinkingTiming.interval)
                try? await Task.sleep(for: .seconds(wait))
                if Task.isCancelled { break }
                withAnimation(.easeInOut(duration: ThinkingTiming.blend)) { index = Self.current(since) }
            }
        }
    }

    private static func current(_ since: Date) -> Int {
        max(0, Int(Date().timeIntervalSince(since) / ThinkingTiming.interval))
    }

    private static func order(bag: Int, since: Date) -> [ThinkingStyle] {
        let seed = UInt64(bitPattern: Int64(since.timeIntervalSince1970 * 1000))
        var generator = SeededGenerator(seed: seed &+ UInt64(bag) &* 0x9E37_79B9_7F4A_7C15)
        var styles = ThinkingStyle.allCases.shuffled(using: &generator)
        if bag > 0, let last = order(bag: bag - 1, since: since).last, styles.first == last {
            styles.swapAt(0, 1)
        }
        return styles
    }

    private static func style(at index: Int, since: Date) -> ThinkingStyle {
        let count = ThinkingStyle.allCases.count
        return order(bag: index / count, since: since)[index % count]
    }
}

private struct SeededGenerator: RandomNumberGenerator {
    var state: UInt64
    init(seed: UInt64) { state = seed }
    mutating func next() -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }
}
