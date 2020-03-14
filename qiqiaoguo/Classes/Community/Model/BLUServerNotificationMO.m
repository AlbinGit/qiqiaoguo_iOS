//
//  BLUServerNotificationMO.m
//  
//
//  Created by Bowen on 3/11/2015.
//
//

#import "BLUServerNotificationMO.h"
#import "BLUServerNotification.h"

NSString *BLUServerNotificationMOKeyCreateDate = @"createDate";
NSString *BLUServerNotificationMOKeyNotificationID = @"notificationID";

@implementation BLUServerNotificationMO

- (void)configWithServerNotification:(BLUServerNotification *)serverNotification {
    self.notificationID = @(serverNotification.notificationID);
    self.objID = @(serverNotification.objectID);
    self.createDate = serverNotification.createDate;
    self.title = serverNotification.title;
    self.content = serverNotification.content;
    self.webURL = serverNotification.webURL.absoluteString;
    self.photoWidth = @(serverNotification.photo.width);
    self.photoHeight = @(serverNotification.photo.height);
    self.photoThumbnailURL = serverNotification.photo.thumbnailURL.absoluteString;
    self.photoOriginURL = serverNotification.photo.originURL.absoluteString;
    self.type = @(serverNotification.type);
}

@end
