//
//  Bus59ViewModel.m
//  bus
//
//  Created by liuhongnian on 2018/11/7.
//  Copyright © 2018年 liuhongnian. All rights reserved.
//

#import "Bus59ViewModel.h"
#import "BusInfoManager.h"

@interface Bus59ViewModel ()
@property (nonatomic,strong) BusInfoManager *busManager;
@end

@implementation Bus59ViewModel

- (void)startRequest59RoadWithDirection:(NSString *)direction
                            stationName:(NSString *)stationPoint
{
    _busManager = [[BusInfoManager alloc] init];
    __weak typeof(self) weakSelf = self;
    [_busManager queryBusInfoWithRoadName:@"59路"
                                direction:direction
                              stationName:stationPoint
                               completion:^(NSString * _Nullable busInfo, NSError * _Nullable error) {
                                   if (!error) {
                                       weakSelf.result = busInfo;
                                   }
                                   
    }];
}

@end
