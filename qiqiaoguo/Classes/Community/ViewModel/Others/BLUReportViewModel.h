//
//  BLUReportViewModel.h
//  Blue
//
//  Created by Bowen on 5/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUViewModel.h"

typedef NS_ENUM(NSInteger, BLUReportSourceType) {
    BLUReportSourceTypeUser = 0,
    BLUReportSourceTypePost,
    BLUReportSourceTypeCircle = 3,
    BLUReportSourceTypeComment,
    BLUReportSourceTypeReply,
};

typedef NS_ENUM(NSInteger, BLUReportReasonType) {
    BLUReportReasonTypeOther = 0,
    BLUReportReasonTypeAdvertise,
    BLUReportReasonTypeSex,
    BLUReportReasonTypeAnnoy,
    BLUReportReasonTypeDisclosurePrivacy,
};

@interface BLUReportViewModel : BLUViewModel

- (instancetype)initWithObjectID:(NSInteger)objectID viewController:(BLUViewController *)viewController sourceView:(UIView *)sourceView sourceRect:(CGRect)sourceRect sourceType:(BLUReportSourceType)sourceType;
- (void)showReportSheet;

@end
