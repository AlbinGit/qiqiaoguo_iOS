//
//  BLUDialogueMO.m
//  
//
//  Created by Bowen on 1/11/2015.
//
//

#import "BLUDialogueMO.h"
#import "BLUDialogue.h"

NSString * BLUDialogueMOKeyLastTime = @"lastTime";
NSString * BLUDialogueMOKeyFromUserID = @"fromUserID";

@implementation BLUDialogueMO

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

- (void)configWithDialogue:(BLUDialogue *)dialogue {
    self.dialogueID = @(dialogue.dialogueID);
    self.createDate = dialogue.createDate;
    self.lastTime = dialogue.lastTime;
    self.unreadCount = @(dialogue.unreadCount);
    self.lastMessage = dialogue.lastMessage;
    self.fromUserID = @(dialogue.targetID);
    self.fromUserNickname = dialogue.targetName;
    self.fromUserThumbnailAvatarURL = dialogue.targetImage;
    self.fromUserGender = @(dialogue.fromUser.gender);
}

- (BOOL)isEqualToDialogue:(BLUDialogue *)dialogue {
    BOOL ret = YES;
    if (self.dialogueID.integerValue != dialogue.dialogueID) {
        return NO;
    }
    if (![self.lastTime isEqualToDate:dialogue.lastTime]) {
        return NO;
    }

    return ret;
}

@end
