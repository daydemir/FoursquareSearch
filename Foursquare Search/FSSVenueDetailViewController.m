//
//  FSSVenueDetailViewController.m
//  Foursquare Search
//
//  Created by Deniz Aydemir on 1/31/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import "FSSVenueDetailViewController.h"
#import "UIVenueDetailView.h"
#import "UIColor+FSSColors.h"

@interface FSSVenueDetailViewController ()


@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIVenueDetailView *venueContainerView;

@property (strong, nonatomic) NSMutableArray *venueViews;

@property (strong, nonatomic) FSVenue *currentVenue, *nextVenue, *previousVenue;

@property (nonatomic) int totalHeightOfContent, venueDetailViewHeight;

@end

@implementation FSSVenueDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.venueViews = [[NSMutableArray alloc] initWithCapacity:self.venues.count];
    for (int i = 0; i < self.venues.count; i++) {
        [self.venueViews addObject:[NSNull null]];
    }
//    [self.navigationController setNavigationBarHidden:YES];

    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setPagingEnabled:YES];
    [self.view addSubview:self.scrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.totalHeightOfContent = self.view.frame.size.height*self.venues.count;
    self.venueDetailViewHeight = self.totalHeightOfContent/self.venues.count;


    [self.scrollView setFrame:self.view.frame];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.totalHeightOfContent);
//    [self.scrollView setBackgroundColor:[UIColor purpleColor]];
    
    
    [self loadVisibleVenueViews];
    [self.scrollView setContentOffset:CGPointMake(0, self.selectedVenueIndex*self.venueDetailViewHeight)];
//    [self.scrollView scrollRectToVisible:CGRectMake(0, self.selectedVenueIndex*self.venueDetailViewHeight, self.scrollView.frame.size.width, self.venueContainerView.frame.size.height) animated:NO];
}

- (void)loadVisibleVenueViews
{
    for (int i = 0; i < self.venues.count; i++) {
        [self loadVenueView:i];

//        if(i >= self.selectedVenueIndex-1 && i <= self.selectedVenueIndex+1)
//            [self loadVenueView:i];
//        else
//            [self clearVenueView:i];
    }
}

- (void)clearVenueView:(int)index
{
//    UIView *view = [self.venueViews objectAtIndex:index];
//    [view removeFromSuperview];
    [self.venueViews setObject:[NSNull null] atIndexedSubscript:index];
}

- (void)loadVenueView:(int)index
{
    UIVenueDetailView *view = [[UIVenueDetailView alloc] initWithFrame:CGRectMake(0, (index)*self.venueDetailViewHeight+64, self.scrollView.contentSize.width, self.venueDetailViewHeight)];
    FSVenue *venue = [self.venues objectAtIndex:index];
    [view setMyVenue:venue];

//    view.backgroundColor = [UIColor colorWithRed:index/self.venues.count green:index/self.venues.count blue:index/self.venues.count alpha:1.0];
    [view setBackgroundColor:[UIColor softPurple]];
    [self.scrollView addSubview:view];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
