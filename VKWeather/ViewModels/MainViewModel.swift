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
    
    private var networkService = NetworkService()
    private var dataSource: CurrentWeather?
    private var forecastDataSource: [Datum]?
    private var cellDataSource: DetailCellViewModel?
    private var cellForecastDataSource: [ForecastCellViewModel]?
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private let geoCoder = CLGeocoder()
    private var city = "Moscow"
    
    
    func getCurrentWeather(_ lat: String?, _ lon: String?) {
        networkService.getCurrentWeather(lat: lat, lon: lon) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    debugPrint(weather)
                    self.dataSource = weather
                    self.mapCellData()
                    self.mapCellDataNew()
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
    
    func mapCellData() {
        
        self.cellDataSource = dataSource.map({ DetailCellViewModel(temp: String($0.main.temp),
                                                                parameters: String($0.weather[0].description),
                                                                 humidity: String($0.main.humidity),
                                                                 tempMin: String($0.main.tempMin),
                                                                 tempMax: String($0.main.tempMax),
                                                                 pressure: String($0.main.pressure),
                                                                 windSpeed: String($0.wind.speed),
                                                                 windDeg: String($0.wind.deg),
                                                                 clouds: String($0.clouds.all)
        ) })
        
        downloadImage(icon: dataSource?.weather[0].icon ?? " ")
    }
    
    func mapCellDataNew() {
        self.cellForecastDataSource = forecastDataSource?.compactMap( { ForecastCellViewModel(temp: String($0.temp ?? 0.0))})
        onDataReloadForecast?(cellForecastDataSource)
    }
    
    //MARK: - Location
    
    func setupLocation() {
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
        
        print("\(lon), \(lat)")
    }
}

