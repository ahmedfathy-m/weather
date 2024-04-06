//
//  AddCityViewModel.swift
//  weather
//
//  Created by Ahmed Fathy Fixed on 06/04/2024.
//

import Foundation
import RealmSwift

protocol AddCityViewModel {
    func fetchWeather(city: String?) async throws -> WeatherViewModel
}

class DefaultAddCityViewModel: AddCityViewModel {
    func fetchWeather(city: String?) async throws -> WeatherViewModel {
        let service = OpenWeatherService(apiKey: "4c6eb36cdcfd3de4bddb06d5b9b4b760")
        guard let city else {
            throw NSError(
                domain: "CITY_NULL",
                code: 0
            )
        }
        let weather = try await service.fetchWeatherData(for: city)
        dump(weather)
        DispatchQueue.main.async {
            let realm = try! Realm()
            // Persist your data easily with a write transaction
            try! realm.write {
                let newObject = WeatherViewModel()
                newObject.name = weather.name
                newObject.desc = weather.weather[0].description.capitalized
                newObject.temperature = "\(String(format: "%.2f", (weather.main.temp - 273)))deg. C"
                newObject.humidity = "\(weather.main.humidity)%"
                newObject.windspeed = "\(weather.wind.speed) km/h"
                newObject.icon = weather.weather[0].icon
                newObject.date = Date()
                realm.add(newObject)
            }

            let objects = realm.objects(WeatherViewModel.self)
            print(objects)
        }
        return WeatherViewModel(weather, date: Date())
    }
}
