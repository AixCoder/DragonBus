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

/**
 实时查询线路上运行着的车辆信息
 */
@interface BusInfoRequest : YTKRequest

- (instancetype)initWithRequestPar:(NSDictionary *)parameters;


@end


/**
 bus line info
 查询公交线路中所有的站点
 */
@interface LineRequest : YTKRequest

- (instancetype)initWithPar:(NSDictionary *)parameters;

@end

@interface SearchBusLineRequest : YTKRequest

- (instancetype)initWithLineName:(NSString *)lineName;

@end

NS_ASSUME_NONNULL_END
