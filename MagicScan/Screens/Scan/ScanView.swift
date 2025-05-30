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
    @State private var cardTitles: [String]?
    
    private let cardRecognizer: CardRecognizer = CardRecognizer()
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }
            
            if let titles = cardTitles {
                Text("Titres reconnu :\n\(titles.joined(separator: "\n"))")
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
                            cardRecognizer.recognizeTitlesFromImage(img) { titles in
                                cardTitles = titles
                            }
                        }
                    }
                ))
            }
        }
    }
}

#Preview {
    ScanView()
}
