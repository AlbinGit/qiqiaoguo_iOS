//
//  BLUMessageMO.m
//  
//
//  Created by Bowen on 30/10/2015.
//
//

#import "BLUMessageMO.h"
#import "BLUMessage.h"
#import "BLUContentParagraph.h"

NSString * BLUMessageMOEntityName = @"BLUMessageMO";
NSString * BLUMessageMOKeyOrderIndex = @"orderIndex";

@implementation BLUMessageMO

- (void)configMessageMOWithMessage:(BLUMessage *)message {
    self.messageID = @(message.messageID);
    self.remoteState = @(message.remoteState);
    self.showSendTime = @(message.showSendTime);
    self.contentType = @(message.content.type);
    self.createDate = message.createDate;

    self.fromUserGender = @(message.fromUser.gender);
    self.fromUserID = @(message.fromUserID);
    self.fromUserNickname = message.fromUserName;
    self.fromUserThumbnailAvatarURL = message.fromUserImageStr;

    self.toUserID = @(message.toUserID);

    self.text = message.content.text;
    self.imageWidth = @(message.width);
    self.imageHeight = @(message.height);
    self.imageURL = message.fromUserImageStr;

    self.contentType = @(message.type);
    self.redirectType = @(message.redirectType);
    self.redirectID = @(message.redirectID);
}

- (BLUUser *)fromUser {

    BLUImageRes *fromUserAvatar = nil;
    if (self.fromUserThumbnailAvatarURL) {
        fromUserAvatar =
        [[BLUImageRes alloc]
         initWithDictionary:@{BLUImageResKeyThumbnailURL:[NSURL URLWithString:self.fromUserThumbnailAvatarURL]}
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

    BLUImageRes *toUserAvatar = nil;
    NSMutableDictionary *userDict = [NSMutableDictionary new];
    if (toUserAvatar) {
        userDict[BLUUserKeyAvatar] = toUserAvatar;
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
