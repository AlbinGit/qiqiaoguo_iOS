//
//  BLULoginOrRegUIComponent.m
//  Blue
//
//  Created by Bowen on 6/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLULoginOrRegUIComponent.h"

@implementation BLULoginOrRegUIComponent

+ (void)avatarContainer:(UIView *)avatarContainer
         avatarEditView:(UIView *)avatarEditView
              superview:(UIView *)superview {
    avatarContainer.backgroundColor = BLUThemeMainTintBackgroundColor;
    avatarContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addSubview:avatarContainer];
    
    avatarEditView.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addSubview:avatarEditView];
}

+ (void)textFieldContainer:(BLUTextFieldContainer *)textFieldContainer
               placeholder:(NSString *)placeholder
                 superview:(UIView *)superview {
    
    textFieldContainer.textField.placeholder = placeholder;
//   [textFieldContainer.textField setValue:[UIColor colorFromHexString:@"c1c1c1"] forKey:@"_placeholderLabel.textColor"];
    
   NSMutableAttributedString*placeholderString = [[NSMutableAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"c1c1c1"]}];

  textFieldContainer.textField.attributedPlaceholder = placeholderString;


    textFieldContainer.backgroundColor = BLUThemeMainTintBackgroundColor;
    textFieldContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addSubview:textFieldContainer];
}

+ (void)container:(UIView *)container
            label:(UILabel *)label
           button:(UIButton *)button
           prefix:(NSString *)prefix
           suffix:(NSString *)suffix
        superview:(UIView *)superview {
    container.translatesAutoresizingMaskIntoConstraints = NO;
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = prefix;
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.titleColor = [BLUCurrentTheme mainColor];
    button.title = suffix;
    button.titleFont = label.font;

    [container addSubview:label];
    [container addSubview:button];
    [superview addSubview:container];
}

@end
