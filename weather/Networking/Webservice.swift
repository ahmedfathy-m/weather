//
//  Webservice.swift
//  weather
//
//  Created by Ahmed Fathy Fixed on 06/04/2024.
//

import Foundation
import Alamofire

class OpenWeatherService {
    let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func fetchWeatherData(for city: String) async throws -> WeatherResponse {
        try await AF.request(
            "https://api.openweathermap.org/data/2.5/weather",
            method: .get,
            parameters: [
                "q": city,
                "appid": self.apiKey
            ],
            encoder: URLEncodedFormParameterEncoder(
                destination: .queryString
            )
        ).serializingDecodable(WeatherResponse.self).value
    }
}


