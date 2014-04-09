//
//  FSSMapView.m
//  Foursquare Search
//
//  Created by Deniz Aydemir on 4/8/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import "FSSMapView.h"

@implementation FSSMapView

- (MKMapView*)mapView
{
    if(!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:self.frame];
        [_mapView setMapType:MKMapTypeStandard];
        [_mapView.layer setMasksToBounds:YES];
//        _mapView setRegion:
    }
    return _mapView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cornerRadius = frame.size.width/2;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [self addSubview:self.mapView];
}

@end
