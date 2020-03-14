//
//  BLUPostDetailToolbar.h
//  Blue
//
//  Created by Bowen on 29/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLUPostDetailToolbarDelegate.h"

@interface BLUPostDetailToolbar : UIToolbar

@property (nonatomic, strong) UIView *replyBackground;
@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, strong) UITapGestureRecognizer *replyRecognizer;

@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *othersButton;
@property (nonatomic, strong) UILabel *cornerMarker;
@property (nonatomic, assign) BOOL enabled;


@property (nonatomic, weak) id <BLUPostDetailToolbarDelegate> toolbarDelegate;

- (void)hideCornerMarker;
- (void)showCornerMarkerWithNumberofComments:(NSInteger)numberOfComments;

+ (CGFloat)toolbarHeight;

@end
