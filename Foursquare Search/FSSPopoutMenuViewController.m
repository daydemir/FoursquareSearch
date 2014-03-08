//
//  FSSPopoutMenuViewController.m
//  Foursquare Search
//
//  Created by Deniz Aydemir on 2/11/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import "FSSPopoutMenuViewController.h"
#import "FSSPopoutMenuView.h"

@interface FSSPopoutMenuViewController ()

@property (nonatomic) NSMutableArray *menuItemViews;

@end

@implementation FSSPopoutMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithMenuArray:(NSArray *)menu
{
    self = [super init];
    if (self) {
        _menu = menu;
        [self setup];
    }
    return self;
}

-(void) setup
{
    [self.view setBackgroundColor:[UIColor clearColor]];
    _menuItemViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < _menu.count; i++)
    {
        FSSPopoutMenuView *menuItem = [[FSSPopoutMenuView alloc] initWithFrame:CGRectMake((i+1)*12.0, (i+1)*12.0, 10, 10)];
        [_menuItemViews addObject:menuItem];
        [self.view addSubview:menuItem];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
