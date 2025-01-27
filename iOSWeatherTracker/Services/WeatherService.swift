//
//  WeatherService.swift
//  iOSWeatherTracker (iOS)
//
//  Created by Amein Almoughrabi on 1/26/25.
//


import Foundation

// MARK: - Protocol
protocol WeatherService {
    func fetchCurrentWeather(for city: String) async throws -> WeatherResponse
    func searchLocations(for query: String) async throws -> [SearchLocation]
}

// MARK: - Implementation
struct WeatherServiceImpl: WeatherService {
    
    // Replace with your actual WeatherAPI key
    private let apiKey = "9b20b71a98664c7dac6180136252601"
    
    // Fetches current weather for a city (e.g. "Union City")
    // Must percent-encode the string so spaces become %20
    func fetchCurrentWeather(for city: String) async throws -> WeatherResponse {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw WeatherError.invalidURL
        }
        
        guard let url = URL(string: "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(encodedCity)") else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw WeatherError.invalidResponse
        }
        
        do {
            let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
            return decoded
        } catch {
            throw WeatherError.decodingError
        }
    }
    
    // Searches for multiple matching locations using /v1/search.json
    // e.g. "Union City" -> "Union%20City"
    func searchLocations(for query: String) async throws -> [SearchLocation] {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw WeatherError.invalidURL
        }
        
        guard let url = URL(string: "https://api.weatherapi.com/v1/search.json?key=\(apiKey)&q=\(encodedQuery)") else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw WeatherError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode([SearchLocation].self, from: data)
        } catch {
            throw WeatherError.decodingError
        }
    }
}

// MARK: - Custom Errors
enum WeatherError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL for Weather API."
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .decodingError:
            return "Failed to decode the weather data."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
