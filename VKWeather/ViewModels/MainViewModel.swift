//
//  MainViewModel.swift
//  VKWeather
//
//  Created by Danil Komarov on 19.03.2024.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

protocol MainViewModelProtocol {
    func getCurrentWeather(_ lat: String?, _ lon: String?)
    func getForecastWeather(_ lat: String?, _ lon: String?)
}

final class MainViewModel: NSObject, MainViewModelProtocol {
    weak var coordinator: AppCoordinator!
    var onDataReloadCurr: ((CurrentWeatherData?) -> Void)?
    var onDataReloadForecast: (([ForecastWeatherData]?) -> Void)?
    var onCity: ((String?) -> Void)?
    var onIsLoading: ((Bool)-> Void)?
    
    private var networkService = NetworkService()
    private var dataSource: CurrentWeather?
    private var forecastDataSource: [Datum]?
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private let geoCoder = CLGeocoder()
    private var coreDataManager: CoreDataManager?
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func getCurrentWeather(_ lat: String?, _ lon: String?) {
        onIsLoading?(true)
        coreDataManager?.deleteObjects(CurrentWeatherData.self)
        networkService.getCurrentWeather(lat: lat, lon: lon) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self.onIsLoading?(false)
                    self.dataSource = weather
                    self.mapDetailCellData()
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
    func getForecastWeather(_ lat: String?, _ lon: String?) {
        coreDataManager?.deleteObjects(ForecastWeatherData.self)
        networkService.getForecastWeather(lat: lat, lon: lon) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self.forecastDataSource = weather
                    self.mapForecastCellData()
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
    private func mapDetailCellData() {
        dataSource.map({ data in
            guard let main = data.main, let weather = data.weather?.first else {
                return
            }
            
            coreDataManager?.addCurrWeather(
                temp: String(Int(main.temp ?? 0.0)),
                parameters: String(weather.description ?? " ").prefix(1).uppercased() + String(weather.description ?? " ").dropFirst(),
                humidity: String(Int(main.humidity ?? 0)),
                tempMin: String(Int(main.temp_min ?? 0)),
                tempMax: String(Int(main.temp_max ?? 0)),
                pressure: String(main.pressure ?? 0),
                windSpeed: String(data.wind?.speed ?? 0.0),
                windDeg: getArrowDirection(degrees: String(data.wind?.deg ?? 0)),
                clouds: String(data.clouds?.all ?? 0),
                today: today()
            )
        })
        
        self.onDataReloadCurr?(coreDataManager?.fetchData().first)
    }
    
    private func mapForecastCellData() {
        forecastDataSource?.map({
            coreDataManager?.addForecastWeather(
                temp: String($0.temp ?? 0.0),
                pres: String($0.pres ?? 0.0),
                rh: String($0.rh ?? 0),
                tempMin: String($0.min_temp ?? 0.0),
                tempMax: String($0.max_temp ?? 0.0),
                date: dateConvert($0.datetime),
                week: weekConvector($0.datetime),
                windSpd: String($0.wind_spd ?? 0.0),
                windDir: getArrowDirection(degrees: String($0.wind_dir ?? 0))
            )})
    }
    
    //MARK: Convector
    
    private func weekConvector(_ dateString: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString ?? "0000-00-00") {
            var calendar = Calendar.current
            calendar.locale = Locale(identifier: "ru_RU")
            let weekday = calendar.component(.weekday, from: date)
            let weekdayName = calendar.weekdaySymbols[weekday - 1]
            
            return weekdayName.prefix(1).uppercased() + weekdayName.dropFirst()
        } else {
            return " "
        }
    }
    
    private func today() -> String {
        let getDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: getDate)
    }
    
    private func dateConvert(_ dateString: String?) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd"
        let date = inputDateFormatter.date(from: dateString ?? " ")
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "dd.MM"
        return outputDateFormatter.string(from: date!)
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
            return "↑ Северный"
        case 22.5...67.5:
            return "↗ Северо-восточный"
        case 67.5...112.5:
            return "→ Восточный"
        case 112.5...157.5:
            return "↘ Южно-восточный"
        case 157.5...202.5:
            return "↓ Южный"
        case 202.5...247.5:
            return "↙ Юго-западный"
        case 247.5...292.5:
            return "← Западный"
        case 292.5...337.5:
            return "↖ Северо-востоный"
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
    
    func transmissionCurrData() {
        self.onDataReloadCurr?(coreDataManager?.fetchData().first)
    }
    
    func transmissionForecastData() {
        self.onDataReloadForecast?(coreDataManager?.fetchData())
    }
}

extension MainViewModel: CLLocationManagerDelegate {
    
    private func requestWeatherForLocation(_ location: CLLocation) {
        let lon = location.coordinate.longitude
        let lat = location.coordinate.latitude
        
        geoCoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let placemark = placemarks?.first else {
                return
            }
            
            if let city = placemark.locality {
                self?.onCity?(city)
            }
        }
        
        getCurrentWeather(String(lat), String(lon))
        getForecastWeather(String(lat), String(lon))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            self.currentLocation = currentLocation
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation(currentLocation)
        }
    }

    func seacrhCoordinat(_ text: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        let search = MKLocalSearch(request: searchRequest)
        
        DispatchQueue.global().async {
            search.start { [weak self] response, error in
                guard let response = response else {
                    debugPrint("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                for item in response.mapItems {
                    let coordinate = item.placemark.coordinate
                    let lat = coordinate.latitude
                    let long = coordinate.longitude
                    self?.requestWeatherForLocation(CLLocation(latitude: lat, longitude: long))
                }
            }
        }
    }

}

