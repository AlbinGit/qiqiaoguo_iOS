//
//  BLUPostTagContainer.h
//  Blue
//
//  Created by Bowen on 2/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLUPostTagContainerDelegate.h"
#import "BLUTextView.h"

typedef NS_ENUM(NSInteger, BLUPostTagContainerTagStyle) {
    BLUPostTagContainerTagStyleSolid = 0,
    BLUPostTagContainerTagStyleHollow,
};

@interface BLUPostTagContainer : BLUTextView

@property (nonatomic, assign) BOOL deleteAble;
@property (nonatomic, assign) BOOL selectAble;
@property (nonatomic, strong) UIFont *tagFont;
@property (nonatomic, assign) BLUPostTagContainerTagStyle style;
@property (nonatomic, assign) UIEdgeInsets tagInset;
@property (nonatomic, assign) NSInteger maxTagsCount;
@property (nonatomic, assign) NSInteger maxSelectionCount;

@property (nonatomic, weak) id <BLUPostTagContainerDelegate> postTagContainerDelegate;

- (void)addTag:(BLUPostTag *)tag;
- (void)addTags:(NSArray *)tags;
- (void)insertTag:(BLUPostTag *)tag atIndex:(NSInteger)index;

- (NSArray *)allTags;

- (NSInteger)indexOfTag:(BLUPostTag *)tag;
- (BLUPostTag *)tagAtIndex:(NSInteger)index;
- (void)updateTagSelectionState:(BOOL)selection atIndex:(NSInteger)index;

- (void)removeTag:(BLUPostTag *)tag;
- (void)removeTagAtIndex:(NSInteger)index;
- (void)removeAllTags;
- (NSInteger)selectedCount;

@end
