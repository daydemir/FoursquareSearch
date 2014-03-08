//
//  FSSPopoutMenuViewController.h
//  Foursquare Search
//
//  Created by Deniz Aydemir on 2/11/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSSPopoutMenuViewController : UIViewController

@property (nonatomic) NSArray *menu;

-(id)initWithMenuArray:(NSArray *)menu;


@end
