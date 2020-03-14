//
//  BLUPostCommentDetailAsyncViewModelDelegate.h
//  Blue
//
//  Created by Bowen on 25/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class BLUPostCommentDetailAsyncViewModel;
@class BLUComment;

@protocol BLUPostCommentDetailAsyncViewModelDelegate <NSObject>

- (void)viewModel:(BLUPostCommentDetailAsyncViewModel *)viewModel
 didChangeComment:(BLUComment *)comment;

- (void)viewModel:(BLUPostCommentDetailAsyncViewModel *)viewModel
     didMeetError:(NSError *)error;

- (void)viewModel:(BLUPostCommentDetailAsyncViewModel *)viewModel
didSuccessWithMessage:(NSString *)message;

@end
