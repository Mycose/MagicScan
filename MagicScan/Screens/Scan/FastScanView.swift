//
//  ScanView.swift
//  MagicScan
//
//  Created by Clément on 30/05/2025.
//

import SwiftUI
import AudioToolbox

struct FastScanView: View {
    @State private var cardTitles: Set<String> = []
    @State private var lastCardTitle: String = ""
    @State private var navigateToResults = false
    @State private var resultToastPresented = false
    
    @State private var isCameraViewEnabled = true
    
    private let cardRecognizer = CardRecognizer()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                VStack {
                    CameraView(cardRecognizer: cardRecognizer) { titles in
                        if let newTitle = titles.first, newTitle != self.lastCardTitle {
                            AudioServicesPlaySystemSound(1057)
                            self.lastCardTitle = newTitle
                            self.cardTitles.insert(newTitle)
                            if !self.lastCardTitle.isEmpty {
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
                    if resultToastPresented {
                        CardToast(cardTitle: lastCardTitle)
                    }
                }
            )
            .navigationDestination(isPresented: $navigateToResults) {
                CardListView(titlesToSearch: cardTitles.map { $0 })
            }
        }
    }
}

#Preview {
    FastScanView()
}
