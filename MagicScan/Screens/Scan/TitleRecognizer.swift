//
//  TitleRecognizer.swift
//  MagicScan
//
//  Created by Clément on 02/06/2025.
//

import UIKit
import Vision

class TitleRecognizer {
    let completion: ((String?) -> Void)
    
    init(completion: @escaping (String?) -> Void) {
        self.completion = completion
    }
    
    func recognizeTitleFromImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)

        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        
        if let title = recognizedStrings.first {
            // remove numbers
            completion(title.replacingOccurrences(of: "\\d", with: "", options: .regularExpression))
        } else {
            completion(nil)
        }
    }
}
