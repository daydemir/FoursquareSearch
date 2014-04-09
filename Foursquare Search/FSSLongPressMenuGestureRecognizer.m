//
//  FSSLongPressMenuGestureRecognizer.m
//  Foursquare Search
//
//  Created by Deniz Aydemir on 3/10/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import "FSSLongPressMenuGestureRecognizer.h"
#import "FSSPopoutMenuView.h"
#import "FSSMenuItem.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


@interface FSSLongPressMenuGestureRecognizer()

@property (nonatomic) NSTimeInterval previousTouchTime;
@property (strong, nonatomic) NSTimer *touchTimer;
@property (nonatomic) UITouch *initialTouch;
@property (nonatomic) CGPoint initialLocation;
@property (nonatomic) NSArray *menuItems, *topMenuItems;
@property (nonatomic) NSMutableArray *menuItemViews;
@property (nonatomic) FSSPopoutMenuView *currentlySelectedMenuItemView;
@property (nonatomic) FSSMenuItem *selectedMenuItem;
@property (nonatomic) NSMutableDictionary *menu;
@property (nonatomic) CGFloat menuItemViewSide, menuItemViewMargins, menuItemDistanceToFinger;
@property (nonatomic) int subMenuCount;

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
        _topMenuItems = topMenu;
        _menuItemViewSide = 60;
        _menuItemViewMargins = 10;
        _menuItemDistanceToFinger = 100;
    }
    return self;
}


- (void)ignoreTouch:(UITouch*)touch forEvent:(UIEvent*)event// if a touch isn't part of this gesture it can be passed to this method to be ignored. ignored touches won't be cancelled on the view even if cancelsTouchesInView is YES
{
    
}


- (void)reset
{
    self.menuItems = self.topMenuItems;
    _subMenuCount = 0;
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

#pragma mark -
#pragma mark Timers

-(void)startInitialTouchTimer {
    self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(initialTouchTimerEndedWithoutStop)
                                                     userInfo:nil repeats:NO];
}

-(void)stopInitialTouchTimer {
    [self.touchTimer invalidate];
    [self setState:UIGestureRecognizerStateFailed];
    
    
}

-(void)initialTouchTimerEndedWithoutStop {
    [self setState:UIGestureRecognizerStateBegan];
    [self showMenu];
    
}

-(void)startSelectionTouchTimer {
    self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(selectionTouchTimerEndedWithoutStop)
                                                     userInfo:nil repeats:NO];
}

-(void)stopSelectionTouchTimer {
    [self.touchTimer invalidate];
}

-(void)selectionTouchTimerEndedWithoutStop {
    NSLog(@"SHOW SUBMENU!!!");
    [self showSubMenu];
}

-(void)selectedItem:(FSSPopoutMenuView*)menuItem
{
    
}

#pragma mark - 
#pragma mark Menu Methods

-(CGRect)menuItemViewRectForItemNumber:(int)viewNum ofTotal:(int)totalNum
{
    int indexOfLastView = totalNum-1;
//    CGFloat fingerBuffer = self.menuItemDistanceToFinger;
//    CGFloat totalHeightOfMenu = totalNum*self.menuItemViewSide + (totalNum-1)*self.menuItemViewMargins;
//    CGFloat yOrigin = self.initialLocation.y - totalHeightOfMenu/2 + viewNum*(self.menuItemViewSide+self.menuItemViewMargins);
//    CGFloat xCurveOffset = (fabsf(viewNum - indexOfLastView/2.0)/indexOfLastView) * self.menuItemDistanceToFinger * totalNum;
//    CGFloat xOffset = (self.subMenuCount%2==1) ? -1*fingerBuffer*totalNum + xCurveOffset : fingerBuffer*totalNum - xCurveOffset;
//    CGFloat xOrigin = self.initialLocation.x+xOffset;
//    
//    return CGRectMake(xOrigin, yOrigin, self.menuItemViewSide, self.menuItemViewSide);
    float angleDegrees;
    CGFloat xPullBack = 0;
    if (totalNum < 3) {
        angleDegrees = 45;
    }
    if(totalNum < 4 ) {
        angleDegrees = 90;
        xPullBack = self.menuItemDistanceToFinger/2;
    }
    else if ( totalNum < 6) {
        angleDegrees = 140;
        xPullBack = self.menuItemDistanceToFinger/2;
    }
    else {
        angleDegrees = 180;
    }
    angleDegrees = angleDegrees * ((viewNum - indexOfLastView/2.0)/indexOfLastView);

    CGFloat xCenterOffset;
    if(self.subMenuCount%2 == 1) {
        xCenterOffset = cosf(DEGREES_TO_RADIANS(angleDegrees))*self.menuItemDistanceToFinger*-1;
        xCenterOffset += xPullBack;
    }
    else {
        xCenterOffset = cosf(DEGREES_TO_RADIANS(angleDegrees))*self.menuItemDistanceToFinger;
        xCenterOffset -= xPullBack;
    }
    
    //pull back the items
    CGFloat yCenterOffset = sinf(DEGREES_TO_RADIANS(angleDegrees))*self.menuItemDistanceToFinger;
    
    CGFloat xOrigin = self.initialLocation.x+xCenterOffset-self.menuItemViewSide/2;
    CGFloat yOrigin = self.initialLocation.y+yCenterOffset-self.menuItemViewSide/2;
    
    return CGRectMake(xOrigin, yOrigin, self.menuItemViewSide, self.menuItemViewSide);
}

