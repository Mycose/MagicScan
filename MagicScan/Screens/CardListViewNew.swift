//
//  CardResultList.swift
//  MagicScan
//
//  Created by Clément on 02/06/2025.
//

import SwiftUI

struct CardListViewNew: View {
    @State private var isLoading = false
    @State private var hasLoaded = false
    
    @State private var toggledCards: [String: Bool] = [:]
    var cards: [Card] = []
    
    @State private var items: [LibraryCardItem] = []
    
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
                    ZStack {
                        List {
                            Section(header: Text("Cartes:")) {
                                ForEach(items) { item in
                                    CardListCell(item: item, isOn: binding(for: item.id))
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                        
                        VStack {
                            Spacer()
                            Button {
                                
                            } label: {
                                Text("Add to library")
                            }
                            .padding()
                            .background(.white)
                            .clipShape(Capsule(style: .continuous))
                            .foregroundStyle(.black)
                            
                        }
                        .padding(.bottom)
                    }
                    

                }
            }
            .navigationTitle("Cartes Magic")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                items = cards.map { LibraryCardItem(card: $0, amount: 1, isFavorite: false, isFoil: false) }
            }
        }
    }
    
    private func binding(for id: String) -> Binding<Bool> {
        Binding(
            get: { toggledCards[id, default: false] },
            set: { toggledCards[id] = $0 }
        )
    }
}

#Preview {
    CardListViewNew(cards: [])
}
