//
//  Card.swift
//  MagicScan
//
//  Created by Clément on 02/06/2025.
//

import Foundation

struct LibraryCardItem: Identifiable, Codable {
    var id: String { card.id }
    
    let card: Card
    var amount: Int
    var isFavorite: Bool
    
    init(card: Card, amount: Int, isFavorite: Bool) {
        self.card = card
        self.amount = amount
        self.isFavorite = isFavorite
    }
}
