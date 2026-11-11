import SwiftUI

extension Drawing {
    static func lissajous(_ gc: inout GraphicsContext, _ t: Double, _ ink: Color) {
        func point(_ s: Double) -> CGPoint {
            CGPoint(x: 48 + 34 * sin(3 * s + t * 0.4), y: 48 + 34 * sin(2 * s))
        }
        let head = t * 1.6
        for m in stride(from: 40, through: 1, by: -1) {
            let p = point(head - Double(m) * 0.045)
            dot(&gc, p.x, p.y, 3, pow(1 - Double(m) / 41, 2) * 0.7, ink)
        }
        let p = point(head)
        dot(&gc, p.x, p.y, 5, 1, ink)
    }

    static func cradle(_ gc: inout GraphicsContext, _ t: Double, _ ink: Color) {
        let n = 5, r = 7.0, length = 44.0
        let phase = t * 2.6
        let swing = sin(phase)
        let left = max(0, swing) * 0.62, right = max(0, -swing) * 0.62
        for i in 0..<n {
            let angle = i == 0 ? -left : (i == n - 1 ? right : 0)
            let pivot = CGPoint(x: 48 + (Double(i) - 2) * r * 2, y: 14)
            let bob = CGPoint(x: pivot.x + sin(angle) * length, y: pivot.y + cos(angle) * length)
            var line = Path()
            line.move(to: pivot)
            line.addLine(to: bob)
            gc.stroke(line, with: .color(ink.opacity(0.35)), lineWidth: 1.6)
            dot(&gc, bob.x, bob.y, r, 0.95, ink)
        }
    }

    static func ripple(_ gc: inout GraphicsContext, _ t: Double, _ ink: Color) {
        let rings = 4
        for i in 0..<rings {
            let u = (t * 0.45 + Double(i) / Double(rings)).truncatingRemainder(dividingBy: 1)
            let r = 4 + u * 40
            let path = Path(ellipseIn: CGRect(x: 48 - r, y: 48 - r, width: r * 2, height: r * 2))
            gc.stroke(path, with: .color(ink.opacity((1 - u) * 0.9)), lineWidth: 5 * (1 - u) + 1)
        }
        dot(&gc, 48, 48, 4, 1, ink)
    }

    static func life(_ gc: inout GraphicsContext, _ t: Double, _ ink: Color) {
        // A glider on an 8x8 wrapping grid, advanced four steps per second.
        let glider: [[(Int, Int)]] = {
            var cells: Set<[Int]> = [[1, 0], [2, 1], [0, 2], [1, 2], [2, 2]]
            var out: [[(Int, Int)]] = []
            for _ in 0..<4 {
                out.append(cells.map { ($0[0], $0[1]) })
                var counts: [[Int]: Int] = [:]
                for c in cells {
                    for dx in -1...1 { for dy in -1...1 where dx != 0 || dy != 0 {
                        counts[[c[0] + dx, c[1] + dy], default: 0] += 1
                    } }
                }
                cells = Set(counts.filter { $0.value == 3 || ($0.value == 2 && cells.contains($0.key)) }.keys)
            }
            return out
        }()
        let step = Int(t * 4)
        let frame = glider[step % 4]
        let shift = step / 4
        let cell = 96.0 / 8
        for (x, y) in frame {
            let gx = ((x + shift) % 8 + 8) % 8, gy = ((y + shift) % 8 + 8) % 8
            let rect = CGRect(x: Double(gx) * cell + 2, y: Double(gy) * cell + 2, width: cell - 4, height: cell - 4)
            gc.fill(Path(roundedRect: rect, cornerRadius: 3), with: .color(ink.opacity(0.95)))
        }
    }

    static func rose(_ gc: inout GraphicsContext, _ t: Double, _ ink: Color) {
        let k = 3 + 2 * sin(t * 0.3) // petal count drifts between 1 and 5
        var path = Path()
        for i in 0...360 {
            let th = Double(i) / 360 * 2 * .pi * 2
            let r = 36 * cos(k * th)
            let p = CGPoint(x: 48 + r * cos(th + t * 0.4), y: 48 + r * sin(th + t * 0.4))
            i == 0 ? path.move(to: p) : path.addLine(to: p)
        }
        gc.stroke(path, with: .color(ink), style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round))
    }

    static func bars(_ gc: inout GraphicsContext, _ t: Double, _ ink: Color) {
        let n = 5
        for i in 0..<n {
            let s = 0.5 + 0.5 * sin(t * 4 - Double(i) * 0.7)
            let h = 16 + 56 * s
            let rect = CGRect(x: 10 + Double(i) * 17.5, y: 48 - h / 2, width: 11, height: h)
            gc.fill(Path(roundedRect: rect, cornerRadius: 5.5), with: .color(ink.opacity(0.4 + 0.6 * s)))
        }
    }
}
