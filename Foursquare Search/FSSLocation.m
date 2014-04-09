//
//  FSSLocationManager.m
//  Foursquare Search
//
//  Created by Deniz Aydemir on 4/8/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import "FSSLocation.h"

@implementation FSSLocation


+ (FSSLocation *)getInstance {
    static FSSLocation *sharedInstance = nil;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[FSSLocation alloc] init];
	});
	
	return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        [self.locationManager startMonitoringSignificantLocationChanges];
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.myLocation = locations[0];
    NSTimeInterval howRecent = [[self.myLocation timestamp] timeIntervalSinceNow];
    if (abs(howRecent)>15.0) {
        [self.locationManager startMonitoringSignificantLocationChanges];
//        if ([self.delegate respondsToSelector:@selector(updatedMyLocation:)]) {
//            [self.delegate updatedMyLocation:self.myLocation];
//        }
    }
    else {
        [self.locationManager stopUpdatingLocation];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kFSSUpdatedMyLocationNotification object:self];
}

@end
