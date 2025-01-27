//
//  SearchView.swift
//  iOSWeatherTracker (iOS)
//
//  Created by Amein Almoughrabi on 1/26/25.
//

import Foundation
import SwiftUI

struct SearchView: View {
    @StateObject private var searchVM: SearchViewModel
    @Environment(\.dismiss) private var dismiss
    
    let homeViewModel: HomeViewModel
    
    init(homeViewModel: HomeViewModel) {
        _searchVM = StateObject(wrappedValue: SearchViewModel(weatherService: WeatherServiceImpl()))
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Type a city name or zip code", text: $searchVM.searchText)
                        .padding()
                        .submitLabel(.search)
                        .onSubmit {
                            Task {
                                await searchVM.performSearch()
                            }
                        }
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(hex: "#C4C4C4"))
                        .padding(.trailing, 16)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "#F2F2F2"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                )
                
                if searchVM.isLoading {
                    ProgressView("Searching...")
                }
                else if let error = searchVM.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                }
                else {
                    // Scrollable list of results
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(searchVM.searchResults) { item in
                                Button {
                                    Task {
                                        // Use the specific city's full details (lat/lon) to fetch weather
                                        let query = "\(item.lat),\(item.lon)"
                                        await homeViewModel.updateWeather(for: query)
                                        dismiss()
                                    }
                                } label: {
                                    SearchResultCard(
                                        cityAndState: "\(item.cityName), \(item.region)",
                                        temperature: item.temperature,
                                        iconURL: item.iconURL
                                    )
                                }
                                .buttonStyle(.plain) // Keep the card styling
                            }
                        }
                        .padding()
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Search Location")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
