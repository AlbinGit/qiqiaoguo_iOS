//
//  BLUPostTagContainer.m
//  Blue
//
//  Created by Bowen on 2/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostTagContainer.h"
#import "BLUPostTag.h"
#import "UIImage+Tag.h"
#import "BLUPostTagTextAttachment.h"

static const NSInteger kMaxTagCount = 5;

@interface BLUPostTagContainer () <UITextViewDelegate>

@property (nonatomic, strong) NSDictionary *textAttributes;

@end

@implementation BLUPostTagContainer

#pragma mark - UITextView.

- (instancetype)init {
    if (self = [super init]) {

        _selectAble = YES;
        _style = BLUPostTagContainerTagStyleSolid;
        _tagInset = UIEdgeInsetsZero;
        _tagFont = BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge);
        _deleteAble = NO;
        _maxTagsCount = kMaxTagCount;

        self.dataDetectorTypes = UIDataDetectorTypeNone;
        self.delegate = self;
        [self configInputStyle];

        @weakify(self);
        [RACObserve(self, contentSize) subscribeNext:^(id x) {
            @strongify(self);
            if ([self.postTagContainerDelegate
                 respondsToSelector:@selector(containerNeedResize:)]) {
                [self.postTagContainerDelegate containerNeedResize:self];
            }
        }];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)setEditable:(BOOL)editable {
    [super setEditable:editable];

    if (editable == NO) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
    }
}

#pragma mark - Tag manager.

