import Foundation
import Kitura
import HeliumLogger
import LoggerAPI
import CloudFoundryEnv
import FoodTruckAPI
import Configuration

HeliumLogger.use()

let trucks: FoodTruckAPI

do {
    Log.info("Attepting init ith CF environment")
    let service = try getConfig()
    Log.info("Init with service")
    trucks = FoodTruck(service: service)
} catch {
    Log.info("Could not retreive CF env: init with defaults values")
    trucks = FoodTruck()
}

let controller = FoodTruckController(backend: trucks)

do {
    let port = try ConfigurationManager().port
    Log.verbose("Used port is \(port)")
    Kitura.addHTTPServer(onPort: port, with: controller.router)
    Kitura.run()
} catch {
    Log.error("Server failed to start")
}

