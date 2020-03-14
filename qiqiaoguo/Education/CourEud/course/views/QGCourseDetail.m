//
//  QGCourseDetail.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/20.
//
//

#import "QGCourseDetail.h"

@interface QGCourseDetail ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1;


@end

@implementation QGCourseDetail

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.view1.constant= 0.5;
    _eduImge.layer.masksToBounds = YES;
    _eduImge.layer.cornerRadius = 5;
}
@end
