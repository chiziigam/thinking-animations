import SwiftUI

/// The eight animations.
public enum ThinkingStyle: CaseIterable, Identifiable, Sendable {
    case figureEight, spark, morph, hex, pendulum, sunflower, flip, attractor

    public var id: Self { self }

    public var title: String {
        switch self {
        case .figureEight: "Figure eight"
        case .spark: "Spark"
        case .morph: "Morph"
        case .hex: "Hex cells"
        case .pendulum: "Pendulum wave"
        case .sunflower: "Sunflower"
        case .flip: "Flip tiles"
        case .attractor: "Attractor"
        }
    }

    var draw: (inout GraphicsContext, Double, Color) -> Void {
        switch self {
        case .figureEight: Drawing.figureEight
        case .spark: Drawing.spark
        case .morph: Drawing.morph
        case .hex: Drawing.hex
        case .pendulum: Drawing.pendulum
        case .sunflower: Drawing.sunflower
        case .flip: Drawing.flip
        case .attractor: Drawing.attractor
        }
    }
}
