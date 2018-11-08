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
@end

@implementation BusInfoManager

- (void)queryBusInfoWithRoadName:(NSString *)roadName
                       direction:(NSString *)direction
                     stationName:(NSString *)stationName
                      completion:(nonnull void (^)(NSString * _Nullable, NSError * _Nullable))block
{

    NSDictionary *dic = @{kAPIRequestKeyCityName: @"常州市",
            kAPIRequestKeyLineName: roadName,
            kAPIRequestKeyDirection: direction,
            kAPIRequestKeyCMD: @"102"
    };
    
    __weak typeof(self) weakSelf = self;
    _busInfoRequest = [[BusInfoRequest alloc] initWithRequestPar:dic];
    [_busInfoRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        //解析数据
        NSString *receiveStr = [[NSString alloc] initWithData:request.responseData
                                                     encoding:NSUTF8StringEncoding];
        NSData *data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableLeaves
                                                                   error:nil];
        NSArray * stationsList = jsonDict[@"data"];
        //没有公交站台数据
        if (!stationsList) {
            NSError *error = [NSError errorWithDomain:[NSString stringWithFormat:@"%@线路查询失败",roadName] code:12 userInfo:nil];
            block(nil, error);
        }else{
            NSDictionary *dic = @{kAPIRequestKeyCityName: @"常州市",
                                  kAPIRequestKeyLineName: roadName,
                                  kAPIRequestKeyDirection: direction,
                                  kAPIRequestKeyCMD: @"103"
                                  };
            weakSelf.busInfoRequest = [[BusInfoRequest alloc] initWithRequestPar:dic];
            [weakSelf.busInfoRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                
                NSString *receiveStr = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
                NSData *data = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSArray *busOnRoad = jsonDict[@"data"];
                
                //找出等车站台的位置号
                __block NSUInteger startStationIndex = 0;
                [stationsList enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                    NSString *name = obj[@"stationName"];
                    if ([name isEqualToString:stationName]) {
                        startStationIndex = [obj[@"stationOrder"] integerValue];
                    }
                }];
                
                //开始找寻最近的车辆
                NSMutableArray *comeBus = [NSMutableArray array];
                [busOnRoad enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                    NSUInteger busIndex = [obj[@"index"] unsignedIntegerValue];
                    if (busIndex < startStationIndex) {
                        [comeBus addObject:obj];
                    }
                }];
                
                //排序，计算出离的最近的车辆
                [comeBus sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                    if ([obj1[@"index"] intValue] < [obj2[@"index"] intValue]) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedAscending;
                    }
                }];
                
                NSDictionary *willComingBus = comeBus.firstObject;
                NSUInteger remaining = startStationIndex - [willComingBus[@"index"] intValue];
                NSString *result = [NSString stringWithFormat:@"老司机驾驶的%@还有%lu站抵达%@", roadName,(unsigned long) remaining,stationName];
                
                block(result,nil);

            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                
            }];
        }

    }                                            failure:^(__kindof YTKBaseRequest *request) {

        block(nil,request.error);
    }];


}
@end
