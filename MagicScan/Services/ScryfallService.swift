//
//  ScryfallService.swift
//  MagicScan
//
//  Created by Clément on 02/06/2025.
//

import Foundation

class ScryfallService {
    func fetchCards(from names: [String]) async -> [Card] {
        var cards: [Card] = []
        
        await withTaskGroup(of: Card?.self) { group in
            for name in names {
                group.addTask {
                    await CardFetcher.fetchCardStatic(named: name)
                }
            }
            
            var localCards: [Card] = []
            for await card in group {
                if let card = card {
                    localCards.append(card)
                }
            }
            cards = localCards
        }
        return cards
    }
}

struct CardFetcher {
    static func fetchCardStatic(named name: String) async -> Card? {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        print("URL = \("https://api.scryfall.com/cards/named?fuzzy=\(encodedName)")")
        guard let url = URL(string: "https://api.scryfall.com/cards/named?fuzzy=\(encodedName)") else {
            return nil
        }
        
        return await withCheckedContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("❌ Erreur réseau : \(error.localizedDescription)")
                    continuation.resume(returning: nil)
                    return
                }
                
                guard let data = data else {
                    print("❌ Données vides")
                    continuation.resume(returning: nil)
                    return
                }
                
                do {
                    let card = try JSONDecoder().decode(Card.self, from: data)
                    continuation.resume(returning: card)
                } catch {
                    print("❌ Erreur de décodage JSON : \(error)")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("🔍 Données reçues : \(jsonString)")
                    }
                    continuation.resume(returning: nil)
                }
            }.resume()
        }
    }
}