- (NSDictionary *)textAttributes {
    if (_textAttributes == nil) {
        NSMutableParagraphStyle *textStyle =
        [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
        textStyle.lineSpacing = self.textContainerInset.top;
        _textAttributes = @{NSFontAttributeName: _tagFont,
                           NSForegroundColorAttributeName:
                                [UIColor colorFromHexString:@"#9FA0A2"],
                           NSParagraphStyleAttributeName: textStyle};
    }
    return _textAttributes;
}

- (void)addTag:(BLUPostTag *)tag {
    NSParameterAssert([tag isKindOfClass:[BLUPostTag class]]);
    [self removeText];
    [self insertTag:tag atIndex:self.attributedText.length];
}

- (void)addTags:(NSArray *)tags {
    [tags enumerateObjectsUsingBlock:^(BLUPostTag *tag,
                                       NSUInteger idx,
                                       BOOL * _Nonnull stop) {
        NSParameterAssert([tag isKindOfClass:[BLUPostTag class]]);
        [self addTag:tag];
    }];
}

- (void)insertTag:(BLUPostTag *)tag atIndex:(NSInteger)index {
    NSParameterAssert([tag isKindOfClass:[BLUPostTag class]]);
    NSParameterAssert(index >= 0 && index <= self.attributedText.length);

    if (![self canInsertTag:tag]) {
        return;
    }

    NSMutableAttributedString *mutAttrStr = [NSMutableAttributedString new];

    [self.attributedText.allAttachments
     enumerateObjectsUsingBlock:^(BLUPostTagTextAttachment *tatt,
                                  NSUInteger idx,
                                  BOOL * _Nonnull stop) {
        NSParameterAssert([tatt isKindOfClass:[BLUPostTagTextAttachment class]]);
        NSAttributedString *attrStr = [self attrStrFromTag:tatt.tag];
        [mutAttrStr appendAttributedString:attrStr];
    }];

    NSAttributedString *attrStr = [self attrStrFromTag:tag];
    [mutAttrStr insertAttributedString:attrStr atIndex:index];
    self.attributedText = mutAttrStr;

    if ([self.postTagContainerDelegate
         respondsToSelector:@selector(containerDidAddTag:container:)]) {
        [self.postTagContainerDelegate containerDidAddTag:tag container:self];
    }

//    [self.attributedText logTagTitle];
}

- (BOOL)canInsertTag:(BLUPostTag *)tag {
    NSArray *textAttachment = self.attributedText.allAttachments;
    if (textAttachment.count >= _maxTagsCount) {
        if ([self.postTagContainerDelegate respondsToSelector:
             @selector(containerCannotAddTagAnymore:container:)]) {
            [self.postTagContainerDelegate
             containerCannotAddTagAnymore:tag
             container:self];
        }
        [self removeText];
        return NO;
    } else {
        [self removeText];
        return [self isDulicatedTag:tag];
    }
}

- (BOOL)isDulicatedTag:(BLUPostTag *)tag {
    NSArray *textAttachment = self.attributedText.allAttachments;
    __block BOOL flag = YES;
    [textAttachment enumerateObjectsUsingBlock:^(BLUPostTagTextAttachment *tatt,
                                                 NSUInteger idx,
                                                 BOOL * _Nonnull stop) {
        NSParameterAssert([tatt isKindOfClass:[BLUPostTagTextAttachment class]]);

        BLUPostTag *iterTag = tatt.tag;

        if ([tag.title isEqualToString:iterTag.title]) {
            if ([self.postTagContainerDelegate respondsToSelector:
                 @selector(containerDidReceiveDulicateTag:container:)]) {
                [self.postTagContainerDelegate
                 containerDidReceiveDulicateTag:tag container:self];
            }
            flag = NO;
            *stop = YES;
        }
    }];
    return flag;
}

- (NSAttributedString *)attrStrFromTag:(BLUPostTag *)tag {
    return [BLUPostTagTextAttachment
            postTagAttributeStringWithTag:tag
            font:_tagFont selected:[self tagSelectionWithTag:tag]
            deleteAble:_deleteAble textAttributes:self.textAttributes];
}

- (BLUPostTagTextAttachment *)textAttachmentFromTag:(BLUPostTag *)tag {
    return [BLUPostTagTextAttachment
            postTagTextAttachmentWithTag:tag font:_tagFont selected:
            [self tagSelectionWithTag:tag] deletedAble:_deleteAble];
}

- (void)removeText {
    NSMutableAttributedString *mutAttrStr = [NSMutableAttributedString new];

    [self.attributedText.allAttachments
     enumerateObjectsUsingBlock:^(BLUPostTagTextAttachment *tatt,
                                  NSUInteger idx,
                                  BOOL * _Nonnull stop) {
         NSParameterAssert([tatt isKindOfClass:[BLUPostTagTextAttachment class]]);
         NSAttributedString *attrStr = [self attrStrFromTag:tatt.tag];
         [mutAttrStr appendAttributedString:attrStr];
     }];

    self.attributedText = mutAttrStr;
}

// FIX: 删除tag可能导致tag的顺序出错
- (void)removeTag:(BLUPostTag *)tag {
    NSArray *textAttachments = self.attributedText.allAttachments;
    self.attributedText = nil;

    [textAttachments
     enumerateObjectsUsingBlock:^(BLUPostTagTextAttachment *textAttachment,
                                  NSUInteger idx,
                                  BOOL * _Nonnull stop) {
         NSParameterAssert([textAttachment
                            isKindOfClass:[BLUPostTagTextAttachment class]]);

         NSInteger index = 0;

         if (![textAttachment.tag.title isEqualToString:tag.title]) {
             [self insertTag:textAttachment.tag atIndex:index];
             index++;
         } else {
             if ([self.postTagContainerDelegate respondsToSelector:
                  @selector(containerDidRemoveTag:atIndex:container:)]) {
                 [self.postTagContainerDelegate
                  containerDidRemoveTag:tag
                  atIndex:index
                  container:self];
             }
         }
    }];
}

- (void)removeTagAtIndex:(NSInteger)index {
    BLUPostTag *tag = [self tagAtIndex:index];
    [self removeTag:tag];
}

- (void)removeAllTags {
    self.attributedText = nil;
}

- (BOOL)tagSelectionWithTag:(BLUPostTag *)tag {
    if (_selectAble) {
        return tag.selected;
    } else {
        switch (_style) {
            case BLUPostTagContainerTagStyleSolid: {
                return YES;
            } break;
            case BLUPostTagContainerTagStyleHollow: {
                return NO;
            } break;
        }
    }
}

- (NSArray *)allTags {
    return [self.attributedText allTags];
}

#pragma mark - Action.

- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    [super addGestureRecognizer:gestureRecognizer];
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tgr = (UITapGestureRecognizer *)gestureRecognizer;
        if ([tgr numberOfTapsRequired] == 1 &&
            [tgr numberOfTouchesRequired] == 1) {
            [tgr addTarget:self action:@selector(handleTap:)];
        }
    }
}
- (void)removeGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tgr = (UITapGestureRecognizer *)gestureRecognizer;
        if ([tgr numberOfTapsRequired] == 1 &&
            [tgr numberOfTouchesRequired] == 1) {
            // If found then remove self from its targets/actions
            [tgr removeTarget:self action:@selector(handleTap:)];
        }
    }
    [super removeGestureRecognizer:gestureRecognizer];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"Tap");
    CGPoint location = [recognizer locationInView:self];

    if (CGRectContainsPoint(self.bounds, location)){
        NSInteger characterIndex = [self characterIndexWithGestureLocation:location];

        if (characterIndex >= 0) {
            NSString *title =
            (NSString *)[self
                         valueWithCharacterIndex:characterIndex
                         attribute:BLUPostTagTitleAttributeName];

            if (title) {
                NSParameterAssert([title isKindOfClass:[NSString class]]);
                BLULogDebug(@"title = %@", title);

                BLUPostTag *tag = [self tagAtIndex:characterIndex];

                if (tag) {
                    [self tougleSelectionForTag:tag atIndex:characterIndex];
                }
            }
        } else {
            if ([self.postTagContainerDelegate
                 respondsToSelector:@selector(containerSelectNoneTag:)]) {
                [self.postTagContainerDelegate containerSelectNoneTag:self];
            }
        }
    }
}

