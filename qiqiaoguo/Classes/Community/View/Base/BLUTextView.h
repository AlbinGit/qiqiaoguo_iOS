//
//  BLUTextView.h
//  Blue
//
//  Created by Bowen on 8/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLUTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) UIColor *placeholderTextColor;

- (CGRect)placeholderRectForBounds:(CGRect)bounds;

@end
