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
        // A glider on an 6x6 wrapping grid, advanced four steps per second.
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
        let cell = 96.0 / 6
        for (x, y) in frame {
            let gx = ((x + shift) % 6 + 6) % 6, gy = ((y + shift) % 6 + 6) % 6
            let rect = CGRect(x: Double(gx) * cell + 2, y: Double(gy) * cell + 2, width: cell - 4, height: cell - 4)
            gc.fill(Path(roundedRect: rect, cornerRadius: 3), with: .color(ink.opacity(0.95)))
        }
    }

    static func rose(_ gc: inout GraphicsContext, _ t: Double, _ ink: Color) {
        let k = 3.5 + 1.5 * sin(t * 0.3) // petal count drifts between 2 and 5
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

    static func wave(_ gc: inout GraphicsContext, _ t: Double, _ ink: Color) {
        var path = Path()
        for i in 0...80 {
            let x = 8 + Double(i) / 80 * 80
            let edge = sin(Double(i) / 80 * .pi)
            let y = 48 + 26 * edge * sin(Double(i) / 80 * 2 * .pi * 1.5 - t * 3.2)
            let p = CGPoint(x: x, y: y)
            i == 0 ? path.move(to: p) : path.addLine(to: p)
        }
        gc.stroke(path, with: .color(ink), style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
    }

    static func helix(_ gc: inout GraphicsContext, _ t: Double, _ ink: Color) {
        let n = 9
        for i in 0..<n {
            let x = 12 + Double(i) * 9
            let a = t * 2.4 + Double(i) * 0.7
            for strand in 0..<2 {
                let s = strand == 0 ? 1.0 : -1.0
                let depth = cos(a) * s
                dot(&gc, x, 48 + sin(a) * 28 * s, 3.2 + 1.6 * depth, 0.55 + 0.45 * depth, ink)
            }
        }
    }

    static func spirograph(_ gc: inout GraphicsContext, _ t: Double, _ ink: Color) {
        let big = 5.0, small = 3.0, d = 4.2
        let scale = 36 / (big - small + d)
        var path = Path()
        for i in 0...600 {
            let th = Double(i) / 600 * 2 * .pi * 3
            let x = (big - small) * cos(th) + d * cos((big - small) / small * th)
            let y = (big - small) * sin(th) - d * sin((big - small) / small * th)
            let rot = t * 0.5
            let p = CGPoint(x: 48 + (x * cos(rot) - y * sin(rot)) * scale, y: 48 + (x * sin(rot) + y * cos(rot)) * scale)
            i == 0 ? path.move(to: p) : path.addLine(to: p)
        }
        gc.stroke(path, with: .color(ink), style: StrokeStyle(lineWidth: 2.6, lineCap: .round, lineJoin: .round))
    }

    static func dotGrid(_ gc: inout GraphicsContext, _ t: Double, _ ink: Color) {
        for i in 0..<5 {
            for j in 0..<5 {
                let dist = (Double(i - 2) * Double(i - 2) + Double(j - 2) * Double(j - 2)).squareRoot()
                let s = 0.5 + 0.5 * sin(t * 3 - dist * 1.1)
                dot(&gc, 12 + Double(i) * 18, 12 + Double(j) * 18, 2.5 + 5.5 * s, 0.35 + 0.65 * s, ink)
            }
        }
    }

    static func squares(_ gc: inout GraphicsContext, _ t: Double, _ ink: Color) {
        for i in 0..<5 {
            let half = 7 + Double(i) * 6
            let a = sin(t * 0.9 - Double(i) * 0.45) * .pi / 2
            var path = Path()
            for k in 0..<4 {
                let th = a + Double(k) * .pi / 2 + .pi / 4
                let p = CGPoint(x: 48 + cos(th) * half * 1.414, y: 48 + sin(th) * half * 1.414)
                k == 0 ? path.move(to: p) : path.addLine(to: p)
            }
            path.closeSubpath()
            gc.stroke(path, with: .color(ink.opacity(0.35 + 0.65 * Double(i) / 4)), style: StrokeStyle(lineWidth: 3, lineJoin: .round))
        }
    }

    static func moire(_ gc: inout GraphicsContext, _ t: Double, _ ink: Color) {
        let offset = 10 * sin(t * 1.1)
        for shift in [-offset, offset] {
            for i in 1...6 {
                let r = Double(i) * 6.2
                let rect = CGRect(x: 48 + shift - r, y: 48 - r, width: r * 2, height: r * 2)
                gc.stroke(Path(ellipseIn: rect), with: .color(ink.opacity(0.7)), lineWidth: 1.8)
            }
        }
    }

    static func cube(_ gc: inout GraphicsContext, _ t: Double, _ ink: Color) {
        let corners: [(Double, Double, Double)] = (0..<8).map { i in
            (i & 1 == 0 ? -1 : 1, i & 2 == 0 ? -1 : 1, i & 4 == 0 ? -1 : 1)
        }
        let ay = t * 0.8, ax = 0.6 + 0.3 * sin(t * 0.5)
        let projected: [CGPoint] = corners.map { c in
            let x1 = c.0 * cos(ay) + c.2 * sin(ay)
            let z1 = -c.0 * sin(ay) + c.2 * cos(ay)
            let y2 = c.1 * cos(ax) - z1 * sin(ax)
            let z2 = c.1 * sin(ax) + z1 * cos(ax)
            let k = 1 / (1 - z2 * 0.12)
            return CGPoint(x: 48 + x1 * 24 * k, y: 48 + y2 * 24 * k)
        }
        var path = Path()
        for i in 0..<8 {
            for bit in [1, 2, 4] where i & bit == 0 {
                path.move(to: projected[i])
                path.addLine(to: projected[i | bit])
            }
        }
        gc.stroke(path, with: .color(ink), style: StrokeStyle(lineWidth: 3.2, lineCap: .round))
        for p in projected { dot(&gc, p.x, p.y, 3.6, 1, ink) }
    }

    static func snake(_ gc: inout GraphicsContext, _ t: Double, _ ink: Color) {
        // A lit path moves along the serpentine order of a 4x4 grid.
        let order: [(Int, Int)] = (0..<16).map { i in
            let row = i / 4, col = i % 4
            return (row % 2 == 0 ? col : 3 - col, row)
        }
        let head = t * 7
        for (i, cell) in order.enumerated() {
            var d = head - Double(i)
            d = d.truncatingRemainder(dividingBy: 16)
            if d < 0 { d += 16 }
            let lit = d < 5 ? 1 - d / 5 : 0
            let rect = CGRect(x: 8 + Double(cell.0) * 21, y: 8 + Double(cell.1) * 21, width: 17, height: 17)
            gc.fill(Path(roundedRect: rect, cornerRadius: 4), with: .color(ink.opacity(0.12 + 0.88 * lit)))
        }
    }
}
