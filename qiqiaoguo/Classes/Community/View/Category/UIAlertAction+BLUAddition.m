//
//  UIAlertAction+BLUAddition.m
//  Blue
//
//  Created by Bowen on 17/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "UIAlertAction+BLUAddition.h"

@implementation UIAlertAction (BLUAddition)

+ (UIAlertAction *)cancelAction {
    return [UIAlertAction actionWithTitle:NSLocalizedString(@"alert-action.title.cancel", @"Cancel") style:UIAlertActionStyleCancel handler:nil];
}

+ (UIAlertAction *)okAction {
    return [UIAlertAction actionWithTitle:NSLocalizedString(@"alert-action.title.ok", @"OK") style:UIAlertActionStyleCancel handler:nil];
}

@end