-(void)showSubMenu
{
    [self dismissMenu];
    self.subMenuCount++;
    FSSMenuItem *selectedMenuItem = [self.menu objectForKey:[NSValue valueWithNonretainedObject:self.currentlySelectedMenuItemView]];
    self.menuItems = selectedMenuItem.subMenuItems;
    [self showMenu];
}

-(void)showMenu
{
    self.menu = [[NSMutableDictionary alloc] init];
    self.menuItemViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.menuItems.count; i++)
    {
        FSSMenuItem *menuItem = [self.menuItems objectAtIndex:i];
        CGRect frame = [self menuItemViewRectForItemNumber:i ofTotal:(int)self.menuItems.count];
        FSSPopoutMenuView *menuItemView = [[FSSPopoutMenuView alloc] initWithFrame:frame];
        [menuItemView.layer setCornerRadius:self.menuItemViewSide/2];
        [menuItemView setOriginalFrame:frame];
        [menuItemView setOriginalCornerRadius:self.menuItemViewSide/2];
        [menuItemView setSelectedFrame:CGRectMake(menuItemView.frame.origin.x-5, menuItemView.frame.origin.y-5, menuItemView.frame.size.width+10, menuItemView.frame.size.height+10)];
        [menuItemView setSelectedCornerRadius:self.menuItemViewSide/2+5];
        [menuItemView setLabelText:menuItem.name];
        [self.view addSubview:menuItemView];
        [self.menuItemViews addObject:menuItemView];
        NSValue *keyMenuItemView = [NSValue valueWithNonretainedObject:menuItemView];
        [self.menu setObject:menuItem forKey:keyMenuItemView];
    }
}

-(void)dismissMenu
{
    for (FSSPopoutMenuView *menuItem in self.menuItemViews)
    {
        [menuItem removeFromSuperview];
    }
}


-(void)touchMovedToLocation:(CGPoint)location
{
    FSSPopoutMenuView *selectedItem = [self menuItemBeingTouched:location];
    if (self.currentlySelectedMenuItemView != selectedItem) {
        [self stopSelectionTouchTimer];
        self.currentlySelectedMenuItemView.isSelected = NO;
        [self animateMenuItemView:self.currentlySelectedMenuItemView isSelected:NO];
        self.currentlySelectedMenuItemView = selectedItem;
    }
    if (selectedItem && !selectedItem.isSelected) {
        NSValue *keySelectedItem = [NSValue valueWithNonretainedObject:selectedItem];
        FSSMenuItem *menuItem = [self.menu objectForKey:keySelectedItem];
        if (menuItem.hasSubMenu) {
            [self startSelectionTouchTimer];
        }
        selectedItem.isSelected = YES;
        self.currentlySelectedMenuItemView = selectedItem;
        [self animateMenuItemView:self.currentlySelectedMenuItemView isSelected:YES];

    }
}

-(FSSPopoutMenuView*)menuItemBeingTouched:(CGPoint)location
{
    for (FSSPopoutMenuView *menuItemView in self.menuItemViews) {
        if (CGRectContainsPoint(menuItemView.frame, location)) {
            return menuItemView;
        }
    }
    return nil;
}

-(void)animateMenuItemView:(FSSPopoutMenuView*)menuItemView isSelected:(BOOL)selected
{
    if(selected){
        [menuItemView setFrame:menuItemView.selectedFrame];
        [menuItemView.layer setCornerRadius:menuItemView.selectedCornerRadius];
    }
    else {
        [menuItemView setFrame:menuItemView.originalFrame];
        [menuItemView.layer setCornerRadius:menuItemView.originalCornerRadius];
    }
}



#pragma mark -
#pragma mark Touches

- (CGFloat)distanceBetweenPointOne:(CGPoint)point1 pointTwo:(CGPoint)point2
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
};

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self startInitialTouchTimer];
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
    if (self.state != UIGestureRecognizerStateBegan && self.state != UIGestureRecognizerStateChanged){
        NSLog(@"%f",time);
        float timeDiff = time-self.initialTouch.timestamp;
        if( timeDiff < 1) {
            CGFloat displacement = [self distanceBetweenPointOne:self.initialLocation pointTwo:location];
            if( displacement < 10) {
                [self setState:UIGestureRecognizerStatePossible];
            }
            else {
                [self stopInitialTouchTimer];
            }
        }
        else {
            [self setState:UIGestureRecognizerStateBegan];
        }
    }
    else {
        [self touchMovedToLocation:location];
    }
    self.previousTouchTime = time;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.state == UIGestureRecognizerStatePossible) {
        [self stopInitialTouchTimer];
        [self setState:UIGestureRecognizerStateFailed];
    }
    else if(self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        UITouch *touch = [touches anyObject];
        //add check to see if touch was lifted up inside of menu item
        [self touchMovedToLocation:[touch locationInView:self.view]];
        if (self.currentlySelectedMenuItemView) {
            self.selectedMenuItem = [self.menu objectForKey:[NSValue valueWithNonretainedObject:self.currentlySelectedMenuItemView]];
            [self setState:UIGestureRecognizerStateRecognized];
        }
    }
    
    [self setState:UIGestureRecognizerStateCancelled];
    [self dismissMenu];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self setState:UIGestureRecognizerStateCancelled];
}


@end
