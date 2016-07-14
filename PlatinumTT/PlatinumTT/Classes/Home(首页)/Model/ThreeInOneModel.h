//
//  ThreeInOneModel.h
//  PlatinumTT
//
//  Created by tarena on 16/7/12.
//  Copyright © 2016年 win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreeInOneModel : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *threeX;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *twoX;

@property (nonatomic, copy) NSString *memberActCode;

@property (nonatomic, copy) NSString *desc;

+ (instancetype)parseListJSON:(NSDictionary *)dict;

@end

