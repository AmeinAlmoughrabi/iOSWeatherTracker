//
//  SearchLocation.swift
//  iOSWeatherTracker (iOS)
//
//  Created by Amein Almoughrabi on 1/26/25.
//

import Foundation

struct SearchLocation: Decodable, Identifiable {
    // WeatherAPI's /v1/search.json might or might not return an "id" field.
    // We'll parse into rawID (if present); otherwise, fallback to lat/lon or generate.
    let rawID: Int?
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    
    // If 'rawID' is nil, we'll just use a random int to satisfy Identifiable
    var id: Int {
        rawID ?? Int.random(in: 0..<Int.max)
    }
    
    // Map the JSON keys to our Swift properties
    enum CodingKeys: String, CodingKey {
        case rawID = "id"
        case name
        case region
        case country
        case lat
        case lon
    }
}
