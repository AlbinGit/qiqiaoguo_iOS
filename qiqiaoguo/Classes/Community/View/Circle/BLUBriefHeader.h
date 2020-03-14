//
//  BLUCircleBriefHeader.h
//  Blue
//
//  Created by Bowen on 3/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat BLUBriefHeaderHeight;

@interface BLUBriefHeader : UITableViewHeaderFooterView

@property (nonatomic, strong) BLUSolidLine *separateLine;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UILabel *titleLabel;

@end
