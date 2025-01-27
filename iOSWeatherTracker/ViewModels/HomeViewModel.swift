//
//  HomeViewModel.swift
//  iOSWeatherTracker (iOS)
//
//  Created by Amein Almoughrabi on 1/26/25.
//

import SwiftUI
import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    // Published properties for weather data
    @Published var cityName: String = ""
    @Published var temperature: String = "--"
    @Published var weatherIconURL: URL?
    @Published var humidity: String = "--"
    @Published var uvIndex: String = "--"
    @Published var feelsLike: String = "--"
    
    @Published var isCitySelected: Bool = false
    @Published var errorMessage: String?
    
    private let weatherService: WeatherService
    
    // UserDefaults keys
    private let userDefaults = UserDefaults.standard
    private let savedQueryKey = "SAVED_QUERY_KEY" // Key for persisting the exact lat,lon
    private let lastUpdatedKey = "LAST_UPDATED_KEY" // Key for the timestamp of the last update
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
        // Attempt to load a previously saved city when the ViewModel initializes
        loadSavedCity()
    }
    
    /// Loads the saved query (lat,lon) from UserDefaults and fetches its weather.
    func loadSavedCity() {
        if let savedQuery = userDefaults.string(forKey: savedQueryKey),
           !savedQuery.isEmpty {
            Task {
                print("Restoring saved city with query: \(savedQuery)") // Debugging
                await updateWeather(for: savedQuery)
            }
        } else {
            print("No saved city found.") // Debugging
            self.isCitySelected = false
        }
    }
    
    /// Fetches current weather for the given query (lat,lon or city name) and updates published properties.
    /// Also persists the query to UserDefaults if the API call succeeds.
    func updateWeather(for query: String) async {
        do {
            print("Fetching weather for query: \(query)") // Debugging
            
            // Fetch weather using the query (can be city name or lat,lon)
            let weather = try await weatherService.fetchCurrentWeather(for: query)
            
            // Update the home menu with the fetched weather details
            self.cityName = weather.location.name
            self.temperature = "\(Int(weather.current.temp))"
            self.feelsLike = "\(Int(weather.current.feelslike))°"
            self.humidity = "\(weather.current.humidity)%"
            self.uvIndex = "\(weather.current.uv)"
            
            // Adjust the icon URL to use 128x128 resolution
            let originalIconURL = weather.current.condition.icon
                let adjustedIconURL = originalIconURL.replacingOccurrences(of: "64x64", with: "128x128")
                self.weatherIconURL = URL(string: "https:\(adjustedIconURL)")
            
            
            self.isCitySelected = true
            self.errorMessage = nil // Clear any previous error
            saveQuery(query: query) // Save the query
            
        } catch URLError.notConnectedToInternet {
            self.errorMessage = "No network connection. Please check your internet and try again."
            self.isCitySelected = false
            print("Error: No network connection.") // Debugging
        } catch {
            self.errorMessage = "Failed to fetch weather. Please try again."
            self.isCitySelected = false
            print("Error updating weather: \(error.localizedDescription)") // Debugging
        }
    }

    
    /// Saves the given query (e.g., lat,lon) to UserDefaults.
    private func saveQuery(query: String) {
        print("Saving query to UserDefaults: \(query)") // Debugging
        userDefaults.set(query, forKey: savedQueryKey)
    }
    
    /// Clears the saved query in UserDefaults and resets the view model.
    func clearSavedCity() {
        print("Clearing saved city and resetting state.") // Debugging
        userDefaults.removeObject(forKey: savedQueryKey)
        userDefaults.removeObject(forKey: lastUpdatedKey)
        self.cityName = ""
        self.temperature = "--"
        self.feelsLike = "--"
        self.humidity = "--"
        self.uvIndex = "--"
        self.weatherIconURL = nil
        self.isCitySelected = false
    }
}
