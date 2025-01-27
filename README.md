# iOS Weather Tracker
Weather app that demonstrates skills in Swift, SwiftUI, and clean architecture. The app should allow users to search for a city, display its weather on the home screen, and persist the selected city across launches.

## Project Overview
The iOS Weather Tracker is a SwiftUI-based weather application that allows users to:
- Search for weather conditions by city name or zip code.
- View detailed weather information for a selected city, including temperature, humidity, UV index, and "feels like" temperature.
- Save their selected city to ensure weather data is persisted across app launches.
- Handle scenarios like no network connection, invalid cities, and other potential errors gracefully.

This project showcases clean architecture using MVVM, protocol-oriented programming, dependency injection, and best practices in SwiftUI development.

---

## Thought Process
The project was developed incrementally, focusing on solving each challenge systematically. Key considerations included:

1. **Clean Architecture**: Using the MVVM pattern to ensure clear separation of concerns, making the app scalable and testable.
2. **Dynamic UI**: Ensuring the app UI adapts seamlessly to different states, such as displaying an empty state when no city is selected or showing search results dynamically.
3. **API Integration**: Leveraging the WeatherAPI to fetch accurate weather data and handle multiple location matches.
4. **Error Handling**: Gracefully managing no network connection, invalid inputs, and empty search results.
5. **Persistence**: Saving the selected city's query (e.g., lat,lon) to UserDefaults for automatic restoration on app relaunch.
6. **Testing and Iteration**: Iteratively testing every feature, analyzing edge cases, and improving both functionality and UX.

---

## Features

### Home Screen
- Displays weather details for the saved city, including:
  - City name
  - Temperature (formatted to show degrees as a smaller offset).
  - Weather condition icon sourced dynamically from WeatherAPI (upgraded to 128x128 resolution).
  - Humidity, UV index, and "feels like" temperature.
- Handles the empty state when no city is selected, prompting the user to search for a city.

### Search Screen
- Displays a search bar for querying cities or zip codes.
- Dynamically fetches and shows results below the search bar.
- Allows users to select a city from the results, updating the home screen and persisting the selection.
- Shows appropriate messages for empty results or no network connection.

### Persistence
- The selected city (lat,lon query) is saved in UserDefaults.
- On app launch, the app automatically restores the last selected city's weather and fetches fresh data to avoid stale information.

### Error Handling
- No network connection: Displays a user-friendly error message.
- Invalid city or empty search results: Informs the user with clear feedback.

---

## Problem-Solving and Approach

### Dynamic Weather Icon Resolution
Initially, the WeatherAPI provided 64x64 resolution icons, which appeared blurry in the app. The solution involved:
- Modifying the API response URLs dynamically to use 128x128 resolution icons.
- Implementing this adjustment within the `updateWeather(for:)` function to ensure all icons are sharp and consistent.

### Handling Multiple Matching Cities
Searches often returned multiple cities with the same name. To resolve this:
- The app used precise `lat,lon` coordinates to differentiate cities.
- A dynamic button interaction allowed users to select the correct city.

### No Network Error Handling
To improve user experience in offline scenarios:
- Added error handling for `URLError.notConnectedToInternet`.
- Displayed an appropriate error message on both the home and search screens.

### Search Results Feedback
To address cases where no results were found:
- Displayed a "No results found" message.
- Ensured smooth transitions between loading, error, and result states.

### Persisting City Data
To restore the last selected city on app launch:
- Saved the exact `lat,lon` query to UserDefaults.
- Ensured fresh weather data was fetched every time the app launched.
- Used timestamps to optimize API calls, refreshing data only if the last update was more than one hour old.

---

## File Descriptions

### `WeatherService.swift`
- **Purpose**: Handles API integration with WeatherAPI.
- **Key Functions**:
  - `fetchCurrentWeather(for:)`: Fetches current weather data for a given city or query.
  - `searchLocations(for:)`: Searches for locations matching a query.
