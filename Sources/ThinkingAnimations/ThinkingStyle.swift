import SwiftUI

/// All animations.
public enum ThinkingStyle: CaseIterable, Identifiable, Sendable {
    case figureEight, spark, morph, hex, pendulum, sunflower, flip, attractor
    case lissajous, cradle, ripple, life, rose, bars

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
        case .lissajous: "Lissajous"
        case .cradle: "Cradle"
        case .ripple: "Ripple"
        case .life: "Glider"
        case .rose: "Rose"
        case .bars: "Bars"
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
        case .lissajous: Drawing.lissajous
        case .cradle: Drawing.cradle
        case .ripple: Drawing.ripple
        case .life: Drawing.life
        case .rose: Drawing.rose
        case .bars: Drawing.bars
        }
    }
}
