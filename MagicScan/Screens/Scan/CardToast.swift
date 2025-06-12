//
//  CardToast.swift
//  MagicScan
//
//  Created by Clément on 12/06/2025.
//

import SwiftUI

struct CardToast: View {
    let cardTitle: String
    var body: some View {
        Text("Carte détectée : \(cardTitle)")
            .padding()
            .background(.black.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.bottom, 30)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

#Preview {
    CardToast(cardTitle: "coucou")
}
