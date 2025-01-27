//
//  SearchResultCard.swift
//  iOSWeatherTracker (iOS)
//
//  Created by Amein Almoughrabi on 1/26/25.
//

import Foundation
import SwiftUI

struct SearchResultCard: View {
    let cityAndState: String  // e.g., "Union City, New Jersey"
    let temperature: String   // e.g., "28°"
    let iconURL: URL?         // e.g., http://cdn.weatherapi.com/...
    
    var body: some View {
        ZStack {
            // Light gray background
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "#F2F2F2"))
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    // City, ST
                    Text(cityAndState)
                        .font(.headline)
                        .foregroundColor(Color(hex: "#2C2C2C"))
                    
                    // Temperature below
                    HStack {

                    Text(temperature)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(Color(hex: "#2C2C2C"))
                        .padding(.trailing, -5)
                    Text("°")
                        .font(.system(size: 15))
                        .baselineOffset(15)
                    }
                }
                
                Spacer()
                
                // Weather icon on the right
                if let iconURL = iconURL {
                    AsyncImage(url: iconURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            .padding()
        }
        .frame(height: 100)        // Adjust as needed
        .padding(.horizontal, 16)
    }
}
