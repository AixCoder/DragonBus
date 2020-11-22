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

    let lineType: Int
    let directionId: String
    let stationId: String
    let name: String
    let sort: Int
    let gpsSort: Int
    let distance: Double

    private enum CodingKeys: String, CodingKey {
        case lineType = "Line_Type"
        case directionId = "Direction_Id"
        case stationId = "Station_Id"
        case name = "Station_Name"
        case sort = "Sort"
        case gpsSort = "GpsSort"
        case distance = "Distance"
    }
}

class Bus: NSObject,Decodable {
    let busNo: String
    let direction: Double
    let lineId: Int
    let lineType: Int
    let currentStationSort: Int
    
//    "BusId":"38539",
//        "BusNo":"苏D58253",
//        "Oil_Type":2,
//        "High":0,
//        "Speed":3,
//        "Direction":13,
//        "GpsTime":"2020-11-22 14:55:55",
//        "RecTime":"2020-11-22 14:56:13",
//        "Line_Id":59,
//        "Line_Type":1,
//        "Current_Station_Sort":44,
//        "IsArrive":0,
//        "StepGps":"119.797282,31.99392;119.79734,31.994253;119.797473,31.994669",
//        "LatLng":Object{...}

    private enum CodingKeys: String, CodingKey {
        case busNo = "BusNo"
        case direction = "Direction"
        case lineId = "Line_Id"
        case lineType = "Line_Type"
        case currentStationSort = "Current_Station_Sort"
    }
}
