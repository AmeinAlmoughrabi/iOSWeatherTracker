//
//  WeatherData.swift
//  iOSWeatherTracker (iOS)
//
//  Created by Amein Almoughrabi on 1/26/25.
//

import Foundation

// MARK: - Top-level response
struct WeatherResponse: Decodable {
    let location: Location
    let current: Current
}

struct Location: Decodable {
    let name: String
    let region: String
    let country: String
}

struct Current: Decodable {
    let temp: Double
    let condition: Condition
    let humidity: Int
    let uv: Double
    let feelslike: Double
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp_f"
        case condition
        case humidity
        case uv
        case feelslike = "feelslike_f"

    }
}

struct Condition: Decodable {
    let text: String
    let icon: String
    let code: Int
}
