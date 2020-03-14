//
//  BLUReportViewModel.m
//  Blue
//
//  Created by Bowen on 5/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUReportViewModel.h"
#import "BLUApiManager+Others.h"

@interface BLUReportViewModel ()

@property (nonatomic, assign) NSInteger objectID;
@property (nonatomic, weak) BLUViewController *viewController;
@property (nonatomic, weak) UIView *sourceView;
@property (nonatomic, assign) CGRect sourceRect;
@property (nonatomic, assign) BLUReportSourceType sourceType;
@property (nonatomic, assign) BLUReportReasonType reasonType;

@end

@implementation BLUReportViewModel

- (instancetype)initWithObjectID:(NSInteger)objectID viewController:(BLUViewController *)viewController sourceView:(UIView *)sourceView sourceRect:(CGRect)sourceRect sourceType:(BLUReportSourceType)sourceType{
    if (self = [super init]) {
        _objectID = objectID;
        _viewController = viewController;
        _sourceView = sourceView;
        _sourceType = sourceType;
        _sourceRect = sourceRect;
        return self;
    }
    return nil;
}

- (void)showReportSheet {
    if (_viewController == nil && _sourceView == nil) {
        return ;
    }

    if (objc_getClass("UIAlertController") != nil) {
        UIAlertController *alertController = [UIAlertController new];
        alertController.title = nil;

        UIAlertAction * (^makeAction)(NSString *title, BLUReportReasonType type) = ^ UIAlertAction * (NSString *title, BLUReportReasonType reasonType) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                _reasonType = reasonType;
                [self request];
            }];
            return action;
        };

        UIAlertAction *otherAction = makeAction(NSLocalizedString(@"report-vm.other", @"Other"), BLUReportReasonTypeOther);
        UIAlertAction *advertiseAction = makeAction(NSLocalizedString(@"report-vm.advertise", @"Advertise"), BLUReportReasonTypeAdvertise);
        UIAlertAction *sexAction = makeAction(NSLocalizedString(@"report-vm.sex", @"Sex"), BLUReportReasonTypeSex);
        UIAlertAction *annoyAction = makeAction(NSLocalizedString(@"report-vm.annoy", @"Annoy"), BLUReportReasonTypeAnnoy);
        UIAlertAction *disclosurePrivacy = makeAction(NSLocalizedString(@"report-vm.disclosure-privacy", @"Disclosure privacy"), BLUReportReasonTypeDisclosurePrivacy);

        UIAlertAction *cancelAction = [UIAlertAction cancelAction];

        [alertController addAction:advertiseAction];
        [alertController addAction:sexAction];
        [alertController addAction:annoyAction];
        [alertController addAction:disclosurePrivacy];
        [alertController addAction:otherAction];
        [alertController addAction:cancelAction];

        alertController.popoverPresentationController.sourceRect = self.sourceRect;
        alertController.popoverPresentationController.sourceView = self.sourceView;

        [_viewController presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)request {
    if ([_viewController isKindOfClass:[BLUViewController class]]) {
        [self.viewController showTopIndicatorWithSuccessMessage:NSLocalizedString(@"post-detail.reported", @"Reported")];
        [[[BLUApiManager sharedManager] reportForObjectID:self.objectID sourceType:self.sourceType reasonType:self.reasonType reason:nil] subscribeCompleted:^{}];
    }
}

@end
