//
//  BusViewModel.m
//  bus
//
//  Created by liuhongnian on 2018/11/7.
//  Copyright © 2018年 liuhongnian. All rights reserved.
//

#import "BusViewModel.h"
#import "BusInfoManager.h"

@implementation BusViewModel

@end

@interface BRT1ViewModel ()
@property(nonatomic, strong) BusInfoManager *busManager;
@end

@implementation BRT1ViewModel

- (void)startRequestBRT1RoadWithDirection:(NSString *)direction stationName:(NSString *)stationPoint {

    __weak typeof(self) weakSelf = self;

    _busManager = [[BusInfoManager alloc] init];

    [_busManager queryBusInfoWithRoadName:@"B1路"
                                direction:direction
                              stationName:stationPoint
                               completion:^(NSString *busInfo, NSError *error) {

        if (error){

        } else{
            weakSelf.result = busInfo;
        }

                               }];
}
@end


@interface Bus11ViewModel()
@property (nonatomic, strong) BusInfoManager *busManager;
@end
@implementation Bus11ViewModel
- (void)startRequest11RoadWithDirection:(NSString *)direction stationName:(NSString *)stationPoint {

    __weak typeof(self) weakSelf = self;

    _busManager = [[BusInfoManager alloc] init];
    
    [_busManager queryBusInfoWithRoadName:@"11路"
                                direction:direction
                              stationName:stationPoint
                               completion:^(NSString *busInfo, NSError *error) {

        if (error){

        } else{
            weakSelf.result = busInfo;
        }
    }];
}
@end
