import SwiftUI

/// One animation, drawn in a square. Uses `color` for all drawing.
/// With Reduce Motion on, it shows a still pose that fades in and out slowly.
public struct ThinkingAnimation: View {
    public var style: ThinkingStyle
    public var size: CGFloat
    public var color: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(_ style: ThinkingStyle, size: CGFloat = 24, color: Color = .primary) {
        self.style = style
        self.size = size
        self.color = color
    }

    public var body: some View {
        TimelineView(.animation) { context in
            let date = context.date.timeIntervalSinceReferenceDate
            let t = reduceMotion ? ThinkingTiming.stillPose : date
            Canvas { gc, canvasSize in
                gc.scaleBy(x: canvasSize.width / 96, y: canvasSize.height / 96)
                style.draw(&gc, t, color)
            }
            .opacity(reduceMotion ? Self.pulse(date) : 1)
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }

    private static func pulse(_ date: TimeInterval) -> Double {
        let phase = date / ThinkingTiming.reducedPulse * 2 * .pi
        return 0.65 + 0.35 * sin(phase)
    }
}

/// Named views, one per animation.
public struct FigureEight: View {
    var size: CGFloat, color: Color
    public init(size: CGFloat = 24, color: Color = .primary) { self.size = size; self.color = color }
    public var body: some View { ThinkingAnimation(.figureEight, size: size, color: color) }
}
public struct Spark: View {
    var size: CGFloat, color: Color
    public init(size: CGFloat = 24, color: Color = .primary) { self.size = size; self.color = color }
    public var body: some View { ThinkingAnimation(.spark, size: size, color: color) }
}
public struct Morph: View {
    var size: CGFloat, color: Color
    public init(size: CGFloat = 24, color: Color = .primary) { self.size = size; self.color = color }
    public var body: some View { ThinkingAnimation(.morph, size: size, color: color) }
}
public struct HexCells: View {
    var size: CGFloat, color: Color
    public init(size: CGFloat = 24, color: Color = .primary) { self.size = size; self.color = color }
    public var body: some View { ThinkingAnimation(.hex, size: size, color: color) }
}
public struct PendulumWave: View {
    var size: CGFloat, color: Color
    public init(size: CGFloat = 24, color: Color = .primary) { self.size = size; self.color = color }
    public var body: some View { ThinkingAnimation(.pendulum, size: size, color: color) }
}
public struct Sunflower: View {
    var size: CGFloat, color: Color
    public init(size: CGFloat = 24, color: Color = .primary) { self.size = size; self.color = color }
    public var body: some View { ThinkingAnimation(.sunflower, size: size, color: color) }
}
public struct FlipTiles: View {
    var size: CGFloat, color: Color
    public init(size: CGFloat = 24, color: Color = .primary) { self.size = size; self.color = color }
    public var body: some View { ThinkingAnimation(.flip, size: size, color: color) }
}
public struct Attractor: View {
    var size: CGFloat, color: Color
    public init(size: CGFloat = 24, color: Color = .primary) { self.size = size; self.color = color }
    public var body: some View { ThinkingAnimation(.attractor, size: size, color: color) }
}
