//
//  HomeView.swift
//  iOSWeatherTracker (iOS)
//
//  Created by Amein Almoughrabi on 1/26/25.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var isSearchPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Custom search bar button (or we can replicate the Figma text field)
                HStack {
                    Button(action: {
                        isSearchPresented = true
                    }) {
                        // Figma-like rounded rectangle with placeholder + icon
                        HStack {
                            Text("Search Location")
                                .foregroundColor(Color(hex: "#C4C4C4"))
                                .padding(.leading, 16)
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(hex: "#C4C4C4"))
                                .padding(.trailing, 16)
                        }
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "#F2F2F2"))
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 75)
                
                Spacer()
                
                if !viewModel.isCitySelected {
                    // Empty State
                    Text("No City Selected")
                    //  ideally the case should be this but it does not look like the figma so i will be using title
                    //  .font(Font.custom("Poppins", size: 30))
                    //  .fontWeight(.semibold)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#2C2C2C"))
                    
                    
                    Text("Please Search For A City")
                    //  ideally the case should be this but it does not look like the figma so i will be using title
                    //  .font(Font.custom("Poppins", size: 30))
                    //  .fontWeight(.semibold)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#2C2C2C"))

                } else {
                    // Weather details for the selected city
                    if let error = viewModel.errorMessage {
                        // Show error if any
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                    } else {
                        // Weather icon
                        if let iconURL = viewModel.weatherIconURL {
                            AsyncImage(url: iconURL) { image in
                                image
                                    .resizable()
                                    // Figma requires 123 but does not match when loaded with 123
                                    .frame(width: 150, height: 150)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        // Main city data
                        if let city = viewModel.cityName {
                            HStack {
                                Text(city)
                                //  ideally the case should be this but it does not look like the figma so i will be using title
                                //  .font(Font.custom("Poppins", size: 30))
                                //  .fontWeight(.semibold)
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                Image(systemName: "location.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 21, height: 21)
                                    .foregroundColor(Color(hex: "#2C2C2C"))
                            }
                        }
                        HStack {

                        Text(viewModel.temperature)
                            .font(.system(size: 70, weight: .bold))
                            .foregroundColor(Color(hex: "#2C2C2C"))
                            .padding(.trailing, -5)
                        Text("°")
                            .font(.system(size: 30))
                            .baselineOffset(30)
                        }
                        .padding(.top, -10)
                        
                        HStack(spacing: 50) {
                            // Humidity
                            VStack {
                                Text("Humidity")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#C4C4C4"))
                                Text(viewModel.humidity)
                                    .font(.body)
                                    .foregroundColor(Color(hex: "#9A9A9A"))
                            }
                            
                            // UV Index
                            VStack {
                                Text("UV")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#C4C4C4"))
                                Text(viewModel.uvIndex)
                                    .font(.body)
                                    .foregroundColor(Color(hex: "#9A9A9A"))
                            }
                            
                            // Feels like
                            VStack {
                                Text("Feels Like")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "#C4C4C4"))
                                Text(viewModel.feelsLike)
                                    .font(.body)
                                    .foregroundColor(Color(hex: "#9A9A9A"))
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex: "#F2F2F2"))
                        )
                    }
                }
                Spacer()
                Spacer()
                Spacer()
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $isSearchPresented) {
                SearchView(homeViewModel: viewModel)
            }
            .onAppear {
                // If there's a saved city, it will load automatically
            }
            .navigationBarHidden(true)
        }
    }
}

