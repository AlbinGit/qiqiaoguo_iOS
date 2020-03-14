//
//  BLUPostCommonVideoNode+TextStyle.h
//  Blue
//
//  Created by Bowen on 2/2/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUPostCommonVideoNode.h"

@interface BLUPostCommonVideoNode (TextStyle)

- (NSAttributedString *)attributedTitlte:(NSString *)title;
- (NSAttributedString *)attributedTime:(NSString *)time;
- (NSAttributedString *)attributedNumberOfComments:(NSNumber *)count;
- (NSAttributedString *)attributedNumberOfViews:(NSNumber *)count;

@end