- (BLUPostTag *)tagAtIndex:(NSInteger)index {

    NSParameterAssert(index >= 0 && index <= self.attributedText.length);

    NSAttributedString *attrStr =
    [self.attributedText
     attributedSubstringFromRange:NSMakeRange(index, 1)];


    BLUPostTagTextAttachment *attachment =
    [attrStr attribute:NSAttachmentAttributeName
               atIndex:0
        effectiveRange:nil];

    if ([attachment.tag isKindOfClass:[BLUPostTag class]]) {
        return attachment.tag;
    } else {
        return nil;
    }
}

- (NSInteger)indexOfTag:(BLUPostTag *)tag {
    NSParameterAssert([tag isKindOfClass:[BLUPostTag class]]);
    __block NSInteger index = NSNotFound;
    __block NSInteger iter = 0;
    [self.attributedText enumerateAttribute:BLUPostTagTitleAttributeName inRange:NSMakeRange(0, self.attributedText.length)
                                    options:0
                                 usingBlock:^(NSString *title, NSRange range, BOOL * _Nonnull stop) {
        [title isKindOfClass:[NSString class]];
        if ([title isEqualToString:tag.title]) {
            index = iter;
            *stop = YES;
        }
        iter++;
    }];
    return index;
}

- (void)tougleSelectionForTag:(BLUPostTag *)tag atIndex:(NSInteger)index {

    if (_selectAble) {
        if (tag.selected) {

            [self updateTagSelectionState:NO atIndex:index];

            if ([self.postTagContainerDelegate
                 respondsToSelector:
                 @selector(containerDidDeselectedTag:atIndex:container:)]) {
                [self.postTagContainerDelegate
                 containerDidDeselectedTag:tag
                 atIndex:index
                 container:self];
            }


            BLULogDebug(@"deselect tag = %@", tag);
        } else {

            [self updateTagSelectionState:YES atIndex:index];

            if ([self.postTagContainerDelegate
                 respondsToSelector:
                 @selector(containerDidSelectedTag:atIndex:container:)]) {
                [self.postTagContainerDelegate
                 containerDidSelectedTag:tag
                 atIndex:index
                 container:self];
            }


            BLULogDebug(@"select tag = %@", tag);
        }
    } else {

        if (_deleteAble) {

            [self removeTagAtIndex:index];
        } else {
            if ([self.postTagContainerDelegate
                 respondsToSelector:
                 @selector(containerDidSelectedTag:atIndex:container:)]) {
                [self.postTagContainerDelegate
                 containerDidSelectedTag:tag
                 atIndex:index
                 container:self];
            }
            BLULogDebug(@"tag tag = %@", tag);
        }
    }
}

