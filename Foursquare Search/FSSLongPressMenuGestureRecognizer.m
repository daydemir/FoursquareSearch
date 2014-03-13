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
    }
    return self;
}


- (void)ignoreTouch:(UITouch*)touch forEvent:(UIEvent*)event // if a touch isn't part of this gesture it can be passed to this method to be ignored. ignored touches won't be cancelled on the view even if cancelsTouchesInView is YES
{
    
}


- (void)reset
{
    self.menuItems = self.topMenuItems;
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
    NSLog(@"SELECTED!!!");
    [self showSubMenu];
}

-(void)selectedItem:(FSSPopoutMenuView*)menuItem
{
    
}

-(void)showSubMenu
{
    [self dismissMenu];
    FSSMenuItem *selectedMenuItem = [self.menu objectForKey:[NSValue valueWithNonretainedObject:self.currentlySelectedMenuItemView]];
    self.menuItems = selectedMenuItem.subMenuItems;
    [self showMenu];
}

-(void)showMenu
{
    CGPoint initialLocation = self.initialLocation;
    self.menu = [[NSMutableDictionary alloc] init];
    self.menuItemViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.menuItems.count; i++)
    {
        FSSMenuItem *menuItem = [self.menuItems objectAtIndex:i];
        CGRect frame = CGRectMake((initialLocation.x+30), (initialLocation.y)+i*50, 100, 30);
        FSSPopoutMenuView *menuItemView = [[FSSPopoutMenuView alloc] initWithFrame:frame];
        [menuItemView setOriginalFrame:frame];
        [menuItemView setSelectedFrame:CGRectMake(menuItemView.frame.origin.x-5, menuItemView.frame.origin.y-5, menuItemView.frame.size.width+10, menuItemView.frame.size.height+10)];
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
        [self.currentlySelectedMenuItemView setFrame:self.currentlySelectedMenuItemView.originalFrame];
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
        [selectedItem setFrame:selectedItem.selectedFrame];
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


- (CGFloat)distanceBetweenPointOne:(CGPoint)point1 pointTwo:(CGPoint)point2
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
};


#pragma mark -
#pragma mark Touches

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
