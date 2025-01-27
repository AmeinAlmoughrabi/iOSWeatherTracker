//
//  ColorExtensions.swift
//  iOSWeatherTracker (iOS)
//
//  Created by Amein Almoughrabi on 1/26/25.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        // Remove "#" if present
        var sanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if sanitized.hasPrefix("#") {
            sanitized.removeFirst()
        }

        // Ensure the hex string is exactly 6 characters
        precondition(sanitized.count == 6, "Hex color must be 6 characters long (e.g., FF5733).")

        // Parse the red, green, blue components
        var rgbValue: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&rgbValue)

        let red   = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8)  / 255.0
        let blue  = Double(rgbValue & 0x0000FF)         / 255.0

        self = Color(red: red, green: green, blue: blue)
    }
}

