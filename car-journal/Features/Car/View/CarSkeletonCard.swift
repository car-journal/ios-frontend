//
//  CarSkeletonCard.swift
//  car-journal
//
//  Created by 2297 on 26/03/26.
//

import SwiftUI

struct CarSkeletonCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 20)
            
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 16)
                .frame(maxWidth: 200)
            
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 16)
                .frame(maxWidth: 120)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
        )
        .shimmer()
    }
}
