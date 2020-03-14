//
//  NSAttributedString+BLUAddition.h
//  Blue
//
//  Created by Bowen on 8/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (BLUAddition)

+ (NSAttributedString *)contentAttributedStringWithContent:(NSString *)content;

- (NSArray *)allAttachments;
- (NSArray *)allAttachmentsString;

- (NSRange)firstStringRange;
- (NSArray *)allStrings;

@end
