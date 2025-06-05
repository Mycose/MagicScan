//
//  ScanView.swift
//  MagicScan
//
//  Created by Clément on 30/05/2025.
//

import SwiftUI

struct ScanView: View {
    @State private var showCamera = false
    @State private var image: UIImage?
    @State private var cardTitles: [String] = []
    @State private var navigateToResults = false
    
    private let cardRecognizer: CardRecognizer = CardRecognizer()
    
    var body: some View {
        NavigationStack {
            VStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
                
                if !cardTitles.isEmpty {
                    Text("Titres reconnu :\n\(cardTitles.joined(separator: "\n"))")
                        .padding()
                }
                
                Button("Prendre une photo") {
                    showCamera = true
                }
                .padding()
                .sheet(isPresented: $showCamera) {
                    ImagePicker(sourceType: .camera, selectedImage: Binding(
                        get: { image },
                        set: {
                            image = $0
                            if let img = $0 {
                                Task {
                                    if let titles = await cardRecognizer.recognizeTitlesFromImage(img) {
                                        self.cardTitles = titles
                                        if !cardTitles.isEmpty {
                                            self.navigateToResults = true
                                        }
                                    }
                                }
                            }
                        }
                    ))
                }
            }
            .navigationTitle("Scan de cartes")
            .navigationDestination(isPresented: $navigateToResults) {
                CardListView(titlesToSearch: cardTitles)
            }
        }
    }
}

#Preview {
    ScanView()
}
