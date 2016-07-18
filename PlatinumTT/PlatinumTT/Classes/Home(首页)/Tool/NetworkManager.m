//
//  NetworkManager.m
//  ManHuaCheng
//
//  Created by tarena on 16/6/29.
//  Copyright © 2016年 win. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

+ (void)sendRequestWithUrl:(NSString *)urlStr parameters:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //服务器成功返回，将responseObject回传
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //服务器返回失败，将error回传
        failure(error);
    }];
}

@end
