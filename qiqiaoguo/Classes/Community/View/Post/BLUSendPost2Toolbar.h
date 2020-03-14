//
//  BLUSendPost2ToolBar.h
//  Blue
//
//  Created by Bowen on 1/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLUSendPost2ToolBarDelegate.h"

@interface BLUSendPost2Toolbar : UIToolbar

@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIButton *tagButton;
@property (nonatomic, strong) UIButton *anonymousButton;
@property (nonatomic, strong) UIButton *keyboardButton;

@property (nonatomic, weak) id <BLUSendPost2ToolBarDelegate> sendPost2ToolbarDelegate;

@end
