//
//  City.swift
//  City Finder
//
//  Created by Attia Mo on 9/24/18.
//  Copyright © 2018 Attia Mo. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let city = try? newJSONDecoder().decode(City.self, from: jsonData)

import Foundation

struct City: Codable {
    let country, name: String?
    let id: Int?
    let coord: Coord?
    
    enum CodingKeys: String, CodingKey {
        case country, name
        case id = "_id"
        case coord
    }
}

struct Coord: Codable {
    let lon, lat: Double?
}
