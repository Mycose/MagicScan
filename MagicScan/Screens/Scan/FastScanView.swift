//
//  ScanView.swift
//  MagicScan
//
//  Created by Clément on 30/05/2025.
//

import SwiftUI
import AudioToolbox

struct FastScanView: View {
    @State private var cards: [Card] = []
    @State private var lastCard: Card? = nil
    @State private var navigateToResults = false
    @State private var resultToastPresented = false
    
    @State private var isCameraViewEnabled = true
    
    private let cardRecognizer = CardRecognizer()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                VStack {
                    CameraView(cardRecognizer: cardRecognizer) { card in
                        if lastCard?.id != card.id {
                            AudioServicesPlaySystemSound(1057)
                            self.lastCard = card
                            self.cards.append(card)
                            if lastCard != nil {
                                withAnimation {
                                    self.resultToastPresented = true
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation {
                                        self.resultToastPresented = false
                                    }
                                }
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.horizontal)
                }
                
                HStack {
                    VStack {
                        Button(action: {
                            navigateToResults = true
                        }) {
                            Image(systemName: "list.bullet")
                                .foregroundColor(.white)
                                .padding()
                        }
                        
                        Button(action: {
                            isCameraViewEnabled.toggle()
                        }) {
                            Image(systemName: isCameraViewEnabled ? "bolt.fill" : "bolt")
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .background(Color.black.opacity(0.6))
                    .clipShape(.buttonBorder)
                    .padding()
                }
                
            }
            .overlay(
                VStack {
                    Spacer()
                    if let card = lastCard, resultToastPresented {
                        CardToast(card: card)
                    }
                }
            )
            .navigationDestination(isPresented: $navigateToResults) {
                CardListViewNew(cards: cards)
                //CardListView(titlesToSearch: cardTitles.map { $0 })
            }
        }
    }
}

#Preview {
    FastScanView()
}
