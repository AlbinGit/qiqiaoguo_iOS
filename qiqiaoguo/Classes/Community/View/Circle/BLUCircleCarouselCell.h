//
//  BLUCircleCarouselCell.h
//  Blue
//
//  Created by Bowen on 3/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCell.h"
#import "BLUAdTransitionProtocal.h"

@interface BLUCircleCarouselCell : BLUCell

@property (nonatomic, weak) id <BLUAdTransitionDelegate> delegate;
@property (nonatomic, strong) NSArray *ads;
- (void)startCarousel;
- (void)stopCarousel;
- (void)setPageViewFrame:(CGRect)rect;

@end
