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

@implementation DataManager

static DataManager *_dataManager = nil;
+ (DataManager *)sharedDataManger {
    if (!_dataManager) {
        _dataManager = [[DataManager alloc]init];
    }
    return _dataManager;
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

//+ (NSArray *)getBookcityRankingListData:(id)responseObject{
//    NSArray *Array=responseObject[@"info"][@"specials"];
//    
//    NSMutableArray *mutableArray=[@[]mutableCopy];
//    
//    for (NSDictionary *dict in Array) {
//        BookcityRankingListModel *rankingList=[BookcityRankingListModel parseListJSON:dict];
//        [mutableArray addObject:rankingList];
//    }
//    return [mutableArray copy];
//}
//
//+ (NSArray *)getBookcityRecomendData:(id)responseObject{
//    NSString *str=responseObject[@"info"][@"adlistjson"];
//    
//    NSArray *Array = [NSString arrayWithJsonString:str];
//    
//    NSMutableArray *mutableArray=[@[]mutableCopy];
//    
//    for (NSDictionary *dict in Array) {
//        BookcityRecomendModel *recomend=[BookcityRecomendModel parseListJSON:dict];
//        [mutableArray addObject:recomend];
//    }
//    return [mutableArray copy];
//}

@end
