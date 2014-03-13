//
//  FSSLongPressMenuGestureRecognizer.m
//  Foursquare Search
//
//  Created by Deniz Aydemir on 3/10/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import "FSSLongPressMenuGestureRecognizer.h"
#import "FSSPopoutMenuView.h"

@interface FSSLongPressMenuGestureRecognizer()

@property (nonatomic) NSTimeInterval previousTouchTime;
@property (strong, nonatomic) NSTimer *touchTimer;
@property (nonatomic) UITouch *initialTouch;
@property (nonatomic) CGPoint initialLocation;
@property (nonatomic) NSMutableArray *menuItems, *menuItemViews;

@end

@implementation FSSLongPressMenuGestureRecognizer

-(id)initWithTarget:(id)target action:(SEL)action
{
    return [self initWithTarget:target action:action topLevelMenu:[NSArray array]];
}

-(id)initWithTarget:(id)target action:(SEL)action topLevelMenu:(NSArray*)topMenu
{
    self = [super initWithTarget:target action:action];
    if(self) {
        _menuItems = [[NSMutableArray alloc] initWithArray:topMenu];
    }
    return self;
}


- (void)ignoreTouch:(UITouch*)touch forEvent:(UIEvent*)event // if a touch isn't part of this gesture it can be passed to this method to be ignored. ignored touches won't be cancelled on the view even if cancelsTouchesInView is YES
{
    
}


- (void)reset
{
    
}

- (BOOL)shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (otherGestureRecognizer.class == [UITapGestureRecognizer class]) {
        return YES;
    }
    return NO;
}
- (BOOL)shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (otherGestureRecognizer.class == [UITapGestureRecognizer class]) {
        return YES;
    }
    return NO;
}

-(void)startTouchTimer {
    self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(timerEndedWithoutStop)
                                                userInfo:nil repeats:NO];
}

-(void)stopTouchTimer {
    [self.touchTimer invalidate];
    [self setState:UIGestureRecognizerStateFailed];
    
    
}

-(void)timerEndedWithoutStop {
    [self showMenu];
    
}

-(void)showMenu
{
    [self setState:UIGestureRecognizerStateBegan];
    CGPoint initialLocation = [self.initialTouch locationInView:self.view];
    for (int i = 0; i < self.menuItems.count; i++)
    {
        FSSPopoutMenuView *menuItemView = [[FSSPopoutMenuView alloc] initWithFrame:CGRectMake((initialLocation.x+30), (initialLocation.y)+i*15, 10, 10)];
        [self.view addSubview:menuItemView];
        [self.menuItemViews addObject:menuItemView];
    }
}

-(void)dismissMenu
{
    for (FSSPopoutMenuView *menuItem in self.menuItemViews)
    {
        [menuItem removeFromSuperview];
    }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self startTouchTimer];
    self.menuItemViews = [[NSMutableArray alloc] init];
    UITouch *touch = [touches anyObject];
    self.initialTouch = touch;
    self.initialLocation = [touch locationInView:self.view];
    NSTimeInterval time = touch.timestamp;
    NSLog(@"%f",time);
    [self setState:UIGestureRecognizerStatePossible];
    self.previousTouchTime = time;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    NSTimeInterval time = touch.timestamp;
    if (self.state != UIGestureRecognizerStateBegan){
        NSLog(@"%f",time);
        float timeDiff = time-self.previousTouchTime;
        if( timeDiff < 1) {
            CGFloat displacement = [self distanceBetweenPointOne:self.initialLocation pointTwo:location];
            if( displacement < 10) {
                [self setState:UIGestureRecognizerStatePossible];
            }
            else {
                [self stopTouchTimer];
            }
        }
    }
    self.previousTouchTime = time;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self stopTouchTimer];
    UITouch *touch = [touches anyObject];
    //add check to see if touch was lifted up inside of menu item
    [self dismissMenu];


    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

       
- (CGFloat)distanceBetweenPointOne:(CGPoint)point1 pointTwo:(CGPoint)point2
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
};



@end
