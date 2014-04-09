//
//  FSSMapView.h
//  Foursquare Search
//
//  Created by Deniz Aydemir on 4/8/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface FSSMapView : UIView

@property (nonatomic) MKMapView *mapView;
@property (nonatomic) CGFloat cornerRadius;


@end
