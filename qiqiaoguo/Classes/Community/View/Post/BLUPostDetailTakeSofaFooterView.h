//
//  BLUPostDetailTakeSofaFooterView.h
//  Blue
//
//  Created by Bowen on 6/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLUPostDetailTakeSofaFooterViewDelegate.h"

@interface BLUPostDetailTakeSofaFooterView : UIView

@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIView *solidLine;
@property (nonatomic, weak) id <BLUPostDetailTakeSofaFooterViewDelegate> delegate;

@end
