//
//  NetworkManager.swift
//  VKWeather
//
//  Created by Danil Komarov on 19.03.2024.
//

import Foundation

final class NetworkService {
    
    let decoder = JSONDecoder()
    
    private enum Constants {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let appid = "0bbe7668f08533a098e6e750b6ab5abf"
        static let pathCurrentWeather = "/data/2.5/weather"
        
        static let forecastKey = "e2b510c276c14345bee6cf0d8f0ea975"
        static let forecastHost = "api.weatherbit.io"
        static let pathForecast = "/v2.0/forecast/daily"
    }
    
    private func getURL(_ path: String, lat: String?, lon: String?) -> URL {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = path
        let queryItemLat = URLQueryItem(name: "lat", value: lat)
        let queryItemLon = URLQueryItem(name: "lon", value: lon)
        let queryItemUnits = URLQueryItem(name: "units", value: "metric")
        let queryItemLang = URLQueryItem(name: "lang", value: "ru")
        let queryItemToken = URLQueryItem(name: "appid", value: Constants.appid)
        components.queryItems = [queryItemLat, queryItemLon, queryItemToken, queryItemUnits, queryItemLang]
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
    
    private func getForecastURL(_ path: String, lat: String?, lon: String?) -> URL {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.forecastHost
        components.path = path
        let queryItemLat = URLQueryItem(name: "lat", value: lat)
        let queryItemLon = URLQueryItem(name: "lon", value: lon)
        let queryItemToken = URLQueryItem(name: "key", value: Constants.forecastKey)
        components.queryItems = [queryItemLat, queryItemLon, queryItemToken]
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
    
    func getCurrentWeather(lat: String?, lon: String?, complition: @escaping (Result<CurrentWeather?, NetworkError>) -> Void) {
        let request = URLRequest(url: getURL(Constants.pathCurrentWeather, lat: lat, lon: lon), cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: Double.infinity)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            if error != nil {
                complition(.failure(.urlError))
            }
            else if let data = data {
                do {
                    let result = try self?.decoder.decode(CurrentWeather.self, from: data)
                    complition(.success(result))
                } catch {
                    complition(.failure(.canNotParseData))
                }
            }
            
        } .resume()
    }
    
    func getForecastWeather(lat: String?, lon: String?, complition: @escaping (Result<[Datum], NetworkError>) -> Void) {
        
        let request = URLRequest(url: getForecastURL(Constants.pathForecast, lat: lat, lon: lon), cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: Double.infinity)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            if error != nil {
                complition(.failure(.urlError))
            }
            else if let data = data {
                do {
                    let result = try self?.decoder.decode(ForecastWeather.self, from: data)
                    complition(.success(result?.data ?? []))
                } catch {
                    complition(.failure(.canNotParseData))
                }
            }
            
        } .resume()
    }
    
}
