//
//  QGCourseDetail.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/20.
//
//

#import <UIKit/UIKit.h>

@interface QGCourseDetail : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *eduImge;
@property (weak, nonatomic) IBOutlet UIButton *teatherBtn;

@property (weak, nonatomic) IBOutlet UILabel *rangLab;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UILabel *theatherName;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *studentCount;

@property (weak, nonatomic) IBOutlet UILabel *adress;
@property (weak, nonatomic) IBOutlet UILabel *orgadress;
@property (weak, nonatomic) IBOutlet UIImageView *orgimage;
@property (weak, nonatomic) IBOutlet UILabel *yearCount;
@property (weak, nonatomic) IBOutlet UILabel *orgName;
@property (weak, nonatomic)  UIImageView *theatherImag;
@property (weak, nonatomic) IBOutlet UIButton *orgBtnClick;

@end
