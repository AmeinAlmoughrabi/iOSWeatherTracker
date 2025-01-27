//
//  SearchViewModel.swift
//  iOSWeatherTracker (iOS)
//
//  Created by Amein Almoughrabi on 1/26/25.
//

import Foundation
import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResults: [SearchResultWithWeather] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let weatherService: WeatherService
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    func performSearch() async {
        guard !searchText.isEmpty else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let rawLocations = try await weatherService.searchLocations(for: searchText)

            if rawLocations.isEmpty {
                // No results found
                self.errorMessage = "No results found for '\(searchText)'."
                self.searchResults = []
            } else {
                // Parse and display results
                var results = [SearchResultWithWeather]()
                for location in rawLocations {
                    let query = "\(location.lat),\(location.lon)"
                    let weather = try await weatherService.fetchCurrentWeather(for: query)
                    let iconURL = "https:\(weather.current.condition.icon)".replacingOccurrences(of: "64x64", with: "128x128")
                    results.append(SearchResultWithWeather(
                        cityName: location.name,
                        region: location.region,
                        country: location.country,
                        lat: location.lat,
                        lon: location.lon,
                        temperature: "\(Int(weather.current.temp))",
                        iconURL: URL(string: iconURL)
                    ))
                }
                self.errorMessage = nil // Clear any previous error
                self.searchResults = results
            }
        } catch URLError.notConnectedToInternet {
            self.errorMessage = "No network connection. Please check your internet and try again."
            self.searchResults = []
        } catch {
            self.errorMessage = "Failed to perform search. Please try again."
            self.searchResults = []
        }
    }

}
