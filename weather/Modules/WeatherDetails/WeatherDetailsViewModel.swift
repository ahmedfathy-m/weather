//
//  WeatherDetailsViewModel.swift
//  weather
//
//  Created by Ahmed Fathy Fixed on 06/04/2024.
//

import Foundation
import RealmSwift

protocol WeatherDetailsViewModel {
    var weather: WeatherViewModel { get }
    var historyLabelTitle: String { get }
    func loadImage() async throws -> Data
}

class DefaultWeatherDetailsViewModel: WeatherDetailsViewModel {
    let date: Date

    let weather: WeatherViewModel

    init(
        weather: WeatherViewModel,
        date: Date
    ) {
        self.weather = weather
        self.date = date
    }

    @MainActor
    func loadImage() async throws -> Data {
        let service = OpenWeatherService(apiKey: "4c6eb36cdcfd3de4bddb06d5b9b4b760")
        return try await service.fetchWeatherImage(iconId: weather.icon)
    }

    var historyLabelTitle: String {
        "Weather information for \(weather.name) received on \(date.formatted(date: .numeric, time: .shortened))"
    }
}
