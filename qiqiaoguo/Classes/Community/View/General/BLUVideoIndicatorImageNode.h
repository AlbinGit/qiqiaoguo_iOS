//
//  BLUVideoIndicatorImageNode.h
//  Blue
//
//  Created by Bowen on 4/3/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface BLUVideoIndicatorImageNode : ASNetworkImageNode

@property (nonatomic, strong) ASImageNode *videoIndicator;
@property (nonatomic, strong) ASDisplayNode *coverNode;

@property (nonatomic, assign) BOOL showVideoIndicator;

@end
