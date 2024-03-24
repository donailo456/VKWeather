//
//  DefaultCollectionCellViewModel.swift
//  VKWeather
//
//  Created by Danil Komarov on 23.03.2024.
//

import Foundation
import UIKit

struct DefaultCollectionCellViewModel: Hashable, CellProtocol {
    let title: String?
    let subtitle: String?
    let addInfo: String?
    let subtitleSecond: String?
    let icon: UIImage?
}
