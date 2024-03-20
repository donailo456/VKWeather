//
//  ForecastWeather.swift
//  VKWeather
//
//  Created by Danil Komarov on 19.03.2024.
//

import Foundation

//// MARK: - ForecastWeather
//struct ForecastWeather: Codable {
//    let lat, lon: String
//    let elevation: Int
//    let units: String
//    let daily: Daily
//}
//
//// MARK: - Daily
//struct Daily: Codable {
//    let data: [Datum]
//}
//
//// MARK: - Datum
//struct Datum: Codable {
//    let day, weather: String
//    let icon: Int
//    let summary: String
//    let predictability: Int
//    let temperature: Double
//    let temperature_min: Double
//    let temperature_max: Double
//    let feels_like: Double
//    let cloud_cover, pressure: Int
//    let ozone: Double
//    let humidity: Int
//    let visibility: Double
//}


// MARK: - ForecastWeather
//struct ForecastWeather: Codable {
//    let lat, lon: String?
//    let elevation: Int?
//    let units: String?
//    let daily: Daily?
//}
//
//// MARK: - Daily
//struct Daily: Codable {
//    let data: [Datum]?
//}
//
//// MARK: - Datum
//struct Datum: Codable {
//    let day, weather: String?
//    let icon: Int?
//    let summary: String?
//    let predictability: Int?
//    let temperature, temperature_min, temperature_max, feels_like: Double?
//    let feels_like_min, feels_like_max, wind_chill, wind_chill_min: Double?
//    let wind_chill_max, dew_point, dew_point_min, dew_point_max: Double?
//    let cloud_cover, pressure: Int?
//    let precipitation: Precipitation?
//    let probability: Probability?
//    let ozone: Double?
//    let humidity: Int?
//    let visibility: Double?
//}
//
//// MARK: - Precipitation
//struct Precipitation: Codable {
//    let total: Double?
//    let type: TypeEnum?
//}
//
//enum TypeEnum: String, Codable {
//    case none = "none"
//    case rain = "rain"
//}
//
//// MARK: - Probability
//struct Probability: Codable {
//    let precipitation, storm, freeze: Int?
//}

//// MARK: - ForecastWeather
//struct ForecastWeather: Codable {
//    let items: [Item]?
//    let forecastDate, nextUpdate: Date?
//    let source, point, fingerprint: String?
//}
//
//// MARK: - Item
//struct Item: Codable {
//    let date: String?
//    let dateWithTimezone: Date?
//    let freshSnow: Double?
//    let snowHeight: JSONNull?
//    let prec: Prec?
//    let sunHours: Int?
//    let rainHours: JSONNull?
//    let temperature: SnowLine?
//    let windchill, snowLine: SnowLine?
//    let astronomy: Astronomy?
//}
//
//// MARK: - Astronomy
//struct Astronomy: Codable {
//    let dawn, sunrise, suntransit, sunset: Date?
//    let dusk: Date?
//    let moonrise, moontransit: Date?
//    let moonset: Date?
//    let moonphase, moonzodiac: Int?
//}
//
//// MARK: - Prec
//struct Prec: Codable {
//    let sum: Double?
//    let probability: Int?
//    let sumAsRain: JSONNull?
//    let precClass: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case sum, probability, sumAsRain
//        case precClass = "class"
//    }
//}
//
//// MARK: - SnowLine
//struct SnowLine: Codable {
//    let avg: JSONNull?
//    let min, max: Int?
//    let unit: SnowLineUnit?
//}
//
//enum SnowLineUnit: String, Codable {
//    case m = "m"
//}
//
//
//
//// MARK: - Gusts
//struct Gusts: Codable {
//    let value: Int?
//    let text: JSONNull?
//}
//
//enum WindUnit: String, Codable {
//    case kmH = "km/h"
//}
//
//// MARK: - Encode/decode helpers
//
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let forecastWeather = try? JSONDecoder().decode(ForecastWeather.self, from: jsonData)

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

