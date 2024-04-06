//
//  WeatherViewModel.swift
//  weather
//
//  Created by Ahmed Fathy Fixed on 07/04/2024.
//

import RealmSwift

class WeatherViewModel: Object {
    @Persisted var name: String
    @Persisted var desc: String
    @Persisted var temperature: String
    @Persisted var humidity: String
    @Persisted var windspeed: String
    @Persisted var icon: String
    @Persisted var date: Date

    override init() { }

    init(_ weather: WeatherResponse, date: Date) {
        self.name = weather.name
        self.desc = weather.weather[0].description.capitalized
        self.temperature = "\(String(format: "%.2f", (weather.main.temp - 273)))deg. C"
        self.humidity = "\(weather.main.humidity)%"
        self.windspeed = "\(weather.wind.speed) km/h"
        self.icon = weather.weather[0].icon
        self.date = date
    }
}
