//
//  BLURatioButtonView.h
//  Blue
//
//  Created by Bowen on 5/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLURadioButtonView : UIView

@property (nonatomic, assign) NSInteger seletedIndex;

- (instancetype)initWithButtons:(NSArray *)buttons margin:(CGFloat)margin;

@end
