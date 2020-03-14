//
//  BLUUserLevelComponentView
//  Blue
//
//  Created by Bowen on 12/11/15.
//  Copyright © 2015年 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLUUserLevelComponentView : UIView

@property (nonatomic, strong) UIImageView *floatIndicator;
@property (nonatomic, assign) NSInteger floatIndex;
@property (nonatomic, assign) CGFloat floatRatio;

@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UILabel *expLabel;

@property (nonatomic, strong) BLUSolidLine *leftLine;
@property (nonatomic, strong) BLUSolidLine *centerLine;
@property (nonatomic, strong) BLUSolidLine *rightLine;

@property (nonatomic, strong) UILabel *leftLevelLabel;
@property (nonatomic, strong) UILabel *centerLevelLabel;
@property (nonatomic, strong) UILabel *rightLevelLabel;

@property (nonatomic, strong) UILabel *leftExpLabel;
@property (nonatomic, strong) UILabel *centerExpLabel;
@property (nonatomic, strong) UILabel *rightExpLabel;

- (void)configWithLeftLevel:(NSInteger)leftLevel
                centerLevel:(NSInteger)centerLevel
                 rightLevel:(NSInteger)rightLevel
                    leftExp:(NSInteger)leftExp
                  centerExp:(NSInteger)centerExp
                   rightExp:(NSInteger)rightExp;

- (void)setUser:(BLUUser *)user levelSpecs:(NSArray *)specs;

+ (CGFloat)userLevelViewHeight;

@end
