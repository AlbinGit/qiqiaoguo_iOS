//
//  SATextField.h
//  ToysOnline
//
//  Created by Albin on 14-8-20.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SATextField : UITextField

@property (nonatomic,strong)NSIndexPath *indexPath;
- (void)addInputAccessoryView;

@end
