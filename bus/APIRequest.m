//
//  APIRequest.m
//  bus
//
//  Created by liuhongnian on 2018/11/6.
//  Copyright © 2018年 liuhongnian. All rights reserved.
//

#import "APIRequest.h"

@implementation APIRequest

@end

@interface BusInfoRequest ()
@property (nonatomic, strong)NSDictionary *requestParams;
@end
@implementation BusInfoRequest

- (instancetype)initWithRequestPar:(NSDictionary *)parameters
{
    if (self = [super init]) {
        _requestParams = parameters;
    }
    return self;
}

- (NSString *)requestUrl
{
//https://czxxcxapi.czsmk.com:30003/bus/CzBus/V4.0/Bus/GetList?Line_Id=81&Line_Type=1
//    return @"http://api.czjtkx.com/CzBus/V4.0/Bus/GetList";
    return @"https://czxxcxapi.czsmk.com:30003/bus/CzBus/V4.0/Bus/GetList";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

- (id)requestArgument
{
    return _requestParams;
}

@end

@interface LineRequest ()

@property (nonatomic,strong) NSDictionary *parameter;

@end

@implementation LineRequest

- (NSString *)requestUrl
{
//    http://api.czjtkx.com/CzBus/V4.0/Station/GetListByLine?Line_Id=81&Line_Type=1
    return @"http://api.czjtkx.com/CzBus/V4.0/Station/GetListByLine";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

- (id)requestArgument
{
    return _parameter;
}

- (instancetype)initWithPar:(NSDictionary *)parameters
{
    if (self = [super init]) {
        _parameter = parameters;
    }
    return self;
}

@end


@interface SearchBusLineRequest ()
@property (nonatomic,copy) NSString *lineName;

@end
@implementation SearchBusLineRequest

- (instancetype)initWithLineName:(NSString *)lineName
{
    if (self = [super init]) {
        _lineName = lineName;
    }
    return self;
}

- (NSString *)requestUrl
{
//    http://api.czjtkx.com/CzBus/V4.0/Line/GetList?Line_Name=59
    return @"http://api.czjtkx.com/CzBus/V4.0/Line/GetList";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

- (id)requestArgument
{
    return @{@"Line_Name": _lineName};
    
}



@end
