//
//  Delivery.swift
//  ADS104 Project
//
//  Created by Moo on 13/6/18.
//  Copyright © 2018 Amina Qureshi. All rights reserved.
//

import Foundation

//model of delivery object
struct Delivery: Codable {
    
    //model properties
    var recipientName: String
    var deliveryAddress: String
    var status: String
    var parcelTrackingNumber: String
    var lastUpdated: Date
    var delivered: Date
    var notes: String?
    
    //constants to use in storing/accessing data to and from disk
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("deliveries").appendingPathExtension("plist")
    
    //method to load delivery data from disk
    static func loadDeliveries() -> [Delivery]? {
        guard let codedDeliveries = try? Data(contentsOf: ArchiveURL)
            else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Delivery>.self, from: codedDeliveries)
    }
    
    //method to save delivery data to disk
    static func saveDeliveries(_ deliveries: [Delivery]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedDeliveries = try? propertyListEncoder.encode(deliveries)
        try? codedDeliveries?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    //method to load sample data
    static func loadSampleDeliveries() -> [Delivery] {
        let delivery1 = Delivery(recipientName: "Sam", deliveryAddress: "104 AppleTree Drive, SwiftVille 2X12", status: "Delivered", parcelTrackingNumber: "TX45670", lastUpdated: Date(), delivered: Date(), notes: "Left at doorstep")
        let delivery2 = Delivery(recipientName: "Amy", deliveryAddress: "23 Swift Lane, AppTown 221X", status: "In transit", parcelTrackingNumber: "TX77025", lastUpdated: Date(), delivered: Date(), notes: "Do NOT leave unattended at premises")
        let delivery3 = Delivery(recipientName: "John", deliveryAddress: "The Coffee Place, AppleWorld 33X1", status: "Processing", parcelTrackingNumber: "TX34505", lastUpdated: Date(), delivered: Date(), notes: "")
        
        return [delivery1, delivery2, delivery3]
    }
}
