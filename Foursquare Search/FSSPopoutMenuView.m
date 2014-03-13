//
//  FSSPopoutMenuView.m
//  Foursquare Search
//
//  Created by Deniz Aydemir on 2/11/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import "FSSPopoutMenuView.h"

@interface FSSPopoutMenuView()

@property (strong, nonatomic) UILabel *label;

@end

@implementation FSSPopoutMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        [self.layer setCornerRadius:5];
        [self.layer setMasksToBounds:YES];
        [self setupLabel];
    }
    return self;
}

-(void)setupLabel
{
    _label = [[UILabel alloc] init];
    [_label setTextColor:[UIColor whiteColor]];
    [_label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_label];
    
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.label setFrame:self.bounds];
    [self.label setNeedsDisplay];
    
}



- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self.label setText:self.labelText];
    [self.label setFrame:self.bounds];
    //couldn't get constraints to work :/
//    NSDictionary *view = NSDictionaryOfVariableBindings(_label);
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_label]-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:view]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_label]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:view]];
}


@end
