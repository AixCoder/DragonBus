//
//  BusInfoManager.h
//  bus
//
//  Created by liuhongnian on 2018/11/7.
//  Copyright © 2018年 liuhongnian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusInfoManager : NSObject

//- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))block API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));

- (void)queryBusInfoWithRoadName:(NSString *)roadName
                       direction:(NSString *)direction
                     stationName:(NSString *)stationName
                      completion:(void (^)(NSString * _Nullable busInfo , NSError * _Nullable error))block;


@end

NS_ASSUME_NONNULL_END
