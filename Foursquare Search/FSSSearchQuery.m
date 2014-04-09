//
//  FSSSearchQuery.m
//  Foursquare Search
//
//  Created by Deniz Aydemir on 4/8/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import "FSSSearchQuery.h"

@implementation FSSSearchQuery

- (id)init
{
    self = [super init];
    if (self) {
        self.limit = [NSNumber numberWithInt:50];
        self.radius = [NSNumber numberWithInt:10000];
        self.useMyLocation = YES;
    }
    return self;
}

@end
