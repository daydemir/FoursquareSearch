//
//  FSSDoubleTapAndPanMapGestureRecognizer.m
//  Foursquare Search
//
//  Created by Deniz Aydemir on 4/9/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import "FSSDoubleTapAndPanGestureRecognizer.h"

@interface FSSDoubleTapAndPanGestureRecognizer()

@property (nonatomic) CGPoint secondTapPoint;

@end

@implementation FSSDoubleTapAndPanGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *thisTouch = [touches anyObject];
//    if (!self.firstTap) {
//        self.firstTap = thisTouch;
//    }
//    else if(!self.secondTap && thisTouch.timestamp - self.firstTap.timestamp <= 1 && thisTouch.tap) {
//        self.secondTap = thisTouch;
//        [self setState:UIGestureRecognizerStateBegan];
//    }
//    else {
//        [self setState:UIGestureRecognizerStateFailed];
//    }
    if (thisTouch.tapCount == 2) {
        [self setState:UIGestureRecognizerStateBegan];
        self.secondTapPoint = [thisTouch locationInView:self.view];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        CGPoint currentPoint = [[touches anyObject] locationInView:self.view];
        self.displacement = self.secondTapPoint.y - currentPoint.y;
        [self setState:UIGestureRecognizerStateChanged];
    }
    else {
        [self setState:UIGestureRecognizerStateCancelled];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.state == UIGestureRecognizerStateBegan) {
        [self setState:UIGestureRecognizerStateCancelled];
    }
    if(self.state == UIGestureRecognizerStateChanged) {
        CGPoint currentPoint = [[touches anyObject] locationInView:self.view];
        self.displacement = self.secondTapPoint.y - currentPoint.y;
        [self setState:UIGestureRecognizerStateEnded];
    }
    else {
        [self setState:UIGestureRecognizerStateFailed];
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self setState:UIGestureRecognizerStateCancelled];
}

@end
