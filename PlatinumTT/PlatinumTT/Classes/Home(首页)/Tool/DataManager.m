//
//  DataManager.m
//  ManHuaCheng
//
//  Created by tarena on 16/6/29.
//  Copyright © 2016年 win. All rights reserved.
//

#import "DataManager.h"
#import "ADModel.h"
#import "ThreeInOneModel.h"
#import "BrandModel.h"
#import "CityGroupModel.h"

@implementation DataManager

static DataManager *_dataManager = nil;
+ (DataManager *)sharedDataManger{
    if (!_dataManager) {
        _dataManager = [[DataManager alloc]init];
    }
    return _dataManager;
}

static NSArray *_cityGroups = nil;
+ (NSArray *)getCityGroups{
    if (!_cityGroups) {
        _cityGroups = [[self alloc]getCityGroup];
    }
    return _cityGroups;
}

- (NSArray *)getCityGroup{
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"cityGroups" ofType:@"plist"];
    NSArray *cityGroupArray = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dict in cityGroupArray) {
        CityGroupModel *cityGroup = [[CityGroupModel alloc]init];
        [cityGroup setValuesForKeysWithDictionary:dict];
        [mutableArray addObject:cityGroup];
    }
    return [mutableArray copy];
}

+(NSArray *)getADData:(id)responseObject{
    NSArray *Array=responseObject[@"result"][@"data"];
    
    NSMutableArray *mutableArray=[@[]mutableCopy];
    
    for (NSDictionary *dict in Array) {
        ADModel *AD=[ADModel parseListJSON:dict];
        [mutableArray addObject:AD];
    }
    return [mutableArray copy];
}

+ (NSArray *)getThreeInOneData:(id)responseObject{
    NSArray *Array=responseObject[@"result"];
    
    NSMutableArray *mutableArray=[@[]mutableCopy];
    
    for (NSDictionary *dict in Array) {
        ThreeInOneModel *ThreeInOne=[ThreeInOneModel parseListJSON:dict];
        [mutableArray addObject:ThreeInOne];
    }
    return [mutableArray copy];
}

+ (NSArray *)getBrandData:(id)responseObject{
    NSArray *Array=responseObject[@"result"];
    
    NSMutableArray *mutableArray=[@[]mutableCopy];
    
    for (NSDictionary *dict in Array) {
        BrandModel *Brand=[BrandModel parseListJSON:dict];
        [mutableArray addObject:Brand];
    }
    return [mutableArray copy];
}

@end
