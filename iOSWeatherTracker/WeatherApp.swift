//
//  iOSWeatherTrackerApp.swift
//  Shared
//
//  Created by Amein Almoughrabi on 1/26/25.
//

import SwiftUI

@main
struct WeatherApp: App {
    @StateObject private var homeVM = HomeViewModel(weatherService: WeatherServiceImpl())
    
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: homeVM)
        }
    }
}
