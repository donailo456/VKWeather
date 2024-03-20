//
//  MainViewModel.swift
//  VKWeather
//
//  Created by Danil Komarov on 19.03.2024.
//

import Foundation
import UIKit
import CoreLocation

protocol MainViewModelProtocol {
    func getCurrentWeather(_ lat: String?, _ lon: String?)
}

final class MainViewModel: NSObject, MainViewModelProtocol {
    weak var coordinator: AppCoordinator!
    var onDataReloadCurr: ((DetailCellViewModel?) -> Void)?
    var onDataReloadForecast: (([ForecastCellViewModel]?) -> Void)?
    var onCity: ((String?) -> Void)?
    var onIsLoading: ((Bool)-> Void)?
    
    private var networkService = NetworkService()
    private var dataSource: CurrentWeather?
    private var forecastDataSource: [Datum]?
    private var cellDataSource: DetailCellViewModel?
    private var cellForecastDataSource: [ForecastCellViewModel]?
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private let geoCoder = CLGeocoder()
    
    
    func getCurrentWeather(_ lat: String?, _ lon: String?) {
        onIsLoading?(true)
        networkService.getCurrentWeather(lat: lat, lon: lon) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    debugPrint(weather)
                    self.onIsLoading?(false)
                    self.dataSource = weather
                    self.mapDetailCellData()
                    self.mapForecastCellData()
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
    func getForecastWeather(_ lat: String?, _ lon: String?) {
        networkService.getForecastWeather(lat: lat, lon: lon) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    debugPrint(weather)
                    self.forecastDataSource = weather
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
    private func downloadData(urlString: String?, completion: @escaping (UIImage?) ->Void) {
        let url = URL(string: urlString ?? "0")
        networkService.getData(url: url ?? URL(filePath: " ")) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                debugPrint(data)
                completion(UIImage(data: data))
            }
        }
        
        
    }
    
    private func downloadImage(icon: String) {
        let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        print(urlString)
        downloadData(urlString: urlString) { image in
            self.cellDataSource?.icon = image
            self.onDataReloadCurr?(self.cellDataSource)
        }
    }
    
    func mapDetailCellData() {
        
        self.cellDataSource = dataSource.map({ DetailCellViewModel(temp: String(Int($0.main?.temp ?? 0.0)),
                                                                   parameters: String($0.weather[0].description ?? " "),
                                                                   humidity: String(Int($0.main?.humidity ?? 0)),
                                                                   tempMin: String(Int($0.main?.temp_min ?? 0)),
                                                                   tempMax: String(Int($0.main?.temp_max ?? 0) ),
                                                                   pressure: String($0.main?.pressure ?? 0),
                                                                   windSpeed: String($0.wind?.speed ?? 0.0),
                                                                   windDeg: getArrowDirection(degrees: String($0.wind?.deg ?? 0)),
                                                                   clouds: String($0.clouds?.all ?? 0)
        ) })
        
        downloadImage(icon: dataSource?.weather[0].icon ?? " ")
    }
    
    func mapForecastCellData() {
        self.cellForecastDataSource = forecastDataSource?.compactMap( { ForecastCellViewModel(temp: String($0.temp ?? 0.0),
                                                                                              tempMax: String($0.max_temp ?? 0.0),
                                                                                              tempMin: String($0.min_temp ?? 0.0),
                                                                                              date: dateConvert($0.datetime),
                                                                                              pres: String($0.pres ?? 0.0),
                                                                                              rh: String($0.rh ?? 0),
                                                                                              windDir: getArrowDirection(degrees: String($0.wind_dir ?? 0)),
                                                                                              windSpd: String($0.wind_spd ?? 0.0))})
        onDataReloadForecast?(cellForecastDataSource)
    }
    
    //MARK: Convector
    
    private func dateConvert(_ dateString: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ru")
        
        if let date = dateFormatter.date(from: dateString ?? "0000-00-00") {
            let calendar = Calendar.current
            let weekday = calendar.component(.weekday, from: date)
            let weekdayName = calendar.weekdaySymbols[weekday - 1]
            
            return weekdayName
        } else {
            return " "
        }
        
    }
    
    private func getArrowDirection(degrees: String) -> String {
        guard let angle = Double(degrees) else {
            return ("Неверный формат угла")
        }
        
        var normalizedAngle = angle.truncatingRemainder(dividingBy: 360)
        if normalizedAngle < 0 {
            normalizedAngle += 360
        }
        
        switch normalizedAngle {
        case 0...22.5, 337.5...360:
            return "↑ С"
        case 22.5...67.5:
            return "↗ СВ"
        case 67.5...112.5:
            return "→ В"
        case 112.5...157.5:
            return "↘ ЮВ"
        case 157.5...202.5:
            return "↓ Ю"
        case 202.5...247.5:
            return "↙ ЮЗ"
        case 247.5...292.5:
            return "← З"
        case 292.5...337.5:
            return "↖ СВ"
        default:
            return "Ошибка"
        }
    }
    
    //MARK: - Location
    
    func setupLocation() {
        onIsLoading?(true)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension MainViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherLocation()
        }
    }
    
    func requestWeatherLocation() {
        guard let currentLocation = currentLocation else { return }
        
        let lon = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        
        geoCoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
            guard let placemark = placemarks?.first else {
                return
            }
            
            if let city = placemark.locality {
                self.onCity?(city)
            }
        }
        
        
        getCurrentWeather(String(lat), String(lon))
        getForecastWeather(String(lat), String(lon))
    }
}

