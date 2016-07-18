//
//  NetworkManager.h
//  ManHuaCheng
//
//  Created by tarena on 16/6/29.
//  Copyright © 2016年 win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (void)sendRequestWithUrl:(NSString *)urlStr
                parameters:(NSDictionary *)params
                   success:(void(^)(id responseObject))success
                   failure:(void(^)(NSError *error))failure;

@end
