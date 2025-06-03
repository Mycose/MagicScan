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

    enum CodingKeys: String, CodingKey {
        case name
        case typeLine = "type_line"
        case imageUris = "image_uris"
        case id
    }
    
    init(id: String, name: String, typeLine: String, imageUris: ImageUris?) {
        self.id = id
        self.name = name
        self.typeLine = typeLine
        self.imageUris = imageUris
    }
}

struct ImageUris: Codable {
    let normal: String
}
