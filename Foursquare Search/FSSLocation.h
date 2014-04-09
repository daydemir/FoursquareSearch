//
//  FSSLocationManager.h
//  Foursquare Search
//
//  Created by Deniz Aydemir on 4/8/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kFSSUpdatedMyLocationNotification @"FSSUpdatedMyLocationNotification"

@interface FSSLocation : NSObject <CLLocationManagerDelegate>

//@property (weak, nonatomic) id<FSSLocationDelegate> delegate;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *myLocation;

+ (id)getInstance;

@end
