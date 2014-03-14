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
        self.backgroundColor = [UIColor colorWithRed:0.307 green:0.244 blue:0.714 alpha:0.800];
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
    [_label setFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0]];
    [_label setNumberOfLines:2];
    [_label setLineBreakMode:NSLineBreakByWordWrapping];
//    [_label setAdjustsFontSizeToFitWidth:YES];
//    [_label setBackgroundColor:[UIColor redColor]];
    [self addSubview:_label];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.label setFrame:[self frameForLabel]];
    [self.label setFont:(self.isSelected) ? [UIFont fontWithName:@"HelveticaNeue" size:12.0] : [UIFont fontWithName:@"HelveticaNeue" size:10.0] ];
    [self.label setNeedsDisplay];
}

-(CGRect)frameForLabel
{
    CGFloat cornerRadius = (self.isSelected) ? self.selectedCornerRadius : self.originalCornerRadius;
    CGFloat xyOffset = ((sqrt(2)-1)*cornerRadius)/sqrt(2);
    CGFloat width = self.bounds.size.width-2*xyOffset;
    CGFloat height = self.bounds.size.height-2*xyOffset;
    return CGRectMake(xyOffset, xyOffset, width, height);
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self.label setText:self.labelText];
    [self.label setFrame:[self frameForLabel]];
    //couldn't get constraints to work :/
//    NSDictionary *view = NSDictionaryOfVariableBindings(_label);
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_label]-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:view]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_label]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:view]];
}


@end
