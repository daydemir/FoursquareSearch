//
//  FSSViewController.m
//  Foursquare Search
//
//  Created by Deniz Aydemir on 1/31/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import "FSSViewController.h"

@interface FSSViewController ()

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) UIPickerView *radiusPicker, *limitPicker;
@property (strong, nonatomic) UITableViewController *venuesListViewController;

@end

@implementation FSSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.venuesListViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.searchButton setTitle:@"Find My Food" forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(searchTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchButton];
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
        self.venuesListViewController = segue.destinationViewController;
    }
}


@end
