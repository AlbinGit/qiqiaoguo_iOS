//
//  BLUPostParagraph.h
//  Blue
//
//  Created by Bowen on 22/9/15.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUObject.h"

UIKIT_EXTERN NSString * const BLUContentParagraphText;
UIKIT_EXTERN NSString * const BLUContentParagraphImageURL;
UIKIT_EXTERN NSString * const BLUContentParagraphVideoURL;
UIKIT_EXTERN NSString * const BLUContentParagraphHeight;
UIKIT_EXTERN NSString * const BLUContentParagraphWidth;
UIKIT_EXTERN NSString * const BLUContentParagraphType;
UIKIT_EXTERN NSString * const BLUContentParagraphImageRes;

typedef NS_ENUM(NSInteger, BLUContentParagraphTypes) {
    BLUPostParagraphTypeText = 0,
    BLUPostParagraphTypeImage,
    BLUPostParagraphTypeVideo,
    BLUPostParagraphTypeRedirectText = 11,
    BLUPostParagraphTypeRedirectImage = 12,
};

typedef NS_ENUM(NSInteger, BLUContentParagraphRedirectType) {
    BLUContentParagraphRedirectTypeGood = 1,
    BLUContentParagraphRedirectTypeWeb = 5,
    BLUContentParagraphRedirectTypeGoodCategory,
    BLUContentParagraphRedirectTypeOrgList = 8,
    BLUContentParagraphRedirectTypeTercherList,
    BLUContentParagraphRedirectTypeCourseList,
    BLUContentParagraphRedirectTypeActivList = 12,
    BLUContentParagraphRedirectTypeActiv = 13,
    BLUContentParagraphRedirectTypeOrg = 18,
    BLUContentParagraphRedirectTypeTeacher = 19,
    BLUContentParagraphRedirectTypeCourse = 20,
    BLUContentParagraphRedirectTypePost = 101,
    BLUContentParagraphRedirectTypeCircle = 102,
    BLUContentParagraphRedirectTypeTag = 111,
};

@interface BLUContentParagraph : BLUObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy, readonly) NSURL *imageURL;
@property (nonatomic, copy, readonly) NSURL *videoURL;
@property (nonatomic, assign, readonly) CGFloat height;
@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, assign, readonly) BLUContentParagraphTypes type;
@property (nonatomic, assign, readonly) BLUContentParagraphRedirectType redirectType;
@property (nonatomic, copy, readonly) NSURL *pageURL;
@property (nonatomic, assign, readonly) NSInteger objectID;
@property (nonatomic, copy, readonly) BLUImageRes *imageRes;

+ (BLUContentParagraph *)paragraphWithText:(NSString *)text;
+ (BLUContentParagraph *)paragraphWithImageRes:(BLUImageRes *)imageRes;

@end
