//
//  BreathAnimation.swift
//  breathing-animation
//
//  Created by Denise Nepraunig on 17.05.21.
//
//  Code is based on this tutorial:
//  https://www.youtube.com/watch?v=KUvkJOhpB9A
//  Thanks Adam :-)
import SwiftUI

private func createColors(_ red: Double, _ green: Double, _ blue: Double) -> Color {
    Color(red: red / 255, green: green / 255, blue: blue / 255)
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

// pinkish colors
private let gradientStart = Color(hex: 0xFEC194)
private let gradientEnd = Color(hex: 0xFF0061)

// green and blueish color
// private let gradientStart = createColors(82, 215, 157)
// private let gradientEnd = createColors(51, 167, 175)
private let gradient = LinearGradient(gradient: Gradient(colors: [gradientStart, gradientEnd]), startPoint: .top, endPoint: .bottom)
private let maskGradient = LinearGradient(gradient: Gradient(colors: [.black]), startPoint: .top, endPoint: .bottom)

private let maxSize: CGFloat = 120
private let minSize: CGFloat = 30
private let inhaleTime: Double = 3
private let exhaleTime: Double = 4
private let pauseTime: Double = 0.5

private let numberOfPetals = 4
private let bigAngle = 360 / numberOfPetals
private let smallAngle = bigAngle / 2

private let ghostMaxSize: CGFloat = maxSize * 0.99
private let ghostMinSize: CGFloat = maxSize * 0.95

private struct Petals: View {
    let size: CGFloat
    let inhaling: Bool

    var isMask = false

    var body: some View {
        let petalsGradient = isMask ? maskGradient : gradient

        ZStack {
            ForEach(0..<numberOfPetals) { index in
                petalsGradient
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .mask(
                        Circle()
                            .frame(width: size, height: size)
                            .offset(x: inhaling ? size * 0.5 : 0)
                            .rotationEffect(.degrees(Double(bigAngle * index)))
                    )
                    .blendMode(isMask ? .normal : .screen)
            }
        }
    }
}

struct BreathAnimation: View {
    @State private var size = minSize
    @State private var inhaling = false

    @State private var ghostSize = ghostMaxSize
    @State private var ghostBlur: CGFloat = 0
    @State private var ghostOpacity: Double = 0

    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)

            ZStack {
                // ghosting for exhaling
                Petals(size: ghostSize, inhaling: inhaling)
                    .blur(radius: ghostBlur)
                    .opacity(ghostOpacity)

                // the mask is important, otherwise there is a color
                // 'jump' when exhaling
                Petals(size: size, inhaling: inhaling, isMask: true)

                // overlapping petals
                Petals(size: size, inhaling: inhaling)
                Petals(size: size, inhaling: inhaling)
                    .rotationEffect(.degrees(Double(smallAngle)))
                    .opacity(inhaling ? 0.8 : 0.6)
            }
            .rotationEffect(.degrees(Double(inhaling ? bigAngle : -smallAngle)))
            .drawingGroup()
        }
        .onAppear {
            performAnimations()
        }
    }

    private func performAnimations() {
        withAnimation(.easeInOut(duration: inhaleTime)) {
            inhaling = true
            size = maxSize
        }
        Timer.scheduledTimer(withTimeInterval: inhaleTime + pauseTime, repeats: false) { _ in
            ghostSize = ghostMaxSize
            ghostBlur = 0
            ghostOpacity = 0.8

            Timer.scheduledTimer(withTimeInterval: exhaleTime * 0.2, repeats: false) { _ in
                withAnimation(.easeOut(duration: exhaleTime * 0.6)) {
                    ghostBlur = 30
                    ghostOpacity = 0
                }
            }

            withAnimation(.easeInOut(duration: exhaleTime)) {
                inhaling = false
                size = minSize
                ghostSize = ghostMinSize
            }
        }

        Timer.scheduledTimer(withTimeInterval: inhaleTime + pauseTime + exhaleTime + pauseTime, repeats: false) { _ in

            // endless animation!
            performAnimations()
        }
    }
}

struct BreathAnimation_Previews: PreviewProvider {
    static var previews: some View {
        BreathAnimation()
    }
}
