//
//  APIRequest.h
//  bus
//
//  Created by liuhongnian on 2018/11/6.
//  Copyright © 2018年 liuhongnian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKNetwork/YTKNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface APIRequest : NSObject

@end

@interface BusInfoRequest : YTKRequest

- (instancetype)initWithRequestPar:(NSDictionary *)parameters;


@end

NS_ASSUME_NONNULL_END
