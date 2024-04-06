//
//  Weather.swift
//  weather
//
//  Created by Ahmed Fathy Fixed on 06/04/2024.
//

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Decodable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
}

// MARK: - Main
struct Main: Decodable {
    let temp: Double
    let humidity: Int
}

// MARK: - Weather
struct Weather: Decodable {
    let id: Int
    let description, icon: String
}

// MARK: - Wind
struct Wind: Decodable {
    let speed: Double
}
