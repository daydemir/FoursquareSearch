//
//  FSSVenuesViewController.h
//  Foursquare Search
//
//  Created by Deniz Aydemir on 1/31/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSSVenuesViewController : UIViewController


@property (strong, nonatomic) NSNumber *radius, *limit, *latitude, *longitude;
@property (strong, nonatomic) NSString *query, *location;

@property (nonatomic) BOOL useMyLocation;

@end
