//
//  DataManager.h
//  ManHuaCheng
//
//  Created by tarena on 16/6/29.
//  Copyright © 2016年 win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (NSArray *)getADData:(id)responseObject;
+ (NSArray *)getThreeInOneData:(id)responseObject;
+ (NSArray *)getBrandData:(id)responseObject;
+ (NSArray *)getCityGroups;

@end
