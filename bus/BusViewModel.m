//
//  BusViewModel.m
//  bus
//
//  Created by liuhongnian on 2018/11/7.
//  Copyright © 2018年 liuhongnian. All rights reserved.
//

#import "BusViewModel.h"
#import "BusService.h"

@implementation BusViewModel

@end


//    _busService = [[BusService alloc] init];
//    [_busService queryBusWithRoadName:@"81" direction:direction busStation:stationPoint completion:^(NSDictionary * _Nullable busInfo, NSError * _Nullable error) {
//
//        if (error) {
//            weakSelf.error = error;
//        }else{
//            weakSelf.result = busInfo;
//        }
//    }];


@interface Bus11ViewModel()

@property (nonatomic,strong) BusService *busService;

@end
@implementation Bus11ViewModel
- (void)startRequest11RoadWithDirection:(NSString *)direction stationName:(NSString *)stationPoint {

    __weak typeof(self) weakSelf = self;    
    _busService = [[BusService alloc] init];
    
    [_busService queryBusWithRoadName:@"11"
                            direction:direction busStation:stationPoint completion:^(NSDictionary * _Nullable busInfo, NSError * _Nullable error) {
                                
                                if (error) {
                                    weakSelf.error = error;
                                }else{
                                    weakSelf.result = busInfo;
                                }
        
    }];
    
}
@end
