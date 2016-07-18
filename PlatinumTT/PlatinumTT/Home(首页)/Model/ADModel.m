//
//  ADModel.m
//  PlatinumTT
//
//  Created by tarena on 16/7/12.
//  Copyright © 2016年 win. All rights reserved.
//

#import "ADModel.h"

@implementation ADModel

+(instancetype)parseListJSON:(NSDictionary *)dict{
    return [[self alloc] parseDailylJson:dict];
}

- (ADModel *)parseDailylJson:(NSDictionary *)dic {
    self.wapURL = dic[@"wapURL"];
    self.advertisementId = [dic[@"advertisementId"] integerValue];
    self.bannerImage = dic[@"bannerImage"];
    self.name = dic[@"name"];
    return self;
}

@end


