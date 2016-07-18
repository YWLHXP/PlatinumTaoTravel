//
//  ThreeInOneModel.m
//  PlatinumTT
//
//  Created by tarena on 16/7/12.
//  Copyright © 2016年 win. All rights reserved.
//

#import "ThreeInOneModel.h"

@implementation ThreeInOneModel

+(instancetype)parseListJSON:(NSDictionary *)dict{
    return [[self alloc] parseDailylJson:dict];
}

- (ThreeInOneModel *)parseDailylJson:(NSDictionary *)dic {
    self.url = dic[@"url"];
    self.threeX = dic[@"3x"];
    self.title = dic[@"title"];
    self.twoX = dic[@"2x"];
    self.memberActCode = dic[@"memberActCode"];
    self.desc = dic[@"desc"];
    return self;
}

@end


