//
//  BLUPostTagTextAttachment.h
//  Blue
//
//  Created by Bowen on 2/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * BLUPostTagTitleAttributeName;

@class BLUPostTag;

@interface BLUPostTagTextAttachment : NSTextAttachment

@property (nonatomic, strong) BLUPostTag *tag;

- (instancetype)initWithPostTag:(BLUPostTag *)tag;

- (NSAttributedString *)tagAttrbuteStringWithFont:(UIFont *)font
                                          seleted:(BOOL)seleted
                                      deletedAble:(BOOL)deleteAble
                                   textAttributes:(NSDictionary *)textAttributes;

+ (NSAttributedString *)postTagAttributeStringWithTag:(BLUPostTag *)tag
                                                      font:(UIFont *)font
                                                  selected:(BOOL)selected
                                                deleteAble:(BOOL)deleteAble
                                            textAttributes:(NSDictionary *)textAttributes;

+ (BLUPostTagTextAttachment *)postTagTextAttachmentWithTag:(BLUPostTag *)tag
                                                      font:(UIFont *)font
                                                  selected:(BOOL)seleted
                                               deletedAble:(BOOL)deleteAble;

@end

@interface NSAttributedString (BLUPostTag)

- (void)logTagTitle;
- (NSArray *)allTags;

@end
