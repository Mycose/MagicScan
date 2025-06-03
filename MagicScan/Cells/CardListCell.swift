//
//  CardListCell.swift
//  MagicScan
//
//  Created by Clément on 03/06/2025.
//

import SwiftUI

struct CardListCell: View {
    let item: LibraryCardItem
    let amount: Int = 1
    let isOn: Binding<Bool>
    
    var body: some View {
        HStack(spacing: 16) {
            Toggle("", isOn: isOn)
                .labelsHidden()
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
        let card = Card(id: "ok", name: "ok", typeLine: "ok", imageUris: nil)
        let item = LibraryCardItem(card: card, amount: 1, isFavorite: false)
        CardListCell(item: item, isOn: $isOn)
    }
}
