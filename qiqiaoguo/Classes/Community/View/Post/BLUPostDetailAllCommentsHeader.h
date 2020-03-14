//
//  BLUPostDetailAllCommentsHeader.h
//  Blue
//
//  Created by Bowen on 29/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLUPostDetailAllCommentsHeaderDelegate.h"

@interface BLUPostDetailAllCommentsHeader : UIToolbar

@property (nonatomic, strong) UILabel *commentsLabel;
@property (nonatomic, strong) UIButton *orderButton;
@property (nonatomic, strong) NSString *descTitle;
@property (nonatomic, strong) NSString *ascTitle;
@property (nonatomic, assign) BOOL commentsReverse;

@property (nonatomic, weak) id <BLUPostDetailAllCommentsHeaderDelegate> headerDelegate;

@end
