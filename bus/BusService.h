//
//  BusService.h
//  bus
//
//  Created by liuhongnian on 2019/2/27.
//  Copyright © 2019年 liuhongnian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusService : NSObject

- (void)queryBusWithRoadName:(NSString *)road
                   direction:(NSString *)direction
                  busStation:(NSString *)stationName
                  completion:(void(^)(NSDictionary * _Nullable busInfo, NSError *_Nullable error))block;
@end

NS_ASSUME_NONNULL_END
