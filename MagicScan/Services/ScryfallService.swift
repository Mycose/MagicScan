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
        guard let url = URL(string: "https://api.scryfall.com/cards/named?fuzzy=\(encodedName)") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let card = try? JSONDecoder().decode(Card.self, from: data) else {
                completion(nil)
                return
            }
            completion(card)
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
