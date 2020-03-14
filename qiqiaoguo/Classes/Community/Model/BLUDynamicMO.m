//
//  BLUDynamicMO.m
//  
//
//  Created by Bowen on 2/11/2015.
//
//

#import "BLUDynamicMO.h"
#import "BLUDynamic.h"

NSString *BLUDynamicMOKeyCreateDate = @"createDate";
NSString *BLUDynamicMOKeyDynamicID = @"dynamicID";

@implementation BLUDynamicMO

- (void)configWithDynamic:(BLUDynamic *)dynamic {
    self.dynamicID = @(dynamic.dynamicID);
    self.type = @(dynamic.type);
    self.createDate = dynamic.createDate;
    self.fromUserID = @(dynamic.fromUser.userID);
    self.fromUserNickname = dynamic.fromUser.nickname;
    self.fromUserGender = @(dynamic.fromUser.gender);
    self.fromUserThumbnailAvatarURL = dynamic.fromUser.avatar.thumbnailURL.absoluteString;
    self.toUserID = @(dynamic.toUser.userID);
    self.toUserNickname = dynamic.toUser.nickname;
    self.content = dynamic.content;
    self.postID = @(dynamic.target.postID);
    self.commentID = @(dynamic.target.commentID);
    self.anonymous = @(dynamic.fromUserAnonymous);
    self.targetUserID = @(dynamic.target.userID);
}

- (BLUUser *)fromUser {

    BLUImageRes *fromUserAvatar = nil;
    if (self.fromUserThumbnailAvatarURL) {
        fromUserAvatar =
        [[BLUImageRes alloc]
         initWithDictionary:@{BLUImageResKeyThumbnailURL: [NSURL URLWithString:self.fromUserThumbnailAvatarURL]}
         error:nil];
    }

    NSMutableDictionary *userDict = [NSMutableDictionary new];
    if (fromUserAvatar) {
        userDict[BLUUserKeyAvatar] = fromUserAvatar;
    }

    if (self.fromUserNickname) {
        userDict[BLUUserKeyNickname] = self.fromUserNickname;
    }
    userDict[BLUUserKeyUserID] = self.fromUserID;
    userDict[BLUUserKeyGender] = self.fromUserGender;

    NSError *error = nil;
    BLUUser *fromUser = [[BLUUser alloc] initWithDictionary:userDict error:&error];
    if (error) {
        BLULogError(@"Error = %@", error);
    }

    return fromUser;
}

- (BLUUser *)toUser {

    NSMutableDictionary *userDict = [NSMutableDictionary new];

    if (self.toUserNickname) {
        userDict[BLUUserKeyNickname] = self.toUserNickname;
    }
    userDict[BLUUserKeyUserID] = self.toUserID;

    NSError *error = nil;
    BLUUser *toUser = [[BLUUser alloc] initWithDictionary:userDict error:&error];
    if (error) {
        BLULogError(@"Error = %@", error);
    }
    
    return toUser;
}

@end
