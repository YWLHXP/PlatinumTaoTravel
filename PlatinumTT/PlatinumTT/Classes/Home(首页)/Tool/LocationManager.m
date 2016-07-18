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
        locationManager = [[LocationManager alloc]init];
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
    if (![CLLocationManager locationServicesEnabled]) {
        //显示无法定位
        return;
    }
    _saveLocation = [locationBlock copy];
    
    self.manager.distanceFilter = 500;
    
    [self.manager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    
    _saveLocation(location.coordinate.latitude, location.coordinate.longitude);
}

@end
