//
//  FSSVenueDetailViewController.h
//  Foursquare Search
//
//  Created by Deniz Aydemir on 1/31/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVenue.h"



@interface FSSVenueDetailViewController : UIViewController

@property (strong, nonatomic) NSArray *venues;
@property (nonatomic) int selectedVenueIndex;

@end
