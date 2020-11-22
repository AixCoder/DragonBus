//
//  CZBusService.swift
//  bus
//
//  Created by liuhongnian on 2020/8/13.
//  Copyright © 2020 liuhongnian. All rights reserved.
//

import UIKit

class CZBusService: NSObject {
    
    
    func queryBus(roadName: String, direction: String, station: String, completion: @escaping(Dictionary<String, Any>, NSError?) ->()) {
        
        let lineRequest = LineInfoAPI.init(parameters: [kAPIRequestKeyLineType: direction,
                                                        kAPIRequestKeyLineID: roadName])
        
        lineRequest.startWithCompletionBlock(success: { (baseRequest) in
            
            //1.check all bus stations
            if baseRequest.responseJSONObject is Dictionary<String, Any> {
                
                let response = baseRequest.responseJSONObject as! Dictionary<String, Any>
                let code = response["resCode"] as! NSNumber
                if code.intValue == 10000 {
                    //success
                    let value = response["value"] as! Array<Dictionary<String,Any>>
                    if value.count >= 1 {
                        
                        let decoder = JSONDecoder.init()
                        var stationLists: Array<Station> = Array.init()
                        for stationDic in value {
                            let data = try? JSONSerialization.data(withJSONObject: stationDic, options: [])
                            let station_obj = try! decoder.decode(Station.self, from: data!)
                            stationLists.append(station_obj)
                        }
                                   
                        
                        let busInfoRequest = BusInfoAPI.init(parameters: [kAPIRequestKeyLineType: direction,
                                                                                      kAPIRequestKeyLineID: roadName])
                        busInfoRequest.startWithCompletionBlock(success: {[weak self] (baseRequest) in
                            
                            //in the runing of the bus
                            let response = baseRequest.responseJSONObject as! Dictionary<String, Any>
                            let code = response["resCode"] as! NSNumber
                            if code.intValue == 10000 {
                                //success
                                let busValue = response["value"] as! Array<Dictionary<String, Any>>
                                if busValue.count >= 1 {
                                    
                                    var runningBus: Array<Bus> = Array.init()
                                    let decoder = JSONDecoder.init()
                                    for value in busValue {
                                        let data = try? JSONSerialization.data(withJSONObject: value, options: [])
                                        let bus = try! decoder.decode(Bus.self, from: data!)
                                        runningBus.append(bus)
                                        
                                    }
                                    
                                    let result_bus = self?.findNearByBus(station, stationLists: stationLists, runningBus: runningBus)
                                    completion(["neares_bus": result_bus!,
                                                "station": station,
                                                "bus_id": roadName] , nil)
                                    
                                    
                                }else{
                                    
                                }
                            }else{
                                //failure
                            }
                            
                            
                            
                        }) { (baseRequest) in
                            
                        }
                        
                        
                    }else{
                        print("无效的线路")
                    }
                    
                }else{
                    //failure
                    completion([:], NSError.init(domain: "查询线路失败", code: 1, userInfo: nil))
                    
                }
                
            }
            

            
        }) { (baseReq) in
            
        }
        
        
    }
    
    private func findNearByBus(_ stationName: String, stationLists: Array<Station>, runningBus: Array<Bus>) ->Array<NSNumber> {
        
        //1. station number
        //定位上车站台编号
        var stationSort = -1
        for station in stationLists {
            if station.name == stationName {
                stationSort = station.sort
            }
        }
        
        if stationSort == -1 {
            return []
        }
        
        //2. coming bus
        //找寻正在前往站点的公交车
        var comingBus: Array<Bus> = []
        for bus in runningBus {
            if bus.currentStationSort < stationSort {
                comingBus.append(bus)
            }
        }
        
        let bus_sorted = comingBus.sorted { $0.currentStationSort > $1.currentStationSort }
        if bus_sorted.count > 1 {
            let firstNearby = stationSort - bus_sorted.first!.currentStationSort
            let secondNearby = stationSort - bus_sorted[1].currentStationSort
            return [NSNumber.init(value: firstNearby), NSNumber.init(value: secondNearby)]
            
        }else if bus_sorted.count == 1{
            let nearyBy = stationSort - bus_sorted.first!.currentStationSort
            return [NSNumber.init(value: nearyBy)]
        }
        
        return []
        
    }
}

