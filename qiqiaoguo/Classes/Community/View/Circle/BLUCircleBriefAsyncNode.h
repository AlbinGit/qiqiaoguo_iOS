//
//  BLUCircleBriefAsyncNode.h
//  Blue
//
//  Created by Bowen on 28/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "ASCellNode.h"
#import "BLUCircleBriefAsyncNodeDelegate.h"

@class BLUCircle;

@interface BLUCircleBriefAsyncNode : ASCellNode

@property (nonatomic, strong) ASNetworkImageNode *circleImageNode;
@property (nonatomic, strong) ASDisplayNode *circleBackground;
@property (nonatomic, strong) ASTextNode *slogonNode;
@property (nonatomic, strong) ASTextNode *nameNode;
@property (nonatomic, strong) ASDisplayNode *leftLine;
@property (nonatomic, strong) ASDisplayNode *rightLine;
@property (nonatomic, strong) ASTextNode *joinNode;
@property (nonatomic, strong) ASDisplayNode *joinBackground;
@property (nonatomic, weak) id <BLUCircleBriefAsyncNodeDelegate> delegate;

@property (nonatomic, strong) BLUCircle *circle;

- (instancetype)initWithCircle:(BLUCircle *)circle;

@end

@interface BLUCircleBriefAsyncNode (Text)

- (NSAttributedString *)attributedSlogon:(NSString *)slogon;
- (NSAttributedString *)attributedName:(NSString *)name;
- (NSAttributedString *)attributedJoin:(BOOL)didJoin;

@end
