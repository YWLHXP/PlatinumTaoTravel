//
//  LocationManager.m
//  PlatinumTT
//
//  Created by tarena on 16/7/14.
//  Copyright © 2016年 win. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, copy) void (^saveLocation)(double lat, double lon);

@end

@implementation LocationManager

+ (id)sharedLoationManager {
    static LocationManager *locationManager = nil;
    if (!locationManager) {
        locationManager = [[LocationManager alloc] init];
    }
    return locationManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.manager = [[CLLocationManager alloc]init];
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            [self.manager requestWhenInUseAuthorization];
        }
        self.manager.delegate = self;
    }
    return self;
}

+ (void)getUserLocation:(void (^)(double, double))locationBlock {
    LocationManager *locationManager = [LocationManager sharedLoationManager];
    [locationManager getUserLocations:locationBlock];
}

- (void)getUserLocations:(void (^)(double, double))locationBlock {
    //用户没有同意/没有开启定位功能
    if (![CLLocationManager locationServicesEnabled]) {
        //告诉用户消息无法定位
        return;
    }
    //将saveLocationBlock赋值给locationBlock
    //copy函数指针/函数体
    _saveLocation = [locationBlock copy];
    
    //设定精度(调用频率)
    self.manager.distanceFilter = 500;
    //同意/开启 -> 开始定位
    [self.manager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //防止调用多次
    CLLocation *location = [locations lastObject];
    
    //block传参数(调用block)
    _saveLocation(location.coordinate.latitude, location.coordinate.longitude);
}

@end
