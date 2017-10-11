//
//  Config.swift
//  FoodTruckServer
//
//  Created by mariusz on 11.10.2017.
//

import Foundation
import LoggerAPI
import CouchDB
import CloudFoundryEnv
import Configuration

struct ConfigError: LocalizedError {
    var errorDescription: String? {
        return "Could not retreive config info"
    }
}

func getConfig() throws -> Service {
    var appEnv: ConfigurationManager?
    do {
        Log.warning("Attempting to retreive CF env")
        appEnv = ConfigurationManager()
        let services = appEnv!.getServices()
        let servicePair = services.filter { element in element.value.label == "cloudantNoSQLDB"}.first
        guard let service = servicePair?.value else {
            throw ConfigError()
        }
        return service
    } catch {
        Log.warning("An error occured while trying to retrive configuration")
        throw ConfigError()
    }
}

