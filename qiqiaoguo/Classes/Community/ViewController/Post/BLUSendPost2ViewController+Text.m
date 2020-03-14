//
//  BLUSendPost2ViewController+Text.m
//  Blue
//
//  Created by Bowen on 1/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUSendPost2ViewController+Text.h"
#import "BLUSendPost2CircleSelector.h"
#import "BLUTextView.h"
#import "BLUSendPost2ViewModel.h"
#import "BLUContentParagraph.h"

#define kTextViewPlaceholder NSLocalizedString(@"send-post.content-text-view.placeholder", @"Content")

@implementation BLUSendPost2ViewController (Text)

#pragma mark - ContentTextView

- (void)insertImageToContentTextView:(UIImage *)image {
    NSParameterAssert([image isKindOfClass:[UIImage class]]);

    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;

    if (textAttachment.image.CGImage) {

        CGFloat oldImageWidth = textAttachment.image.size.width;
        CGFloat insetWidth =
        self.contentTextView.textContainerInset.left +
        self.contentTextView.textContainerInset.right +
        BLUThemeMargin * 2;
        CGFloat scaleFactor = oldImageWidth /
        (self.contentTextView.width - BLUThemeMargin * 2 - insetWidth);

        CGImageRef imageRef = textAttachment.image.CGImage;
        textAttachment.image = [UIImage
                                imageWithCGImage:imageRef
                                scale:scaleFactor
                                orientation:UIImageOrientationUp];
        textAttachment.bounds = CGRectMake(0, BLUThemeMargin,
                                           textAttachment.image.size.width,
                                           textAttachment.image.size.height);
        NSAttributedString *attrStringWithImage =
        [NSAttributedString attributedStringWithAttachment:textAttachment];

        NSMutableAttributedString *mutableAttrStr =
        self.contentTextView.attributedText ?
        [[NSMutableAttributedString alloc]
         initWithAttributedString:self.contentTextView.attributedText] :
        [NSMutableAttributedString new];

        NSInteger insertIndex = self.contentTextView.selectedRange.length +
        self.contentTextView.selectedRange.location;

        NSDictionary *spaceAttributes =
        @{NSFontAttributeName: self.titleTextField.font,
          NSForegroundColorAttributeName: self.titleTextField.textColor,
          BLUSendPostImageSpaceAttributedName: @(YES)};

        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
        paragraphStyle.alignment = NSTextAlignmentCenter;

        NSAttributedString *spaceAttrStr =
        [[NSAttributedString alloc] initWithString:@"\n"
                                        attributes:spaceAttributes];

        [mutableAttrStr insertAttributedString:spaceAttrStr atIndex:insertIndex];
        insertIndex++;
        [mutableAttrStr insertAttributedString:attrStringWithImage
                                       atIndex:insertIndex];
        insertIndex++;
        [mutableAttrStr insertAttributedString:spaceAttrStr atIndex:insertIndex];

        NSDictionary *attributes =
        @{NSFontAttributeName: self.titleTextField.font,
          NSForegroundColorAttributeName: self.titleTextField.textColor,
          NSParagraphStyleAttributeName: paragraphStyle};
        [mutableAttrStr addAttributes:attributes range:NSMakeRange(insertIndex, 1)];

        self.contentTextView.attributedText = mutableAttrStr;

        if ([self.contentTextView.delegate respondsToSelector:@selector(textViewDidChange:)]) {
            [self.contentTextView.delegate textViewDidChange:self.contentTextView];
        }
    }
}

#pragma mark - UITextField.

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.reminingImagesCount = BLUSendPost2MaxImageCount - self.contentTextView.attributedText.allAttachments.count;
    [self configureInputStyleForTextView:textView];
    self.viewModel.attributedContent = textView.attributedText;
    self.viewModel.text = textView.text;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self configureInputStyleForTextView:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self configureInputStyleForTextView:textView];
}

- (void)configureInputStyleForTextView:(UITextView *)textView {
    textView.typingAttributes = @{NSFontAttributeName: self.titleTextField.font,
                                  NSForegroundColorAttributeName: self.titleTextField.textColor};
    textView.allowsEditingTextAttributes = textView.typingAttributes;
}

- (void)textFieldDidChanged:(NSNotification *)notification {
    self.viewModel.title = self.titleTextField.text;
}

@end
