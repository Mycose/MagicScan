//
//  TextRecognizer.swift
//  MagicScan
//
//  Created by Clément on 30/05/2025.
//

import UIKit
import Vision

class CardRecognizer {
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
    
    private func detectRectangles(in image: UIImage, completion: @escaping ([VNRectangleObservation]) -> Void) {
        guard let cgImage = image.cgImage else {
            completion([])
            return
        }
        
        let request = VNDetectRectanglesRequest { request, error in
            guard error == nil else {
                completion([])
                return
            }
            
            let rects = request.results as? [VNRectangleObservation] ?? []
            completion(rects)
        }
        
        request.maximumObservations = 10
        request.minimumConfidence = 0.6
        request.minimumAspectRatio = 0.65  // card ratio
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
    
    
    
    func recognizeTitlesFromImage(_ image: UIImage, completion: @escaping ([String]?) -> Void) {
        guard image.cgImage != nil else {
            completion(nil)
            return
        }
        
        
        var titles = Set<String>()
        
        detectRectangles(in: image, completion: { [weak self] rectangles in
            guard !rectangles.isEmpty else {
                completion(nil)
                return
            }
            
            let group = DispatchGroup()
            for rectangle in rectangles {
                if let cardImage = self?.cropCard(from: image, with: rectangle) {
                    group.enter()
                    
                    TitleRecognizer(completion: { title in
                        if let title = title {
                            titles.insert(title)
                        }
                        group.leave()
                    }).recognizeTitleFromImage(cardImage)
                }
            }
            
            group.notify(queue: .main) {
                completion(titles.sorted())
            }
            
        })
    }
}
