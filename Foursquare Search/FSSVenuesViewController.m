//
//  FSSVenuesViewController.m
//  Foursquare Search
//
//  Created by Deniz Aydemir on 1/31/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import "FSSVenuesViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Foursquare2.h"
#import "FSSVenue.h"
#import "FSSVenueDetailViewController.h"
#import "FSSPopoutMenuViewController.h"
#import "FSSPopoutMenuView.h"
#import "FSSLongPressMenuGestureRecognizer.h"
#import "FSSMenuItem.h"

@interface FSSVenuesViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UITableView *VenuesTableView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *myLocation;
@property (strong, nonatomic) NSMutableArray *venues;

@property (nonatomic) int selectedVenueIndex;
@property (strong, nonatomic) FSVenue *selectedVenue;
@property (strong, nonatomic) FSSVenueDetailViewController *detailViewController;
@property (strong, nonatomic) FSSPopoutMenuViewController *menuVC;

@property (nonatomic) NSMutableArray *menuItemViews;
@property (nonatomic) NSArray *menu;






@end

@implementation FSSVenuesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.venues = [[NSMutableArray alloc] init];
    [Foursquare2 setupFoursquareWithClientId:@"OM1NKM2RUG1AEWDGCY2Q4EYJ1VL3VABTCSSMNOYFGJXP2LCT" secret:@"M3XFABJGDIOFMFBTZ5MZ1HQTHVRXMHIN423YO2BQTABHPKQ5" callbackURL:@"foursearch://foursquare"];
    [self.VenuesTableView setDataSource:self];
    [self.VenuesTableView setDelegate:self];
    [self.locationManager setDelegate:self];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startMonitoringSignificantLocationChanges];
//    [self.locationManager startUpdatingLocation];
    [self.VenuesTableView setHidden:YES];
    self.limit = [NSNumber numberWithInt:50];
    self.radius = [NSNumber numberWithInt:10000];
    
    FSSMenuItem *item1 = [[FSSMenuItem alloc] init];
    FSSMenuItem *item2 = [[FSSMenuItem alloc] init];
    FSSMenuItem *item3 = [[FSSMenuItem alloc] init];
    FSSMenuItem *item4 = [[FSSMenuItem alloc] init];
    FSSMenuItem *item5 = [[FSSMenuItem alloc] init];
    FSSMenuItem *subItem1 = [[FSSMenuItem alloc] init];
    FSSMenuItem *subItem2 = [[FSSMenuItem alloc] init];
    FSSMenuItem *subItem3 = [[FSSMenuItem alloc] init];
    FSSMenuItem *subItem4 = [[FSSMenuItem alloc] init];
    FSSMenuItem *subItem5 = [[FSSMenuItem alloc] init];
    [item1 setName:@"First"];
    [item2 setName:@"Share >"];
    [item3 setName:@"Third"];
    [item4 setName:@"FOURTH"];
    [item5 setName:@"DA fif"];
    
    [subItem1 setName:@"Email"];
    [subItem2 setName:@"Message"];
    [subItem3 setName:@"To-Do"];
    [subItem4 setName:@"Favorites List"];
    [subItem5 setName:@"WOAH"];
    
    [item2 setHasSubMenu:YES];
    [item3 setHasSubMenu:YES];
    [item2 setSubMenuItems:[NSArray arrayWithObjects:subItem1, subItem2, nil]];
    [item3 setSubMenuItems:[NSArray arrayWithObjects:subItem3, subItem4, subItem5, nil]];
    

    
    NSArray *items = [[NSArray alloc] initWithObjects:item1, item2, item3, item4, item5, nil];
    
    FSSLongPressMenuGestureRecognizer *lpgr = [[FSSLongPressMenuGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:) topLevelMenu:items];
    lpgr.delegate = self;
    [self.VenuesTableView addGestureRecognizer:lpgr];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getVenues
{
    [Foursquare2 venueSearchNearByLatitude:[NSNumber numberWithDouble:self.myLocation.coordinate.latitude] longitude:[NSNumber numberWithDouble:self.myLocation.coordinate.longitude] query:self.query limit:self.limit intent:intentBrowse radius:self.radius categoryId:nil callback:^(BOOL success, id result){
        if(success && [result isKindOfClass:[NSDictionary class]])
        {
            self.venues = [self parseSearchVenuesResultsDictionary:result];
            [self.VenuesTableView reloadData];
            [self.VenuesTableView setHidden:NO];
        }
    }];
    
    
}

- (NSMutableArray*)parseSearchVenuesResultsDictionary:(NSDictionary*)result{
    NSLog(@"%@", [result description]);
    NSArray *groupsArray = [[result objectForKey:@"response"] objectForKey:@"venues"];
    if([groupsArray count] > 0){
        
        NSMutableArray *resultArray = [NSMutableArray array];
        for (NSDictionary *venue in groupsArray){
//            NSLog(@"%@", [venue description]);
            //Get Stats details
//            NSLog(@"%@", [groupsArray description]);
            
            [resultArray addObject:[self createVenueFromDictionary:venue]];
//
//          [resultArray addObject:resultDictionary];

        }

        return resultArray;
    }
    return [NSMutableArray array];
}

- (FSVenue*)createVenueFromDictionary:(NSDictionary*)result
{
    FSVenue *newVenue = [[FSVenue alloc] init];
    [newVenue setName:[result objectForKey:@"name"]];
    [newVenue setVenueId:[result objectForKey:@"id"]];
    
    //category
    NSArray *category = [result objectForKey:@"categories"];
//    if (category[0]) {
//        [newVenue setCategory:[category[0] objectForKey:@"name"]];
//    }
    
    //stats
    NSDictionary *stats = [result objectForKey:@"stats"];
    NSString *checkInsCount = [stats objectForKey:@"checkinsCount"];
    if (checkInsCount) [newVenue setCheckInsCount:[checkInsCount integerValue]];
    NSString *tipCount = [stats objectForKey:@"tipCount"];
    if (tipCount) [newVenue setTipCount:[tipCount integerValue]];
    NSString *usersCount = [stats objectForKey:@"usersCount"];
    if (usersCount) [newVenue setUsersCount:[usersCount integerValue]];


    return newVenue;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showVenue"])
    {
        self.detailViewController = segue.destinationViewController;
        [self.detailViewController setVenues:self.venues];
        [self.detailViewController setSelectedVenueIndex:self.selectedVenueIndex];


    }
}

//CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.myLocation = locations[0];
    NSTimeInterval howRecent = [[self.myLocation timestamp] timeIntervalSinceNow];
    if (abs(howRecent)>15.0) {
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
    else {
        [self.locationManager stopUpdatingLocation];
    }
    [self getVenues];
}

//Table view data source

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
//    [cell setBackgroundColor:[UIColor yellowColor]];
    FSVenue *venue = [self.venues objectAtIndex:indexPath.row];
    [cell.textLabel setText:venue.name];
    return cell;
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.venues.count;
}

//Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedVenue = [self.venues objectAtIndex:indexPath.row];
    self.selectedVenueIndex = indexPath.row;
    [self performSegueWithIdentifier:@"showVenue" sender:self];

}


//Gesture Recognizer delegate
-(void) handleLongPress:(UILongPressGestureRecognizer*)gestureRecognizer
{
    
}







@end
