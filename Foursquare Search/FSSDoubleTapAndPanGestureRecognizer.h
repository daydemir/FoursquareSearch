//
//  FSSDoubleTapAndPanMapGestureRecognizer.h
//  Foursquare Search
//
//  Created by Deniz Aydemir on 4/9/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface FSSDoubleTapAndPanGestureRecognizer : UIGestureRecognizer

@property (nonatomic) CGFloat displacement;

- (id)initWithTarget:(id)target action:(SEL)action;

@end
