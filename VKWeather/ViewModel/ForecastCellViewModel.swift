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
    
    var temp: String?
    var tempMax: String?
    var tempMin: String?
    var date: String?
    
    var id = UUID()
    
}
