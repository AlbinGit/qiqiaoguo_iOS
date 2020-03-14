//
//  BLUMessageCategoryMO.m
//  
//
//  Created by Bowen on 1/11/2015.
//
//

#import "BLUMessageCategoryMO.h"
#import "BLUMessageCategory.h"

NSString * BLUMessageCategoryMOKeyType = @"type";
NSString * BLUMessageCategoryMOKeyMasterUserID = @"masterUserID";

@implementation BLUMessageCategoryMO

- (void)configWithMessageCategory:(BLUMessageCategory *)messageCategory {
    self.type = @(messageCategory.type);
    self.content = messageCategory.content;
    self.lastTime = messageCategory.lastTime;
    self.unreadCount = @(messageCategory.unreadCount);
    if (messageCategory.targetUser) {
        self.targetUserID = @(messageCategory.targetUser.userID);
        self.targetUserNickname = messageCategory.targetUser.nickname;
        self.targetUserGender = @(messageCategory.targetUser.gender);
        self.targetUserThumbnailAvatar = messageCategory.targetUser.avatar.thumbnailURL.absoluteString;
    }
}

- (void)configForDefaultWithType:(NSInteger)type {
    self.type = @(type);
    self.content = nil;
    self.lastTime = nil;
    self.unreadCount = @0;
    self.masterUserID = @0;
}

- (BLUUser *)targetUser {
    BLUImageRes *fromUserAvatar = nil;
    if (self.targetUserThumbnailAvatar) {
        fromUserAvatar =
        [[BLUImageRes alloc]
         initWithDictionary:@{BLUImageResKeyThumbnailURL: [NSURL URLWithString:self.targetUserThumbnailAvatar]}
         error:nil];
    }
    NSMutableDictionary *userDict = [NSMutableDictionary new];
    if (fromUserAvatar) {
        userDict[BLUUserKeyAvatar] = fromUserAvatar;
    }

    if (self.targetUserNickname) {
        userDict[BLUUserKeyNickname] = self.targetUserNickname;
    }
    userDict[BLUUserKeyUserID] = self.targetUserID;
    userDict[BLUUserKeyGender] = self.targetUserGender;

    NSError *error = nil;
    BLUUser *targetUser = [[BLUUser alloc] initWithDictionary:userDict error:&error];
    if (error) {
        BLULogError(@"Error = %@", error);
    }

    return targetUser;
}

@end
