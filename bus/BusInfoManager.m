//
//  BusInfoManager.m
//  bus
//
//  Created by liuhongnian on 2018/11/7.
//  Copyright © 2018年 liuhongnian. All rights reserved.
//

#import "BusInfoManager.h"
#import "APIRequest.h"
#import "APIKeys.h"

@interface BusInfoManager ()
@property(nonatomic, strong) BusInfoRequest *busInfoRequest;
@property (nonatomic,strong) LineRequest *lineRequest;
@end

@implementation BusInfoManager

- (void)queryBusInfoWithRoadName:(NSString *)roadName
                       direction:(NSString *)direction
                     stationName:(NSString *)stationName
                      completion:(nonnull void (^)(NSString * _Nullable, NSError * _Nullable))block
{

    
    __weak typeof(self) weakSelf = self;
    
//    http://bts.czsmk.com:8080
//    /czbus/v3.0/line/
    
    _lineRequest = [[LineRequest alloc] initWithPar:@{kAPIRequestKeyLineType: direction,
                                                      kAPIRequestKeyLineID: roadName
                                                      }];
    
    [_lineRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //解析数据
        NSString *receiveStr = [[NSString alloc] initWithData:request.responseData
                                                     encoding:NSUTF8StringEncoding];
        NSData *data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableLeaves
                                                                   error:nil];
        int res_code = [jsonDict[@"resCode"] intValue];
        if (res_code == 10000) {
            
            {
                
                NSArray *value = jsonDict[@"value"];
                NSArray *stationsList = value.firstObject[@"StationList"];
                
                weakSelf.busInfoRequest = [[BusInfoRequest alloc] initWithRequestPar:@{kAPIRequestKeyLineID:roadName,
                                                                                       kAPIRequestKeyLineType: direction
                                                                                       }];
                
                [weakSelf.busInfoRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    NSString *receiveStr = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
                    NSData *data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    NSArray *busOnRoad = jsonDict[@"value"];
                    
                    //找出站台的位置号
                    __block NSUInteger startStationIndex = 0;
                    [stationsList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                        NSString *name = obj[@"Station_Name"];
                        if ([name isEqualToString:stationName]) {
                            startStationIndex = [obj[@"Sort"] integerValue];
                        }
                    }];
                    
                    //找寻还没到站点的车辆
                    NSMutableArray *comeBus = [NSMutableArray array];
                    [busOnRoad enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                        NSUInteger busIndex = [obj[@"Current_Station_Sort"] unsignedIntegerValue];
                        if (busIndex < startStationIndex) {
                            [comeBus addObject:obj];
                        }
                    }];
                    
                    //排序，计算出离站点最近的车辆
                    [comeBus sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                        if ([obj1[@"Current_Station_Sort"] intValue] < [obj2[@"Current_Station_Sort"] intValue]) {
                            return NSOrderedDescending;
                        } else {
                            return NSOrderedAscending;
                        }
                    }];
                    
                    NSDictionary *willComingBus = comeBus.firstObject;
                    NSUInteger remaining = startStationIndex - [willComingBus[@"Current_Station_Sort"] intValue];
                    NSString *result = [NSString stringWithFormat:@"老司机驾驶的%@还有%lu站抵达%@", roadName,(unsigned long) remaining,stationName];
                    
                    block(result,nil);
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                }];
            }
        }else{
            NSLog(@"请求线路所有的站点出错");
            NSError *error = [NSError errorWithDomain:[NSString stringWithFormat:@"%@线路查询失败",roadName]
                                                 code:12
                                             userInfo:nil];
            block(nil, error);
        }
        

    }                                            failure:^(__kindof YTKBaseRequest *request) {

        block(nil,request.error);
    }];


}
@end
