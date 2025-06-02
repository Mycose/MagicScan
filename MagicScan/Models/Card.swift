//
//  Card.swift
//  MagicScan
//
//  Created by Clément on 02/06/2025.
//

import Foundation

struct Card: Decodable, Identifiable {
    var id: String { return name }
    let name: String
    let typeLine: String
    let imageUris: ImageUris?

    enum CodingKeys: String, CodingKey {
        case name
        case typeLine = "type_line"
        case imageUris = "image_uris"
    }
}

struct ImageUris: Decodable {
    let normal: String
}
