//
//  BLUViewController+Alert.m
//  Blue
//
//  Created by Bowen on 22/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUViewController+Alert.h"

@implementation BLUViewController (Alert)

- (void)showAlertForError:(NSError *)error {
    NSParameterAssert(error);
    
//    if (objc_getClass("UIAlertController") != nil) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
//        // FIX
//        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:alertAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    } else {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertView show];
//    }
    [self showTopIndicatorWithError:error];
}

@end
