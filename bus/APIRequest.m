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
    return @"http://0519.mygolbs.com:8081/MyBuscz/BusAction";
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (id)requestArgument
{
    return _requestParams;
}

- (YTKResponseSerializerType)responseSerializerType
{
    return YTKResponseSerializerTypeHTTP;
}

@end
