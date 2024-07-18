//
//  ServiceApi.swift
//  Weather app
//
//  Created by Rubens Moura Augusto on 07/07/24.
//

import Foundation

struct City {
    let lat: String
    let lon: String
    let name: String
}


class ServiceApi {
    private let baseURL: String = "https://api.openweathermap.org/data/2.5/"
    private let apiKey: String = ENV.FORECAST_API_KEY
    private let session = URLSession.shared
    private let unit = "metric"
    private let language = "pt_br"
    private let weatherPath = "weather"
    private let weekForecastpatch = "forecast"
    
    
    func fetchDataforecastNow(city: City, _ completion: @escaping (ForecastNowResponse?) -> Void) {
        let urlString = "\(baseURL)\(weatherPath)?lat=\(city.lat)&lon=\(city.lon)&lang=\(language)&units=\(unit)&appid=\(apiKey)"
        guard let url =  URL(string: urlString) else { return }
        
        let task = session.dataTask(with: url) { data, response, error  in
            guard let data else {
                completion(nil)
                return
            }
            do {
                let forecastNowResponse = try JSONDecoder().decode(ForecastNowResponse.self, from: data)
                completion(forecastNowResponse)
            } catch {
                print(error)
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchDataWeekForecast(city: City, _ completion: @escaping (WeekForecastResponse?) -> Void) {
        let urlString = "\(baseURL)\(weekForecastpatch)?lat=\(city.lat)&lon=\(city.lon)&lang=\(language)&units=\(unit)&appid=\(apiKey)"
        guard let url =  URL(string: urlString) else { return }
        
        let task = session.dataTask(with: url) { data, response, error  in
            guard let data else {
                completion(nil)
                return
            }
            do {
                let forecastNowResponse = try JSONDecoder().decode(WeekForecastResponse.self, from: data)
                completion(forecastNowResponse)
            } catch {
                print(error)
                completion(nil)
            }
        }
        task.resume()
    }
}


class BaseEnv {
    
    let dict: NSDictionary
    
    enum Key: String {
        case FORECAST_API_KEY
    }
    
    init(resourceName: String) {
        guard let filePath = Bundle.main.path(forResource: resourceName, ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Couldn't find file '\(resourceName)' plist")
        }
        self.dict = plist
    }
}

protocol ApiKeyable {
    var FORECAST_API_KEY: String { get }
}

class APIKey: BaseEnv, ApiKeyable {
   
    init() {
        super.init(resourceName: "APIKeys")
    }
    
    var FORECAST_API_KEY: String {
        dict.object(forKey: Key.FORECAST_API_KEY.rawValue) as? String ?? ""
    }
    
}
