//
//  WeatherManager.swift
//  Clima
//
//  Created by Guneet on 2022-01-01.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let currentWeatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=f81e102e6dce580cd3bfd9d9a736c6ac&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let fullURL = "\(currentWeatherURL)&q=\(cityName)"
        performRequest(with: fullURL)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let fullURL = "\(currentWeatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: fullURL)
    }
    func performRequest(with urlString: String) {
        //will carry out the steps of networking now
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    //will convert data into an object
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        //let weatherVC = WeatherViewController()
                        //weatherVC.didUpdateWeather(weather)
                    }
                }
            }
            task.resume()
        }
        
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        //.self below converts the weatehrdata to a type
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let city = decodedData.name
            
            let weather = WeatherModel(conditionId: id, city: city, temp: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}
