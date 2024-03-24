//
//  CoreDataManager.swift
//  VKWeather
//
//  Created by Danil Komarov on 20.03.2024.
//

import UIKit
import CoreData

//MARK: - CRUD
final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataWeather")
        container.loadPersistentStores { description, error in
            if let error {
                debugPrint(error)
            } else {
                debugPrint("DB", description.url?.absoluteString as Any)
            }
        }
        
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func addCurrWeather(
        temp: String,
        parameters: String,
        humidity: String,
        tempMin: String,
        tempMax: String,
        pressure: String,
        windSpeed: String,
        windDeg: String,
        clouds: String,
        today: String?
    ){
        guard let weatherDescription = NSEntityDescription.entity(forEntityName: "CurrentWeatherData", in: context) else { return }
        
        let weather = CurrentWeatherData(entity: weatherDescription, insertInto: context)
        
        weather.temp = temp
        weather.tempMax = tempMax
        weather.tempMin = tempMin
        weather.parameters = parameters
        weather.humidity = humidity
        weather.pressure = pressure
        weather.windSpeed = windSpeed
        weather.windDeg = windDeg
        weather.clouds = clouds
        weather.today = today
        
        saveContext()
    }
    
    func addForecastWeather(
        temp: String,
        pres: String,
        rh: String,
        tempMin: String,
        tempMax: String,
        date: String,
        week: String,
        windSpd: String,
        windDir: String
    ){
        guard let weatherDescription = NSEntityDescription.entity(forEntityName: "ForecastWeatherData", in: context) else { return }
        
        let weather = ForecastWeatherData(entity: weatherDescription, insertInto: context)
        
        weather.temp = temp
        weather.tempMax = tempMax
        weather.tempMin = tempMin
        weather.rh = rh
        weather.pres = pres
        weather.windSpd = windSpd
        weather.windDir = windDir
        weather.date = date
        weather.week = week
        
        saveContext()
    }
    
    func fetchData<T: NSManagedObject>() -> [T] {
        do {
            return try context.fetch(T.fetchRequest() as! NSFetchRequest<T>)
        } catch {
            debugPrint("Error fetching data for type \(T.self): \(error)")
        }
        
        return []
    }
    
    
    func deleteObjects<T: NSManagedObject>(_ objectType: T.Type) {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: objectType))
        
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
            try context.save()
        } catch {
            debugPrint("Failed to delete objects of type \(objectType): \(error)")
        }
    }
    
}
