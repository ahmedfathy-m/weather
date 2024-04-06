//
//  OpenWeatherError.swift
//  weather
//
//  Created by Ahmed Fathy Fixed on 06/04/2024.
//

import Foundation

struct Error: Decodable {
    let cod: Int
    let message: String
}
