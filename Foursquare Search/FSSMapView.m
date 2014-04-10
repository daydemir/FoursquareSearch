//
//  FSSMapView.m
//  Foursquare Search
//
//  Created by Deniz Aydemir on 4/8/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import "FSSMapView.h"
#import "FSSLocation.h"
#import "UIColor+FSSColors.h"
#import "FSSDoubleTapAndPanGestureRecognizer.h"

@interface FSSMapView() <MKMapViewDelegate>

@property (nonatomic) MKCoordinateRegion currentVisibleRegion;
@property (nonatomic) BOOL firstShow;

@end

@implementation FSSMapView

- (MKMapView*)mapView
{
    if(!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)];
        [_mapView setMapType:MKMapTypeStandard];
        [_mapView.layer setMasksToBounds:YES];
        [_mapView setShowsUserLocation:YES];
        [_mapView setDelegate:self];
        [_mapView setTintColor:[UIColor softPurple]];
        [[_mapView layer] setCornerRadius:_mapView.frame.size.width/2];
    }
    return _mapView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cornerRadius = frame.size.width/2;
        self.firstShow = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self addGestureRecognizer:[[FSSDoubleTapAndPanGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAndPanOnMap:)]];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [self addSubview:self.mapView];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (self.firstShow) {
        [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(.05, .05)) animated:YES];
        self.firstShow = NO;
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.currentVisibleRegion = mapView.region;
}

- (void)doubleTapAndPanOnMap:(FSSDoubleTapAndPanGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Coordinate Span: %f, %f.", self.mapView.region.span.longitudeDelta, self.mapView.region.span.latitudeDelta);
    UIGestureRecognizerState state = gestureRecognizer.state;
    CGFloat displacement = gestureRecognizer.displacement*.0001;
    if(gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.centerCoordinate, MKCoordinateSpanMake(displacement+self.currentVisibleRegion.span.latitudeDelta, displacement*self.currentVisibleRegion.span.longitudeDelta))];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.centerCoordinate, MKCoordinateSpanMake(displacement*self.currentVisibleRegion.span.latitudeDelta, displacement*self.currentVisibleRegion.span.longitudeDelta))];
    }
}
@end
