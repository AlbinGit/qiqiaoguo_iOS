//
//  BLUApSettingViewModel.m
//  Blue
//
//  Created by Bowen on 12/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUApSettingViewModel.h"
#import "BLUApiManager+Others.h"
#import "BLUAPSetting.h"

typedef NS_ENUM(NSInteger, BLUAPSettingSectionType) {
    BLUAPSettingSectionTypeUser = 0,
    BLUAPSettingSectionTypeSystem,
};

typedef NS_ENUM(NSInteger, BLUApSettingUserNotificationType) {
    BLUApSettingUserNotificationTypeComment = 0,
    BLUApSettingUserNotificationTypeFollow,
    BLUApSettingUserNotificationTypePrivateMessage,
};

typedef NS_ENUM(NSInteger, BLUApSettingSystemNoficationType) {
    BLUApSettingSystemNoficationTypeSystem = 0,
};

@interface BLUApSettingViewModel ()

@end

@implementation BLUApSettingViewModel

- (NSArray *)userNotificationTitles {
    return @[
             NSLocalizedString(@"ap-setting-view-model.comment-item.title", @"Comment message"),
             NSLocalizedString(@"ap-setting-view-model.follow.title", @"Follow message"),
             NSLocalizedString(@"ap-setting-view-model.private-message.title", @"Priavte message"),
             ];
}

- (NSArray *)systemNotificationTitles {
    return @[
             NSLocalizedString(@"ap-setting-view-model.system-item.title", @"System message"),
             ];
}

- (NSArray *)systemNotificationStates {
    return @[
             @(self.setting.systemNotification),
             ];
}

- (NSArray *)userNotificationStates {
    return @[
             @(self.setting.commentNotification),
             @(self.setting.followNotification),
             @(self.setting.privateMessageNotification),
             ];
}

- (NSArray *)stateSections {
    return @[
             [self userNotificationStates],
             [self systemNotificationStates],
             ];
}

- (NSArray *)titleSections {
    return @[
             [self userNotificationTitles],
             [self systemNotificationTitles],
             ];
}

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titleSections = [self titleSections];
    NSArray *rows = titleSections[indexPath.section];
    NSString *title = rows[indexPath.row];
    return title;
}

- (NSNumber *)stateAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *stateSections = [self stateSections];
    NSArray *rows = stateSections[indexPath.section];
    NSNumber *state = rows[indexPath.row];
    return state;
}

- (RACSignal *)switchAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case BLUAPSettingSectionTypeUser: {
            switch (indexPath.row) {
                case BLUApSettingUserNotificationTypeComment: {
                    self.setting.commentNotification = !self.setting.commentNotification;
                } break;
                case BLUApSettingUserNotificationTypeFollow: {
                    self.setting.followNotification = !self.setting.followNotification;
                } break;
                case BLUApSettingUserNotificationTypePrivateMessage: {
                    self.setting.privateMessageNotification = !self.setting.privateMessageNotification;
                } break;
            }
        } break;
        case BLUAPSettingSectionTypeSystem: {
            switch (indexPath.row) {
                case BLUApSettingSystemNoficationTypeSystem: {
                    self.setting.systemNotification = !self.setting.systemNotification;
                } break;
            }
        } break;
    }

    return [self sendSetting:self.setting];
}

- (RACSignal *)fetch {
    [self.fetchDisposable dispose];
    @weakify(self);
    return [[[BLUApiManager sharedManager] fetchAPSetting] doNext:^(BLUAPSetting *setting) {
        @strongify(self);
        self.setting = setting;
    }];
}

- (RACSignal *)sendSetting:(BLUAPSetting *)setting {
    [self.deleteDisposable dispose];
    @weakify(self);
    return [[[BLUApiManager sharedManager] postAPSetting:setting] doCompleted:^{
        @strongify(self);
        self.setting = setting;
    }];
}

@end
