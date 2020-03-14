//
//  BLUSendPost2ViewModel.h
//  Blue
//
//  Created by Bowen on 9/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewModel.h"

UIKIT_EXTERN NSString * const BLUSendPostImageSpaceAttributedName;

@interface BLUSendPost2ViewModel : BLUViewModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSAttributedString *attributedContent;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL anonymous;
@property (nonatomic, assign) NSInteger circleID;
@property (nonatomic, strong) NSArray *tags;

- (RACCommand *)send;
- (RACSignal *)validatePost;

@end
