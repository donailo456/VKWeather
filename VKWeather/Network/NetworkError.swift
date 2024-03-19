//
//  NetworkError.swift
//  VKWeather
//
//  Created by Danil Komarov on 19.03.2024.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case canNotParseData
}