- (void)updateTagSelectionState:(BOOL)selection atIndex:(NSInteger)index {
//    if (selection == YES) {
//        if ([self canSelectedTag] == NO) {
//            return;
//        }
//    }

    NSRange effectiveRange;
    BLUPostTagTextAttachment *textAttachment =
    [self.attributedText
     attribute:NSAttachmentAttributeName
     atIndex:index
     longestEffectiveRange:&effectiveRange
     inRange:NSMakeRange(0, self.attributedText.length)];

    NSMutableAttributedString *mutAttrStr =
    [[NSMutableAttributedString alloc]
     initWithAttributedString:self.attributedText];

    NSParameterAssert([textAttachment isKindOfClass:[BLUPostTagTextAttachment class]]);

    textAttachment.tag.selected = selection;

    textAttachment = [self textAttachmentFromTag:textAttachment.tag];

    [mutAttrStr removeAttribute:NSAttachmentAttributeName range:effectiveRange];
    [mutAttrStr addAttribute:NSAttachmentAttributeName
                       value:textAttachment
                       range:effectiveRange];

    self.attributedText = mutAttrStr;

    if ([self.postTagContainerDelegate respondsToSelector:@selector(containerTagsDidChange:container:)]) {
        [self.postTagContainerDelegate containerTagsDidChange:self.attributedText.allTags container:self];
    }
}

- (NSInteger)selectedCount {
    NSInteger selectedCount = 0;
    for (BLUPostTag *tag in self.attributedText.allTags) {
        if ([tag selected]) {
            selectedCount++;
        }
    }
    return selectedCount;
}

- (BOOL)canSelectedTag {
    if ([self selectedCount] < self.maxSelectionCount) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)characterIndexWithGestureLocation:(CGPoint)location {
    location.x -= self.textContainerInset.left;
    location.y -= self.textContainerInset.top;
    CGFloat fraction;
    NSInteger characterIndex =
    [self.layoutManager
     characterIndexForPoint:location
     inTextContainer:self.textContainer
     fractionOfDistanceBetweenInsertionPoints:&fraction];

    if (fraction < 1) {
        return characterIndex;
    } else {
        return -1;
    }
}

- (id)valueWithCharacterIndex:(NSUInteger)characterIndex attribute:(id)attribute {
    if (characterIndex < self.textStorage.length) {
        NSRange range;
        return [self.attributedText
                attribute:attribute
                atIndex:characterIndex
                effectiveRange:&range];
    } else {
        return nil;
    }
}

#pragma mark - Text view delegate.

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self configInputStyle];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self convertInputTitlesToTags];
    if ([self.postTagContainerDelegate
         respondsToSelector:@selector(containerDidEndEditing:)]) {
        [self.postTagContainerDelegate containerDidEndEditing:self];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([self.postTagContainerDelegate
         respondsToSelector:@selector(containerDidChanged:)]) {
        [self.postTagContainerDelegate containerDidChanged:self];
    }
}

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {

    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}

- (void)configInputStyle {
    self.font = self.tagFont;
    self.allowsEditingTextAttributes = self.textAttributes;
    self.typingAttributes = self.textAttributes;
}

- (void)convertInputTitlesToTags {
    NSArray *strs = self.attributedText.allStrings;
    [strs enumerateObjectsUsingBlock:^(NSString *str,
                                       NSUInteger idx,
                                       BOOL * _Nonnull stop) {
        NSParameterAssert([str isKindOfClass:[NSString class]]);
        NSInteger originLength = str.length;
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [self insertTag:[BLUPostTag tagsFromTagTitles:@[str]].lastObject
                atIndex:(self.selectedRange.location - originLength)];
    }];

    [self removeInputTitles:strs];

    if ([self.postTagContainerDelegate
         respondsToSelector:@selector(containerNeedResize:)]) {
        [self.postTagContainerDelegate containerNeedResize:self];
    }
}

- (void)removeInputTitles:(NSArray *)titles {
    NSMutableAttributedString *mutAttrStr = [NSMutableAttributedString new];

    NSArray *attachmentStrings = self.attributedText.allAttachmentsString;
    [attachmentStrings enumerateObjectsUsingBlock:^(NSAttributedString *str,
                                                    NSUInteger idx,
                                                    BOOL * _Nonnull stop) {

        [mutAttrStr appendAttributedString:str];
    }];

    self.attributedText = mutAttrStr;
}

@end
