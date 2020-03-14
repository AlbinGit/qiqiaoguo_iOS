//
//  SASearchIndexView.h
//  SaleAssistant
//
//  Created by Albin on 14-11-5.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "SAView.h"

typedef void(^SASearchIndexViewLabelClickBlock)(SALabel *label);

@interface SASearchIndexView : SAView

@property (nonatomic,strong)NSMutableArray *indexArray;

- (void)searchIndexViewLabelClick:(SASearchIndexViewLabelClickBlock)click;

@end
