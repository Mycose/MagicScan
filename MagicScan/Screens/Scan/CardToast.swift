//
//  CardToast.swift
//  MagicScan
//
//  Created by Clément on 12/06/2025.
//

import SwiftUI

struct CardToast: View {
    let card: Card
    var body: some View {
        Text("Carte détectée : \(card.name)")
            .padding()
            .background(.black.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.bottom, 30)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

#Preview {
    let card = Card.init(id: "123", name: "Test", typeLine: "okok", imageUris: nil, uri: "oko", prices: Prices.init())
    CardToast(card: card)
}
