//
//  MainCellViewModel.swift
//  VKWeather
//
//  Created by Danil Komarov on 19.03.2024.
//

import Foundation
import UIKit

struct DetailCellViewModel: CellProtocol, Hashable  {
    
    private enum CodingKeys : String, CodingKey {
        case temp
        case parameters
        case humidity
        case tempMin
        case tempMax
        case pressure
        case windSpeed
        case windDeg
        case clouds
        case icon
    }
    
    let temp: String?
    let parameters: String?
    let humidity: String?
    let tempMin: String?
    let tempMax: String?
    let pressure: String?
    let windSpeed: String?
    let windDeg: String?
    let clouds: String?
    let id = UUID()
    var icon: UIImage?
    
}
