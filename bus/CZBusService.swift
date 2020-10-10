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
            print(baseRequest.responseString!)
            
            if baseRequest.responseJSONObject is Dictionary<String, Any> {
                
                let response = baseRequest.responseJSONObject as! Dictionary<String, Any>
                let code = response["resCode"] as! NSNumber
                if code.intValue == 10000 {
                    //success
                    let value = response["value"] as! Array<Dictionary<String,Any>>
                    if value.count >= 1 {
                        
//                        let decoder = JSONDecoder.init()
//                        var stationLists: Array<Station> = Array.init()
//                        for stationDic in value {
//                            let data = try? JSONSerialization.data(withJSONObject: stationDic, options: [])
//                            let station_obj = try! decoder.decode(Station.self, from: data!)
//                            stationLists.append(station_obj)
//                        }
                                   
                        let busInfoRequest = BusInfoAPI.init(parameters: [kAPIRequestKeyLineType: direction,
                                                                                      kAPIRequestKeyLineID: roadName])
                        busInfoRequest.startWithCompletionBlock(success: { (baseRequest) in
                            
//                            print(baseRequest.responseString!)
                            
                            
                        }) { (baseRequest) in
                            
                        }
                        
                        
                    }else{
                        print("无效的线路")
                    }
                    
                }else{
                    //failure
                }
                
            }
            

            
        }) { (baseReq) in
            
        }
        
        
    }
}
