//
//  CZApi.swift
//  bus
//
//  Created by liuhongnian on 2020/8/3.
//  Copyright © 2020 liuhongnian. All rights reserved.
//

import UIKit

class CZApi: YTKRequest {
    
}


/// 查询🚌api
class SearchBusApi: YTKRequest {
    
    let line_name: String
    @objc init(lineName: String) {
        line_name = lineName
        super.init()
    }
    
    override func requestUrl() -> String {
        
//        https://czxxcxapi.czsmk.com:30003/bus/CzBus/V4.0/Line/GetList?Line_Name=59
        return "http://api.czjtkx.com/CzBus/V4.0/Line/GetList"

    }
    
    override func requestArgument() -> Any? {
        return ["Line_Name": line_name]
    }
}

/// line info request (查询🚌完整线路信息)
class LineInfoAPI: YTKRequest {
    
    let parameter: Dictionary<String, Any>
    
    init(parameters: Dictionary<String, Any>) {
        
        self.parameter = parameters
    }
    
    override func requestUrl() -> String {
        
        return "http://api.czjtkx.com/CzBus/V4.0/Station/GetListByLine";
    }
    
    override func requestArgument() -> Any? {
        return self.parameter
    }
    
}

class BusInfoAPI: YTKRequest {
    
    let parameter: Dictionary<String, Any>
    init(parameters: Dictionary<String, Any>) {
        parameter = parameters
    }
    
    override func requestArgument() -> Any? {
        return parameter
    }
    
    override func requestUrl() -> String {
        return "https://czxxcxapi.czsmk.com:30003/bus/CzBus/V4.0/Bus/GetList";
    }
}







