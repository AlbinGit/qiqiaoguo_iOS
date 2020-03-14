//
//  BLUPostDetailNode+Text.h
//  Blue
//
//  Created by Bowen on 22/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailNode.h"

@interface BLUPostDetailNode (Text) <ASTextNodeDelegate>

- (NSDictionary *)titleAttributes;
- (NSDictionary *)contentAttributes;
- (NSDictionary *)circleFromAttributes;
- (NSDictionary *)circleAttributes;

- (NSAttributedString *)attributedTitle:(NSString *)title;
- (NSAttributedString *)attributedContent:(NSString *)content;
- (NSAttributedString *)attributedCircle:(BLUCircle *)circle;
- (NSAttributedString *)attributedTags:(NSArray *)tags;
- (NSAttributedString *)attributedNumberOfLikedUsers:(NSInteger)number;
- (NSAttributedString *)attributedLink:(NSString *)content;
- (NSArray *)circleLinkedAttributedNames;
- (NSArray *)tagLinkedAttributedNames;

@end
