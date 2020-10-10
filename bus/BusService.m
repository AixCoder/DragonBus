//
//  BusService.m
//  bus
//
//  Created by liuhongnian on 2019/2/27.
//  Copyright © 2019年 liuhongnian. All rights reserved.
//

#import "BusService.h"
#import "APIKeys.h"
#import "APIRequest.h"


@interface BusService ()

@property (nonatomic,strong) LineRequest *lineRequest;

@property (nonatomic,strong) BusInfoRequest *busRequest;

@end


@implementation BusService

/**
 查询离你最近的两辆公交信息

 @param road 公交线路
 @param direction 方向
 @param stationName 上车的站点
 @param block 车辆信息
 */
- (void)queryBusWithRoadName:(NSString *)road
                   direction:(NSString *)direction
                  busStation:(NSString *)stationName
                  completion:(void (^)(NSDictionary * _Nullable, NSError * _Nullable))block
{
    //1 查询该线路所有站点
    __weak typeof(self) weakSelf = self;
    _lineRequest = [[LineRequest alloc] initWithPar:@{kAPIRequestKeyLineType: direction,
                                                      kAPIRequestKeyLineID: road
                                                      }];
    
    [_lineRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {

        int success = [request.responseObject[@"resCode"] intValue];
        if (success == 10000) {
            NSArray *value = request.responseObject[@"value"];
            NSArray *stationLists = value;
            NSAssert(stationLists.count >= 1, @"查询线路失败");
            //找出该条线路上正在运行的车辆信息
            weakSelf.busRequest = [[BusInfoRequest alloc] initWithRequestPar:@{kAPIRequestKeyLineID:road,
                                                                               kAPIRequestKeyLineType:direction
                                                                                   }];
            [weakSelf.busRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                //计算出离你最近的两辆车所在位置
                if ([request.responseObject[@"resCode"] intValue] == 10000) {
                    NSArray *busLists = request.responseObject[@"value"];
                    //计算出下一辆还有几站路到来。
                    NSArray *nearest_bus = [weakSelf findNearestCarsWithLineList:stationLists
                                                                         busList:busLists
                                                                     stationName:stationName];

                    block(@{@"neares_bus": nearest_bus,
                            @"station": stationName,
                            @"bus_id":road
                            },nil);
                    
                    
                }else{
                    block(nil,[NSError errorWithDomain:@"线路查询失败" code:83 userInfo:nil]);
                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                
            }];
            
            
        }else{
            block(nil,[NSError errorWithDomain:@"线路查询失败" code:83 userInfo:nil]);
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        block(nil,request.error);
    }];
}


- (NSArray *)findNearestCarsWithLineList:(NSArray *)lineList busList:(NSArray *)busList stationName:(NSString *)stationName
{
    //1找出站台的位置
    NSUInteger stationSport = 1001;
    
    for (NSDictionary *stationInfo in lineList) {
        NSString *station_name = stationInfo[@"Station_Name"];
        if ([station_name isEqualToString:stationName]) {
            stationSport = [stationInfo[@"Sort"] unsignedIntegerValue];
        }
    }
    
//    NSAssert(stationSport != 1001, @"");
    
    //找出快到站台的车辆
    NSMutableArray *commingBus = [NSMutableArray arrayWithCapacity:3];
    for (NSDictionary *bus in busList) {
        NSInteger current_Sort = [bus[@"Current_Station_Sort"] integerValue];
        if (current_Sort < stationSport) {
            [commingBus addObject:bus];
        }
    }
    
    //快到站的车辆排序，从近到远
    [commingBus sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        if ([obj1[@"Current_Station_Sort"] intValue] < [obj2[@"Current_Station_Sort"] intValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    //离的最近的两辆车
    if (commingBus.count >= 1) {
        if (commingBus.count >= 2) {
            NSInteger station_sort1 = [commingBus.firstObject[@"Current_Station_Sort"] integerValue];
            NSInteger station_sort2 = [commingBus[1][@"Current_Station_Sort"] integerValue];
            
            NSInteger bus1 = stationSport - station_sort1;
            NSInteger bus2 = stationSport - station_sort2;
            //返回第一辆车和第二辆车还有几站到达
            return @[@(bus1),@(bus2)];
            
        }else{
            
            NSInteger station_sort1 = [commingBus.firstObject[@"Current_Station_Sort"] integerValue];
            //返回最近的一辆车还有几站到达。
            return @[@(stationSport - station_sort1)];
        }
    }
    
    return @[];
}

@end
