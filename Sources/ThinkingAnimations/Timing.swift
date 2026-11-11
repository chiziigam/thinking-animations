import SwiftUI

/// Shared timing values. Change them in one place.
public enum ThinkingTiming {
    /// Seconds each animation stays on screen in `ThinkingIndicator`.
    public static let interval: TimeInterval = 8
    /// Seconds for the cross-fade between two animations.
    public static let blend: TimeInterval = 1.6
    /// Seconds for one opacity pulse when Reduce Motion is on.
    public static let reducedPulse: TimeInterval = 2.4
    /// Time value used for the still pose when Reduce Motion is on.
    static let stillPose: Double = 3
}
