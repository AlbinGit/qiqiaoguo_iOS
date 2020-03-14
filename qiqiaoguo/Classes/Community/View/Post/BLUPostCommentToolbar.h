//
//  BLUPostCommentToolBar.h
//  Blue
//
//  Created by Bowen on 12/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLUPostCommentToolbar;

@protocol BLUPostCommentToolbarDelegate <NSObject>

@required
- (void)toolbar:(BLUPostCommentToolbar *)toolbar didSendComment:(NSString *)comment;

@end

@interface BLUPostCommentToolbar : UIToolbar

@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, weak) id <BLUPostCommentToolbarDelegate> postCommentToolbarDelegate;

@end
