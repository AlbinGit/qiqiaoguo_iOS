//
//  BLUPostDetailLikedUserNode.m
//  Blue
//
//  Created by Bowen on 22/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailLikedUserNode.h"

@implementation BLUPostDetailLikedUserNode

- (instancetype)initWithUser:(BLUUser *)user {
    if (self = [super init]) {
        BLUAssertObjectIsKindOfClass(user, [BLUUser class]);

        _avatarNode = [[ASNetworkImageNode alloc] initWithWebImage];
        _avatarNode.URL = user.avatar.thumbnailURL;
        _avatarNode.backgroundColor = BLUThemeSubTintBackgroundColor;
        _avatarNode.clipsToBounds = YES;

        [self addSubnode:_avatarNode];
    }
    return self;
}


- (void)layout {
    [super layout];
    _avatarNode.frame = self.bounds;
    _avatarNode.cornerRadius = self.calculatedSize.height / 2.0;
}

@end
