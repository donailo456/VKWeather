//
//  MainViewModel.swift
//  VKWeather
//
//  Created by Danil Komarov on 19.03.2024.
//

import Foundation

protocol MainViewModelProtocol {
    func getCurrentWeather()
}

final class MainViewModel: MainViewModelProtocol {
    weak var coordinator: AppCoordinator!
    
    private var networkService = NetworkService()
    
    func getCurrentWeather() {
        networkService.getCurrentWeather(lat: "44.34", lon: "10.99") { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    debugPrint(weather)
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
    
}
