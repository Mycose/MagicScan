//
//  Card.swift
//  MagicScan
//
//  Created by Clément on 02/06/2025.
//

import Foundation

struct Card: Codable, Identifiable {
    let id: String
    let name: String
    let typeLine: String
    let imageUris: ImageUris?
    let uri: String
    
    let prices: Prices

    enum CodingKeys: String, CodingKey {
        case name
        case typeLine = "type_line"
        case imageUris = "image_uris"
        case uri
        case prices
        case id
    }
    
    init(id: String, name: String, typeLine: String, imageUris: ImageUris?, uri: String, prices: Prices) {
        self.id = id
        self.name = name
        self.typeLine = typeLine
        self.imageUris = imageUris
        self.uri = uri
        self.prices = prices
    }
}

struct ImageUris: Codable {
    let normal: String
}

struct Prices: Codable {
    let usd: String?
    let usd_foil: String?
    let usd_etched: String?
    let eur: String?
    let eur_foil: String?
    let tix: String?
    
    init(usd: String? = nil, usd_foil: String? = nil, usd_etched: String? = nil, eur: String? = nil, eur_foil: String? = nil, tix: String? = nil) {
        self.usd = usd
        self.usd_foil = usd_foil
        self.usd_etched = usd_etched
        self.eur = eur
        self.eur_foil = eur_foil
        self.tix = tix
    }
}
