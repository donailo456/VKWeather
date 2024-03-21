//
//  ForecastWeatherData+CoreDataProperties.swift
//  VKWeather
//
//  Created by Danil Komarov on 21.03.2024.
//
//

import Foundation
import CoreData

@objc(ForecastWeatherData)
public final class ForecastWeatherData: NSManagedObject {

}


extension ForecastWeatherData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastWeatherData> {
        return NSFetchRequest<ForecastWeatherData>(entityName: "ForecastWeatherData")
    }

    @NSManaged public var temp: String?
    @NSManaged public var pres: String?
    @NSManaged public var tempMin: String?
    @NSManaged public var tempMax: String?
    @NSManaged public var rh: String?
    @NSManaged public var windDir: String?
    @NSManaged public var windSpd: String?
    @NSManaged public var date: String?

}

extension ForecastWeatherData : Identifiable {

}
