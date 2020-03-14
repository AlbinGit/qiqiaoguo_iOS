//
//  QGTimerLabel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/12.
//
//

#import <UIKit/UIKit.h>


typedef enum{
    QGTimerLabelTypeStopWatch,
    QGTimerLabelTypeTimer
}QGTimerLabelType;


 
@class QGTimerLabel;
@protocol QGTimerLabelDelegate <NSObject>
@optional
-(void)timerLabel:(QGTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime;
-(void)timerLabel:(QGTimerLabel*)timerLabel countingTo:(NSTimeInterval)time timertype:(QGTimerLabelType)timerType;
-(NSString*)timerLabel:(QGTimerLabel*)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time;
@end


@interface QGTimerLabel : UILabel;

@property (nonatomic,weak) id<QGTimerLabelDelegate> delegate;

@property (nonatomic,copy) NSString *timeFormat;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic, assign) NSRange textRange;

@property (nonatomic, strong) NSDictionary *attributedDictionaryForTextInRange;

@property (assign) QGTimerLabelType timerType;

@property (assign,readonly) BOOL counting;

@property (assign) BOOL resetTimerAfterFinish;


@property (assign,nonatomic) BOOL shouldCountBeyondHHLimit;

#if NS_BLOCKS_AVAILABLE
@property (copy) void (^endedBlock)(NSTimeInterval);
#endif



-(id)initWithTimerType:(QGTimerLabelType)theType;
-(id)initWithLabel:(UILabel*)theLabel andTimerType:(QGTimerLabelType)theType;
-(id)initWithLabel:(UILabel*)theLabel;

-(id)initWithFrame:(CGRect)frame label:(UILabel*)theLabel andTimerType:(QGTimerLabelType)theType;


-(void)start;
#if NS_BLOCKS_AVAILABLE
-(void)startWithEndingBlock:(void(^)(NSTimeInterval countTime))end; //use it if you are not going to use delegate
#endif
-(void)pause;
-(void)reset;


-(void)setCountDownTime:(NSTimeInterval)time;
-(void)setStopWatchTime:(NSTimeInterval)time;
-(void)setCountDownToDate:(NSDate*)date;

-(void)addTimeCountedByTime:(NSTimeInterval)timeToAdd;

- (NSTimeInterval)getTimeCounted;
- (NSTimeInterval)getTimeRemaining;
- (NSTimeInterval)getCountDownTime;





@end


