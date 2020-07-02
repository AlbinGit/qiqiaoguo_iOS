//
//  QGTeacherPassportController.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/18.
//

#import "QGViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QGTeacherPassportController : QGViewController
@property (nonatomic,strong) UIImage *porImg;//头像
@property (nonatomic,strong) NSString *name;//姓名
@property (nonatomic,strong) NSString *email;//邮箱
@property (nonatomic,assign) NSInteger sex;//性别
@property (nonatomic,assign) NSInteger degree;//学历
@property (nonatomic,assign) NSInteger provience;//省
@property (nonatomic,assign) NSInteger city;//市
@property (nonatomic,assign) NSInteger area;//区
@property (nonatomic,strong) NSString *detailAdress;//详细地址
@property (nonatomic,strong) NSString *school;//学校
@property (nonatomic,strong) NSString *major;//专业
@property (nonatomic,strong) NSString *teach_experience;//年龄
@property (nonatomic,assign) NSInteger role_type;//身份



@property (nonatomic,strong) NSString *cardID;//身份证
@property (nonatomic,strong) NSString *passportID;//护照ID
@property (nonatomic,strong) NSString *combineImgUrl;//
@property (nonatomic,strong) NSString *frontImgUrl;//
@property (nonatomic,assign) NSString *backImgUrl;//
@property (nonatomic,strong) NSString *pass_combineImgUrl;//
@property (nonatomic,strong) NSString *pass_frontImgUrl;//
@property (nonatomic,assign) NSString *pass_backImgUrl;//


@end

NS_ASSUME_NONNULL_END
