//
//  QGCell.m
//  qiqiaoguo
//
//  Created by cws on 16/6/14.
//
//

#import "QGCell.h"

static void *const kSharedCellKey = "kSharedCellKey";

@implementation QGCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.cellSize = CGSizeZero;
        self.cellForCalcingSize = NO;
    }
    return self;
}

#pragma mark - Calc size for cell

+ (CGSize)sizeForLayoutedCellWith:(CGFloat)width sharedCell:(QGCell *)cell {
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    CGRect cellFrame = cell.frame;
    cellFrame.size.width = width;
    cell.frame = cellFrame;
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return cell.cellSize; // Need set cell size in layoutsubviews
}

+ (NSString *)defaultName {
    return NSStringFromClass(self);
}

+ (instancetype)sharedCell {
    Class selfClass = [self class];
    id instance = objc_getAssociatedObject(selfClass, kSharedCellKey);
    if (!instance) {
        instance = [[selfClass alloc] init];
        QGCell *cell = instance;
        cell.cellForCalcingSize = YES;
        objc_setAssociatedObject(selfClass, kSharedCellKey, instance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return instance;
}

+ (void)freeSharedCell {
    Class selfClass = [self class];
    objc_setAssociatedObject(selfClass, kSharedCellKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
