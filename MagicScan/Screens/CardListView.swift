//
//  CardResultList.swift
//  MagicScan
//
//  Created by Clément on 02/06/2025.
//

import SwiftUI

struct CardListView: View {
    var titlesToSearch: [String]
    
    @State private var isLoading = false
    @State private var hasLoaded = false
    @State private var cards: [Card] = []
    
    let service = ScryfallService()
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Chargement des cartes...")
                        .padding()
                } else if cards.isEmpty {
                    Text("Aucune carte trouvée.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ScrollView {
                        Text("Cartes cherché: \(titlesToSearch.joined(separator: ", "))")
                        List(cards) { card in
                            HStack(spacing: 16) {
                                if let urlString = card.imageUris?.normal,
                                   let url = URL(string: urlString) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 60, height: 85)
                                    .cornerRadius(4)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(card.name)
                                        .font(.headline)
                                    Text(card.typeLine)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Cartes Magic")
            .onAppear {
                if !hasLoaded {
                    isLoading = true
                    hasLoaded = true
                    service.fetchCards(from: titlesToSearch) { loadedCards in
                        self.cards = loadedCards
                        self.isLoading = false
                    }
                }
            }
        }
    }
}

#Preview {
    CardListView(titlesToSearch: ["Pierre moratoire"])
}
