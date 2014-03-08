//
//  UIVenueDetailView.m
//  Foursquare Search
//
//  Created by Deniz Aydemir on 2/1/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import "UIVenueDetailView.h"

@implementation UIVenueDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.nameLabel = [[UILabel alloc] init];
        self.categoryLabel = [[UILabel alloc] init];
        self.tipsLabel = [[UILabel alloc] init];
        self.checkInsLabel = [[UILabel alloc] init];
        self.totalUsersLabel = [[UILabel alloc] init];

    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    //    self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 100)];
    //    self.tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 100, 100)];
    //    self.checkInsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 100, 100)];
    //    self.totalUsersLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, 100, 100)];
    [self.delegate venueViewWillAppear];
    
    [self.nameLabel setText:self.myVenue.name];
    [self.categoryLabel setText:self.myVenue.category];
    [self.tipsLabel setText:[NSString stringWithFormat:@"%li", (long)self.myVenue.tipCount]];
    [self.checkInsLabel setText:[NSString stringWithFormat:@"%li",(long)self.myVenue.checkInsCount]];
    [self.totalUsersLabel setText:[NSString stringWithFormat:@"%li",(long)self.myVenue.usersCount]];
    
    
    [self.nameLabel setFrame:CGRectMake(0, 0, 100, 50)];
    [self.categoryLabel setFrame:CGRectMake(0, 50, 100, 50)];
    [self.tipsLabel setFrame:CGRectMake(0, 200, 100, 50)];
    [self.checkInsLabel setFrame:CGRectMake(0, 250, 100, 50)];
    [self.totalUsersLabel setFrame:CGRectMake(0, 300, 100, 50)];
    

    
    [self addSubview:self.nameLabel];
    [self addSubview:self.categoryLabel];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.checkInsLabel];
    [self addSubview:self.totalUsersLabel];

}


- (void)viewWillAppear
{
    
    
    
    
}

@end
