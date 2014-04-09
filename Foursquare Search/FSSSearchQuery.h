//
//  FSSSearchQuery.h
//  Foursquare Search
//
//  Created by Deniz Aydemir on 4/8/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSSSearchQuery : NSObject

@property (strong, nonatomic) NSNumber *radius, *limit, *latitude, *longitude;
@property (strong, nonatomic) NSString *queryText, *location;

@property (nonatomic) BOOL useMyLocation;

@end
