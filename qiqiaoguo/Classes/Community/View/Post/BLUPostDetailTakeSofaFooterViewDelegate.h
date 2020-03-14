//
//  BLUPostDetailTakeSofaFooterViewDelegate.h
//  Blue
//
//  Created by Bowen on 6/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class BLUPostDetailTakeSofaFooterView;

@protocol BLUPostDetailTakeSofaFooterViewDelegate <NSObject>

- (void)footerViewNeedComment:(BLUPostDetailTakeSofaFooterView *)footerView;

@end
