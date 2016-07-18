//
//  BrandModel.m
//  PlatinumTT
//
//  Created by tarena on 16/7/12.
//  Copyright © 2016年 win. All rights reserved.
//

#import "BrandModel.h"

@implementation BrandModel

+(instancetype)parseListJSON:(NSDictionary *)dict{
    return [[self alloc] parseDailylJson:dict];
}

- (BrandModel *)parseDailylJson:(NSDictionary *)dic {
    self.ios640 = dic[@"ios640"];
    self.h5Url = dic[@"h5Url"];
    self.ios1242 = dic[@"ios1242"];
    self.brandCode = dic[@"brandCode"];
    self.descriptionText = dic[@"descriptionText"];
    self.brandName = dic[@"brandName"];
    self.logo = dic[@"logo"];
    return self;
}

@end

