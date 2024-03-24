//
//  CurrentWeather.swift
//  VKWeather
//
//  Created by Danil Komarov on 19.03.2024.
//

import Foundation

// MARK: - CurrentWeather

struct CurrentWeather: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

// MARK: - Clouds

struct Clouds: Codable {
    let all: Int?
}

// MARK: - Coord

struct Coord: Codable {
    let lon, lat: Double?
}

// MARK: - Main

struct Main: Codable {
    let temp, feels_like, temp_min, temp_max: Double?
    let pressure, humidity: Int?
}

// MARK: - Weather

struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?
}

// MARK: - Wind

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}
