//
//  FSSViewController.m
//  Foursquare Search
//
//  Created by Deniz Aydemir on 1/31/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import "FSSViewController.h"
#import "FSSVenuesViewController.h"
#import "FSSMapView.h"

@interface FSSViewController ()

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) UIPickerView *radiusPicker, *limitPicker;
@property (strong, nonatomic) FSSVenuesViewController *venuesListViewController;
@property (nonatomic) FSSMapView *mapView;

@end

@implementation FSSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.searchButton setTitle:@"GO!" forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(searchTapped) forControlEvents:UIControlEventTouchUpInside];
    self.mapView = [[FSSMapView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height*.8)];
    [self.view addSubview:self.searchButton];
    [self.view addSubview:self.mapView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.searchButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.mapView attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)searchTapped
{
    [self performSegueWithIdentifier:@"showVenues" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showVenues"]){
        self.venuesListViewController = [[FSSVenuesViewController alloc] init];
        self.venuesListViewController = segue.destinationViewController;
    }
}


@end
