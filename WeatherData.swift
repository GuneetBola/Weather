//
//  WeatherData.swift
//  Clima
//
//  Created by Guneet on 2022-01-02.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable { //codable includes both encoder and decoder
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}


struct Weather: Codable {
    let id: Int
}
