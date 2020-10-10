//
//  BusModel.swift
//  bus
//
//  Created by liuhongnian on 2020/8/13.
//  Copyright © 2020 liuhongnian. All rights reserved.
//

import UIKit

class BusModel: NSObject {

}

class Station :Decodable {

    let lineId: String
    let lineName: String
    let lineType: Int
    let directionId: String
    let stationId: String
    let stationCode: String
    let stationName: String
    let sort: Int
    let gpsSort: Int
    let distance: Double

    private enum CodingKeys: String, CodingKey {
        case lineId = "Line_Id"
        case lineName = "Line_Name"
        case lineType = "Line_Type"
        case directionId = "Direction_Id"
        case stationId = "Station_Id"
        case stationCode = "Station_Code"
        case stationName = "Station_Name"
        case sort = "Sort"
        case gpsSort = "GpsSort"
        case distance = "Distance"
    }
}

class Bus: NSObject,Decodable {
    let busId: String
    let busNo: String
    let oilType: Int
    let high: Double
    let speed: Double
    let direction: Double
    let gpsTime: Date
    let recTime: Date
    let lineId: Int
    let lineType: Int
    let currentStationSort: Int
    let isArrive: Int
    let stepGps: String

    private enum CodingKeys: String, CodingKey {
        case busId = "BusId"
        case busNo = "BusNo"
        case oilType = "Oil_Type"
        case high = "High"
        case speed = "Speed"
        case direction = "Direction"
        case gpsTime = "GpsTime"
        case recTime = "RecTime"
        case lineId = "Line_Id"
        case lineType = "Line_Type"
        case currentStationSort = "Current_Station_Sort"
        case isArrive = "IsArrive"
        case stepGps = "StepGps"
    }
}
