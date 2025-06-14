//
//  TextRecognizer.swift
//  MagicScan
//
//  Created by Clément on 30/05/2025.
//

import UIKit
@preconcurrency import Vision

actor CardRecognizer {
    private func cropCard(from image: UIImage, with rect: VNRectangleObservation) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        let boundingBox = rect.boundingBox
        
        // La boundingBox est normalisée (0-1), on doit la convertir en pixels
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        
        let cropRect = CGRect(
            x: boundingBox.origin.x * width,
            y: (1 - boundingBox.origin.y - boundingBox.height) * height,
            width: boundingBox.width * width,
            height: boundingBox.height * height)
        
        
        guard let croppedCgImage = cgImage.cropping(to: cropRect) else { return nil }
        
        let croppedImage = UIImage(cgImage: croppedCgImage)
        return croppedImage
    }
    
    private func detectRectangles(in image: UIImage) async -> [VNRectangleObservation] {
        guard let cgImage = image.cgImage else {
            return []
        }
        
        return await withCheckedContinuation { continuation in
            let rectangleRequest = VNDetectRectanglesRequest { request, error in
                DispatchQueue.main.async {
                    guard error == nil,
                          let rects = request.results as? [VNRectangleObservation] else {
                        continuation.resume(returning: [])
                        return
                    }
                    continuation.resume(returning: rects)
                }
            }
                
            rectangleRequest.maximumObservations = 10
            rectangleRequest.minimumConfidence = 0.8
            rectangleRequest.minimumAspectRatio = 0.65
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([rectangleRequest])
            } catch {
                continuation.resume(returning: [])
            }
        }
    }
    
    let scryfallService = ScryfallService()
    
    private var lastTitle: String? = nil
    private func updateLastTitle(title: String) {
        self.lastTitle = title
    }
    
    func recognizeAndGetCardFromImage(_ image: UIImage) async -> Card? {
        guard image.cgImage != nil else {
            return nil
        }
        
        let rectangles = await detectRectangles(in: image)
        guard !rectangles.isEmpty else { return nil }
        
        var cards = [Card]()
        await withTaskGroup(of: Card?.self) { group in
            for rectangle in rectangles {
                if let card = self.cropCard(from: image, with: rectangle) {
                    group.addTask {
                        if let title = await TitleRecognizer().recognizeTitleFromImage(card) {
                            let lhs = title
                            let rhs = await self.lastTitle ?? ""
                            
                            if !StringComparator(lhs: lhs, rhs: rhs).areStringsSimilar() {
                                let card = await self.scryfallService.fetchCard(from: title)
                                if card != nil {
                                    await self.updateLastTitle(title: title)
                                }
                                return card
                            } else {
                                return nil
                            }
                        } else {
                            return nil
                        }
                    }
                }
            }
            
            for await result in group {
                if let card = result {
                    cards.append(card)
                }
            }
        }
        return cards.first
    }
    
    func recognizeTitlesFromImage(_ image: UIImage) async -> [String]? {
        guard image.cgImage != nil else {
            return nil
        }
        
        let rectangles = await detectRectangles(in: image)
        guard !rectangles.isEmpty else { return nil }
        
        var titles = Set<String>()
        
        await withTaskGroup(of: String?.self) { group in
            for rectangle in rectangles {
                if let card = self.cropCard(from: image, with: rectangle) {
                    group.addTask {
                        return await TitleRecognizer().recognizeTitleFromImage(card)
                    }
                }
            }
            
            for await result in group {
                if let title = result {
                    titles.insert(title)
                }
            }
        }
        return titles.sorted()
    }
}
