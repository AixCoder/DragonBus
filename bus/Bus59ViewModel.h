//
//  Bus59ViewModel.h
//  bus
//
//  Created by liuhongnian on 2018/11/7.
//  Copyright © 2018年 liuhongnian. All rights reserved.
//

#import "BusViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Bus59ViewModel : BusViewModel

- (void)startRequest59RoadWithDirection:(NSString *)direction
                            stationName:(NSString *)stationPoint;

@end

NS_ASSUME_NONNULL_END
