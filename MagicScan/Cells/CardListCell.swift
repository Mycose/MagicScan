//
//  CardListCell.swift
//  MagicScan
//
//  Created by Clément on 03/06/2025.
//

import SwiftUI

struct CardListCell: View {
    @ObservedObject var item: LibraryCardItem
    let isOn: Binding<Bool>
    
    var body: some View {
        HStack(spacing: 16) {
            Toggle("Foil?", isOn: isOn)
                .frame(width: 50)
            
            if let urlString = item.card.imageUris?.normal,
               let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 60, height: 85)
                .cornerRadius(4)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.card.name)
                    .font(.headline)
                Text(item.card.typeLine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    if let eur = item.card.prices.eur {
                        Text(eur)
                    }
                    if let feur = item.card.prices.eur_foil {
                        Text("Foil: \(feur)")
                    }
                }
                
                Stepper("Number: \(item.amount)", value: $item.amount, in: 1...99)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PreviewWrapper()
}

struct PreviewWrapper: View {
    @State private var isOn: Bool = false

    var body: some View {
        let card = Card(id: "ok", name: "ok", typeLine: "ok", imageUris: nil, uri: "", prices: Prices())
        let item = LibraryCardItem(card: card, amount: 1, isFavorite: false, isFoil: false)
        CardListCell(item: item, isOn: $isOn)
    }
}
