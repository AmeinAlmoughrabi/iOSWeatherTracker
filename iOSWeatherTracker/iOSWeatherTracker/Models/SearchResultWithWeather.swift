//
//  SearchResultWithWeather.swift
//  iOSWeatherTracker (iOS)
//
//  Created by Amein Almoughrabi on 1/26/25.
//

import Foundation

struct SearchResultWithWeather: Identifiable {
    // Unique ID for SwiftUI's List/ForEach
    let id = UUID()
    
    // Location info from WeatherAPI /v1/search.json
    let cityName: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    
    // Weather info from /v1/current.json
    let temperature: String
    let iconURL: URL?
}
