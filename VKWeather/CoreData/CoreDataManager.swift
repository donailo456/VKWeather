//
//  CoreDataManager.swift
//  VKWeather
//
//  Created by Danil Komarov on 20.03.2024.
//

import UIKit
import CoreData

//MARK: - CRUD
public final class CoreDataManager {
    public static let shared = CoreDataManager()
    private init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    public func addCurrWeather(temp: String,
                               parameters: String,
                               humidity: String,
                               tempMin: String,
                               tempMax: String,
                               pressure: String,
                               windSpeed: String,
                               windDeg: String,
                               clouds: String,
                               icon: Data?) {
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
        weather.icon = icon
        
        appDelegate.saveContext()
    }
    
    public func addForecastWeather(temp: String,
                                   pres: String,
                                   rh: String,
                                   tempMin: String,
                                   tempMax: String,
                                   date: String,
                                   windSpd: String,
                                   windDir: String) {
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
        
        appDelegate.saveContext()
    }
    
    public func fetchData<T: NSManagedObject>() -> [T] {
        do {
            return try context.fetch(T.fetchRequest() as! NSFetchRequest<T>)
        } catch {
            print("Error fetching data for type \(T.self): \(error)")
        }
        
        return []
    }

    
    public func deleteObjects<T: NSManagedObject>(_ objectType: T.Type) {
            let fetchRequest = NSFetchRequest<T>(entityName: String(describing: objectType))
            
            do {
                let objects = try context.fetch(fetchRequest)
                for object in objects {
                    context.delete(object)
                }
                
                // Сохраняем контекст, чтобы изменения были фиксированы в хранилище данных
                try context.save()
            } catch {
                print("Failed to delete objects of type \(objectType): \(error)")
            }
        }
    
    public func updateWeather() {
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<CurrentWeatherData> = CurrentWeatherData.fetchRequest()
        
        do {
            let objects = try context.fetch(fetchRequest)
            
            guard let objectToUpdate = objects.first else {
                return
            }
            
            objectToUpdate.temp = "100"
            objectToUpdate.tempMin = "10"
            
            try context.save()
        } catch {
            print("Failed to update object: \(error)")
        }
    }
    
    public func updateImageWeather(image: Data?) {
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<CurrentWeatherData> = CurrentWeatherData.fetchRequest()
        
        do {
            let objects = try context.fetch(fetchRequest)
            
            guard let objectToUpdate = objects.first else {
                return
            }
            
            objectToUpdate.icon = image
            
            try context.save()
        } catch {
            print("Failed to update object: \(error)")
        }
    }
    
    
}
