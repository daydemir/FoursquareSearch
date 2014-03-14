//
//  FSSPopoutMenuView.h
//  Foursquare Search
//
//  Created by Deniz Aydemir on 2/11/14.
//  Copyright (c) 2014 Deniz Aydemir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSSPopoutMenuView : UIView

@property (nonatomic) NSString *labelText;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) CGRect originalFrame, selectedFrame;
@property (nonatomic) CGFloat originalCornerRadius, selectedCornerRadius;

@end
