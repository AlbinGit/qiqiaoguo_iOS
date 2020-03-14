//
//  QGGoodLogisticsCell.h
//  qiqiaoguo
//
//  Created by cws on 16/7/28.
//
//

#import "QGCell.h"

@class QGLogisticsDetails;

@interface QGGoodLogisticsCell : QGCell

@property (nonatomic, assign) BOOL emphasis;

@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) CALayer *horizonSeparator;
@property (nonatomic, strong) CALayer *topLine;
@property (nonatomic, strong) CALayer *bottomLine;
@property (nonatomic, strong) CALayer *dot;
@property (nonatomic, strong) CALayer *emphasisDot;

@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) CGFloat elementSpacing;
@property (nonatomic, assign) CGSize emphasisDotSize;
@property (nonatomic, assign) CGFloat emphasisDotLeftInset;
@property (nonatomic, assign) CGFloat emphasisDotRightInset;
@property (nonatomic, assign) CGSize dotSize;

@property (nonatomic, strong) UIColor *emphasisColor;

@property (nonatomic, strong) QGLogisticsDetails *detail;
@end
