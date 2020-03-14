//
//  BLUContentParagraphMO.m
//  
//
//  Created by Bowen on 22/1/2016.
//
//

#import "BLUContentParagraphMO.h"
#import "BLUContentParagraph.h"

@implementation BLUContentParagraphMO

- (void)configureWithContentParagraph:(BLUContentParagraph *)paragraph {
    BLUAssertObjectIsKindOfClass(paragraph, [BLUContentParagraph class]);
    self.text = paragraph.text;
    self.imageURL = paragraph.imageURL;
    self.videoURL = paragraph.videoURL;
    self.height = @(paragraph.height);
    self.width = @(paragraph.width);
    self.type = @(paragraph.type);
    self.redirectType = @(paragraph.redirectType);
    self.pageURL = paragraph.pageURL;
    self.contentID = @(paragraph.objectID);
}

@end
