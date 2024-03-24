//
//  AppCoordinator.swift
//  VKWeather
//
//  Created by Danil Komarov on 19.03.2024.
//

import UIKit

final class AppCoordinator: CoordinatorProtocol {
    var parentCoordinator: CoordinatorProtocol?
    var children: [CoordinatorProtocol] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        debugPrint("App Coordinator start")
        showMainVC()
    }
    
    private func showMainVC() {
        let mainViewController = MainViewController()
        let mainViewModel = MainViewModel.init()
        mainViewModel.coordinator = self
        
        mainViewController.viewModel = mainViewModel
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
}
