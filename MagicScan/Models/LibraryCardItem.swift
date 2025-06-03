//
//  Card.swift
//  MagicScan
//
//  Created by Clément on 02/06/2025.
//

import Foundation

class LibraryCardItem: Identifiable, Codable, ObservableObject {
    var id: String { card.id }
    
    let card: Card
    var isFavorite: Bool
    
    @Published var isFoil: Bool
    @Published var amount: Int
    
    init(card: Card, amount: Int, isFavorite: Bool, isFoil: Bool) {
        self.card = card
        self.amount = amount
        self.isFavorite = isFavorite
        self.isFoil = isFoil
    }
    
    enum CodingKeys: String, CodingKey {
        case card, amount, isFavorite, isFoil
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.card = try container.decode(Card.self, forKey: .card)
        self.amount = try container.decode(Int.self, forKey: .amount)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        self.isFoil = try container.decode(Bool.self, forKey: .isFoil)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(card, forKey: .card)
        try container.encode(amount, forKey: .amount)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(isFoil, forKey: .isFoil)
    }
}
