//
//  TitleRecognizer.swift
//  MagicScan
//
//  Created by Clément on 02/06/2025.
//

import UIKit
@preconcurrency import Vision

class TitleRecognizer {
    func recognizeTitleFromImage(_ image: UIImage) async -> String? {
        guard let cgImage = image.cgImage else { return nil }
        
        return await withCheckedContinuation { continuation in
            let request = VNRecognizeTextRequest()
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            request.minimumTextHeight = 0.02 // optionnel
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                    
                    guard let observations = request.results else {
                        continuation.resume(returning: nil)
                        return
                    }
                    
                    let recognizedStrings = observations.compactMap {
                        $0.topCandidates(1).first?.string
                    }
                    
                    if let title = recognizedStrings.first {
                        let cleaned = title.replacingOccurrences(of: "\\d", with: "", options: .regularExpression)
                        continuation.resume(returning: cleaned)
                    } else {
                        continuation.resume(returning: nil)
                    }
                } catch {
                    print("Text recognition failed: \(error)")
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
