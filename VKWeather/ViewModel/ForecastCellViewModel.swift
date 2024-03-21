//
//  ForecastCellViewModel.swift
//  VKWeather
//
//  Created by Danil Komarov on 20.03.2024.
//

import Foundation
import UIKit

struct ForecastCellViewModel: Hashable, CellProtocol {
    
    private enum CodingKeys : String, CodingKey {
        case title, price, symbol
    }
    
    let temp: String?
    let tempMax: String?
    let tempMin: String?
    let date: String?
    let pres: String?
    let rh: String?
    let windDir: String?
    let windSpd: String?
    
    let id = UUID()
    
}
