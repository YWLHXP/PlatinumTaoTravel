//
//  ADModel.h
//  PlatinumTT
//
//  Created by tarena on 16/7/12.
//  Copyright © 2016年 win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADModel : NSObject

@property (nonatomic, copy) NSString *wapURL;

@property (nonatomic, copy) NSString *bannerImage;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger advertisementId;

+ (instancetype)parseListJSON:(NSDictionary *)dict;

@end

