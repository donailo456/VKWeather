//
//  CurrentWeatherData+CoreDataProperties.swift
//  VKWeather
//
//  Created by Danil Komarov on 20.03.2024.
//
//

import Foundation
import CoreData
import UIKit

@objc(CurrentWeatherData)
public final class CurrentWeatherData: NSManagedObject {

}


extension CurrentWeatherData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeatherData> {
        return NSFetchRequest<CurrentWeatherData>(entityName: "CurrentWeatherData")
    }
    
    @NSManaged public var temp: String?
    @NSManaged public var parameters: String?
    @NSManaged public var humidity: String?
    @NSManaged public var tempMin: String?
    @NSManaged public var tempMax: String?
    @NSManaged public var pressure: String?
    @NSManaged public var windSpeed: String?
    @NSManaged public var windDeg: String?
    @NSManaged public var clouds: String?
    @NSManaged public var icon: Data?

}

extension CurrentWeatherData : Identifiable {

}
