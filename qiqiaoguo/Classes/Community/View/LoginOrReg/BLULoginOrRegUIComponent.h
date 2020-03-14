//
//  BLULoginOrRegUIComponent.h
//  Blue
//
//  Created by Bowen on 6/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLULoginOrRegUIComponent : NSObject

+ (void)avatarContainer:(UIView *)avatarContainer
         avatarEditView:(UIView *)avatarEditView
              superview:(UIView *)sueprview;

+ (void)textFieldContainer:(BLUTextFieldContainer *)textFieldContainer
               placeholder:(NSString *)placeholder
                 superview:(UIView *)superview;

+ (void)container:(UIView *)container
            label:(UILabel *)label
           button:(UIButton *)button
           prefix:(NSString *)prefix
           suffix:(NSString *)suffix
        superview:(UIView *)superview;

@end
