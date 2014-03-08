//
//  UIVenueDetailView.h
//  Foursquare Search
//
//  Created by Deniz Aydemir on 2/1/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVenue.h"

@protocol UIVenueDetailViewDelegate <NSObject>

-(void)venueViewWillAppear;

@end


@interface UIVenueDetailView : UIView

@property (strong, nonatomic) UILabel *nameLabel, *categoryLabel, *tipsLabel, *checkInsLabel, *totalUsersLabel;

@property (strong, nonatomic) FSVenue *myVenue;


@property (weak, nonatomic) id<UIVenueDetailViewDelegate> delegate;

@end
