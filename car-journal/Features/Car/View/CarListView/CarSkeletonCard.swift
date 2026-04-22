//
//  CarSkeletonCard.swift
//  car-journal
//
//  Created by 2297 on 26/03/26.
//

import SwiftUI

struct CarSkeletonCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Accent bar placeholder
            Rectangle()
                .fill(Color.appShade1.opacity(0.3))
                .frame(height: 4)
                .clipShape(.rect(topLeadingRadius: 16, topTrailingRadius: 16))

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        skeletonBar(width: 160, height: 18)
                        skeletonBar(width: 100, height: 12)
                    }
                    Spacer()
                    skeletonBar(width: 56, height: 44, cornerRadius: 10)
                }

                Divider().opacity(0.3)

                HStack {
                    skeletonBar(width: 80, height: 32)
                    Spacer()
                    skeletonBar(width: 80, height: 32)
                }
            }
            .padding(16)
        }
        .background(Color.cjSurface)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.appDark.opacity(0.08), radius: 8, x: 0, y: 3)
        .shimmer()
    }

    private func skeletonBar(width: CGFloat, height: CGFloat, cornerRadius: CGFloat = 8) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(Color.cjTextSecondary.opacity(0.2))
            .frame(width: width, height: height)
    }
}

#Preview {
    ZStack {
        Color.cjBackground.ignoresSafeArea()
        VStack(spacing: 16) {
            CarSkeletonCard()
            CarSkeletonCard()
        }
        .padding()
    }
}
