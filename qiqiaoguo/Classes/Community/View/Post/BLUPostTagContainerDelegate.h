//
//  BLUPostTagContainerDelegate.h
//  Blue
//
//  Created by Bowen on 8/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLUPostTag, BLUPostTagContainer;

@protocol BLUPostTagContainerDelegate <NSObject>

@optional
- (void)containerDidSelectedTag:(BLUPostTag *)tag atIndex:(NSInteger)index container:(BLUPostTagContainer *)container;
- (void)containerSelectNoneTag:(BLUPostTagContainer *)container;
- (void)containerDidDeselectedTag:(BLUPostTag *)tag atIndex:(NSInteger)index container:(BLUPostTagContainer *)container;
- (void)containerTagsDidChange:(NSArray *)tags container:(BLUPostTagContainer *)container;
- (void)containerDidAddTag:(BLUPostTag *)tag container:(BLUPostTagContainer *)container;
- (void)containerDidRemoveTag:(BLUPostTag *)tag atIndex:(NSInteger)index container:(BLUPostTagContainer *)container;
- (void)containerDidEndEditing:(BLUPostTagContainer *)container;
- (void)containerNeedResize:(BLUPostTagContainer *)container;
- (void)containerDidReceiveDulicateTag:(BLUPostTag *)tag container:(BLUPostTagContainer *)container;
- (void)containerCannotAddTagAnymore:(BLUPostTag *)tag container:(BLUPostTagContainer *)container;
- (void)containerDidChanged:(BLUPostTagContainer *)container;

@end
