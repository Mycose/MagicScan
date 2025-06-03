//
//  ScryfallService.swift
//  MagicScan
//
//  Created by Clément on 02/06/2025.
//

import Foundation

class ScryfallService {
    func fetchCard(named name: String, completion: @escaping (Card?) -> Void) {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        print("URL = \("https://api.scryfall.com/cards/named?fuzzy=\(encodedName)")")
        guard let url = URL(string: "https://api.scryfall.com/cards/named?fuzzy=\(encodedName)") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Erreur réseau : \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("❌ Données vides")
                completion(nil)
                return
            }
            
            do {
                let card = try JSONDecoder().decode(Card.self, from: data)
print("completionCard")
                completion(card)
            } catch {
                print("❌ Erreur de décodage JSON : \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("🔍 Données reçues : \(jsonString)")
                }
                completion(nil)
            }
        }.resume()
    }
    
    func fetchCards(from names: [String], completion: @escaping ([Card]) -> Void) {
        var cards: [Card] = []
        let group = DispatchGroup()
        
        for name in names {
            group.enter()
            fetchCard(named: name) { card in
                if let card = card {
                    cards.append(card)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(cards)
        }
    }
}
