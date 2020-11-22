//
//  BusViewModel.swift
//  bus
//
//  Created by liuhongnian on 2020/8/12.
//  Copyright © 2020 liuhongnian. All rights reserved.
//

import UIKit

class CZBusViewModel: NSObject {

    @objc dynamic var result: Dictionary<AnyHashable, Any>
    @objc var error: NSError?
    
    override init() {
        result = [:]
        error = nil
    }
    
}

class Bus59ViewModel: CZBusViewModel {
    
    private let busService = CZBusService.init()
    
    @objc func startRequest(withDirection direction: String, station: String) {
        

        busService.queryBus(roadName: "59", direction: direction, station: station) {[weak self] (busResult, error) in

            if (error == nil) {
                self?.result = busResult
            }else{
                self?.error = error
            }
        }
        
        
    }
    
}

class BRT1ViewModel: CZBusViewModel {
    
    private let busService = CZBusService.init()
    
    @objc func startRequest(withDirection direction: String, station: String) {
        
        busService.queryBus(roadName: "81", direction: direction, station: station) {[weak self] (busResult , error) in
            
            if (error == nil) {
                self?.result = busResult
            }else{
                self?.error = error
            }
        }
        
    }
}
