//
//  BrandModel.h
//  PlatinumTT
//
//  Created by tarena on 16/7/12.
//  Copyright © 2016年 win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandModel : NSObject

@property (nonatomic, copy) NSString *ios640;

@property (nonatomic, copy) NSString *h5Url;

@property (nonatomic, copy) NSString *ios1242;

@property (nonatomic, copy) NSString *brandCode;

@property (nonatomic, copy) NSString *descriptionText;

@property (nonatomic, copy) NSString *brandName;

@property (nonatomic, copy) NSString *logo;

+ (instancetype)parseListJSON:(NSDictionary *)dict;

@end
