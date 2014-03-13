//
//  FSSLongPressMenuGestureRecognizer.h
//  Foursquare Search
//
//  Created by Deniz Aydemir on 3/10/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface FSSLongPressMenuGestureRecognizer : UIGestureRecognizer

@property (strong, nonatomic) NSArray *menuItemLocations;

-(id)initWithTarget:(id)target action:(SEL)action topLevelMenu:(NSArray*)topMenu;

@end
