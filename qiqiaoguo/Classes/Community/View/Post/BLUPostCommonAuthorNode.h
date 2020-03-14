//
//  BLUPostCommonAuthorNode.h
//  Blue
//
//  Created by Bowen on 11/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "ASControlNode.h"

@interface BLUPostCommonAuthorNode : ASControlNode

@property (nonatomic, strong) ASImageNode *genderNode;
@property (nonatomic, strong) ASTextNode *nameNode;
@property (nonatomic, strong) ASTextNode *timeNode;

@property (nonatomic, strong) BLUUser *author;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, assign) BOOL anonymous;

- (instancetype)initWithAuthor:(BLUUser *)author
                    createDate:(NSDate *)createDate
                     anonymous:(BOOL)anonymous;

@end
