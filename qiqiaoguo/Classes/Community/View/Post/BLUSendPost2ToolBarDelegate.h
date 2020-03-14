//
//  BLUSendPost2ToolBarDelegate.h
//  Blue
//
//  Created by Bowen on 8/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLUSendPost2Toolbar;

@protocol BLUSendPost2ToolBarDelegate <NSObject>

- (void)toolbarShouldSelectImage:(BLUSendPost2Toolbar *)toolbar sender:(id)sender;
- (void)toolbarShouldSelectTag:(BLUSendPost2Toolbar *)toolbar sender:(id)sender;
- (void)toolbarDidSetAnonymous:(BOOL)anonymous toolbar:(BLUSendPost2Toolbar *)toolbar sender:(id)sender;
- (void)toolbarShouldHideKeyboard:(BLUSendPost2Toolbar *)toolbar sender:(id)sender;

@end
