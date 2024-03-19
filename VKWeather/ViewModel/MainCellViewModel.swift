//
//  MainCellViewModel.swift
//  VKWeather
//
//  Created by Danil Komarov on 19.03.2024.
//

import Foundation
import UIKit

struct MainCellViewModel: Hashable {
    
    private enum CodingKeys : String, CodingKey {
        case title, price, symbol
    }
    
    var temp: String?
    var humidity: String?
    var tempMin: String?
    var tempMax: String?
    var pressure: String?
    var windSpeed: String?
    var windDeg: String?
    var clouds: String?
    var icon: UIImage?
    
    let id = UUID()
}
