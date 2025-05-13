//
//  TitanicModel.swift
//  Titanic
//
//  Created by Ronjie Diafante Man-on on 5/13/25.
//

import Foundation

struct TitanicModel: Identifiable {
    let id = UUID()
    
    var passengerClass: String
    var sex: String
    var age: Double
    var siblingsSpouses: Double
    var parentsChildren: Double
    var fare: Double
    var port: String
    
    static let passengerClasses = [
        "First Class",
        "Second Class",
        "Third Class"
    ]
    
    static let ports = [
        "Cherbourg", "Queenstown", "Southampton"
    ]
    
    static let genders = ["Male", "Female"]
    
    var Pclass: Int64 {
        switch passengerClass {
        case "First Class":
            return 1
        case "Second Class":
            return 2
        case "Third Class":
            return 3
        default:
            return 0
        }
    }
}
