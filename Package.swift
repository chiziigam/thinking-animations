// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ThinkingAnimations",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "ThinkingAnimations", targets: ["ThinkingAnimations"])],
    targets: [.target(name: "ThinkingAnimations")]
)
