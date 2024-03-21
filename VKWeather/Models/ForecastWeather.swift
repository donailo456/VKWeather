//
//  ForecastWeather.swift
//  VKWeather
//
//  Created by Danil Komarov on 19.03.2024.
//

import Foundation

// MARK: - ForecastWeather
struct ForecastWeather: Codable {
    let cityName, countryCode: String?
    let data: [Datum]?
    let lat, lon: Double?
    let stateCode, timezone: String?
}

// MARK: - Datum
struct Datum: Codable {
    let clouds: Int?
    let datetime: String?
    let max_temp, min_temp: Double?
    let pop: Int?
    let pres: Double?
    let rh: Int?
    let snow: Int?
    let temp: Double?
    let wind_dir: Int?
    let wind_spd: Double?
}

