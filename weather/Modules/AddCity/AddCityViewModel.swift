//
//  AddCityViewModel.swift
//  weather
//
//  Created by Ahmed Fathy Fixed on 06/04/2024.
//

import Foundation

protocol AddCityViewModel {
    func fetchWeather(city: String?) async throws -> WeatherResponse
}

class DefaultAddCityViewModel: AddCityViewModel {
    func fetchWeather(city: String?) async throws -> WeatherResponse {
        let service = OpenWeatherService(apiKey: "4c6eb36cdcfd3de4bddb06d5b9b4b760")
        guard let city else {
            throw NSError(
                domain: "CITY_NULL",
                code: 0
            )
        }
        let weather = try await service.fetchWeatherData(for: city)
        dump(weather)
        return weather
    }
}
