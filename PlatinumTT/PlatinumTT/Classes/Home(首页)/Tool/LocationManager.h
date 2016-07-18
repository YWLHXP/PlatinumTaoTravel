//
//  LocationManager.h
//  PlatinumTT
//
//  Created by tarena on 16/7/14.
//  Copyright © 2016年 win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

+ (void)getUserLocation:(void(^)(double lat, double lon))locationBlock;

@end
