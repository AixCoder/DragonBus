//
//  BusViewModel.h
//  bus
//
//  Created by liuhongnian on 2018/11/7.
//  Copyright © 2018年 liuhongnian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusViewModel : NSObject

@property (nonatomic,strong) id result;
@property (nonatomic,strong) NSError *error;

@end

@interface BRT1ViewModel : BusViewModel

- (void)startRequestBRT1RoadWithDirection:(NSString *)direction
                            stationName:(NSString *)stationPoint;

@end

@interface Bus11ViewModel: BusViewModel

- (void)startRequest11RoadWithDirection:(NSString *)direction
                              stationName:(NSString *)stationPoint;

@end

NS_ASSUME_NONNULL_END