- **Error Handling**:
  - Custom `WeatherError` enum for invalid URLs, responses, and decoding errors.

### `ColorExtensions.swift`
- **Purpose**: Provides a utility for initializing `Color` objects from hexadecimal strings.
- **Key Features**:
  - Ensures input hex strings are sanitized and parsed correctly.
  - Throws precondition errors for invalid hex formats.

### `WeatherData.swift`
- **Purpose**: Defines data models for the WeatherAPI responses.
- **Key Models**:
  - `WeatherResponse`: Top-level response containing location and current weather details.
  - `Location`: Contains city, region, and country information.
  - `Current`: Includes temperature, condition, humidity, UV index, and "feels like" temperature.

### `SearchLocation.swift`
- **Purpose**: Represents search results from WeatherAPI's `/v1/search.json` endpoint.
- **Key Features**:
  - Implements `Identifiable` to work seamlessly with SwiftUI's `ForEach`.
  - Dynamically generates IDs if not provided by the API.

### `SearchResultWithWeather.swift`
- **Purpose**: Combines location and weather data for search results.
- **Key Properties**:
  - Includes city name, region, temperature, and weather icon URL.
  - Dynamically adjusted weather icons to 128x128 resolution.

### `HomeView.swift`
- **Purpose**: The main screen of the app.
- **Key Features**:
  - Displays weather details or prompts users to search for a city.
  - Dynamically adapts to different states (empty, loading, error).
  - Integrates a search button for navigating to the search screen.

### `SearchView.swift`
- **Purpose**: Allows users to search for cities and select one.
- **Key Features**:
  - Handles live search queries and displays results dynamically.
  - Manages errors and displays "No results found" when applicable.

### `SearchResultCard.swift`
- **Purpose**: A reusable component for displaying individual search results.
- **Key Features**:
  - Displays city name, temperature, and weather icon.
  - Styled with a rounded rectangle and clean layout.

### `HomeViewModel.swift`
- **Purpose**: Manages the data and logic for the `HomeView`.
- **Key Features**:
  - Fetches weather data and updates the UI dynamically.
  - Saves and restores the last selected city using UserDefaults.
  - Handles no network and API-related errors gracefully.

### `SearchViewModel.swift`
- **Purpose**: Manages the data and logic for the `SearchView`.
- **Key Features**:
  - Performs live searches and fetches weather data for results.
  - Handles errors for no network or invalid inputs.
  - Updates the search results dynamically for display.

### `iOSWeatherTrackerApp.swift`
- **Purpose**: The entry point of the application.
- **Key Features**:
  - Initializes the `HomeViewModel`.
  - Sets `HomeView` as the root view of the app.

---

## Development Progress
1. **Initial Setup**:
   - Established the MVVM architecture and integrated WeatherAPI.
2. **Dynamic Search**:
   - Implemented live search functionality.
   - Resolved issues with multiple cities sharing the same name.
3. **Weather Icon Enhancement**:
   - Upgraded icons from 64x64 to 128x128 resolution for clarity.
4. **Error Handling**:
   - Added graceful handling for no network and invalid inputs.
5. **Persistence**:
   - Implemented UserDefaults to save and restore the last selected city.
6. **UI Tweaks**:
   - Matched the design to Figma specifications.
   - Improved spacing, font sizes, and color consistency.

---

## Testing
- **Functional Testing**:
  - Verified that the app handles all key features, including weather updates, search functionality, and error scenarios.
- **Edge Cases**:
  - Tested with invalid cities, no network connection, and duplicate city names.
- **Visual Testing**:
  - Ensured the UI matches the Figma design, including proper alignment, fonts, and colors.

---

## Conclusion
This project demonstrates a complete weather tracking app built with modern SwiftUI principles. By addressing edge cases, optimizing UI and API integration, and maintaining clean architecture, this app provides a robust foundation for further enhancements.
