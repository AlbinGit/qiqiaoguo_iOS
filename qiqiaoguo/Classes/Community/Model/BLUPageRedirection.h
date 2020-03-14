//
//  BLUPageRedirection.h
//  Blue
//
//  Created by Bowen on 11/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BLUPageRedirectionType) {
    BLUPageRedirectionTypeNone = 0,
    BLUPageRedirectionTypeGood = 1,
    BLUPageRedirectionTypeSeckillGood = 2,
    BLUPageRedirectionTypeWeb = 5,
    BLUPageRedirectionTypeGoodCategory,
    BLUPageRedirectionTypeOrgList = 8,
    BLUPageRedirectionTypeTercherList,
    BLUPageRedirectionTypeCourseList,
    BLUPageRedirectionTypeActivList = 12,
    BLUPageRedirectionTypeActiv = 13,
    BLUPageRedirectionTypeOrg = 18,
    BLUPageRedirectionTypeTeacher = 19,
    BLUPageRedirectionTypeCourse = 20,
    BLUPageRedirectionTypePost = 101,
    BLUPageRedirectionTypeCircle,
    BLUPageRedirectionTypeTag = 111,
};

@protocol BLUPageRedirection <NSObject>

@optional

@property (nonatomic, assign) NSInteger redirectID;
@property (nonatomic, assign) BLUPageRedirectionType redirectType;
@property (nonatomic, strong) NSURL *redirectURL;
@property (nonatomic, strong) id redirectObject;
@property (nonatomic, strong) NSString *redirectTitle;

@end
