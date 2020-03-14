//
//  QGOrgTeacherTableViewCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/20.
//
//

#import "QGOrgTeacherTableViewCell.h"




@interface QGOrgTeacherTableViewCell ()

@property (nonatomic,strong) NSMutableArray *arrM;
@end
@implementation QGOrgTeacherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    _arrM = [NSMutableArray array];
    

    
    
    
}


- (void)setTeacherModel:(QGTeacherListModel *)teacherModel {
    
    _teacherModel = teacherModel;
    self.teacherdeil.text = _teacherModel.signature;
    [self.headIma sd_setImageWithURL:[NSURL URLWithString:_teacherModel.head_img] placeholderImage:nil]; ;

    self.teachername.text = _teacherModel.name;
    
    
    
}

- (void)setModel:(QGEduTeacherModel *)model {
    
    _model = model;
    self.teacherdeil.text = _model.signature;
    [self.headIma sd_setImageWithURL:[NSURL URLWithString:_model.head_img] placeholderImage:nil]; ;

    self.teachername.text = model.name;
    
    _teacherdeil.text = [NSString stringWithFormat:@"%@位老师",model.teacher_count];
    NSMutableArray *arr = [NSMutableArray array];
    
    
    for ( QGCourseTagModel *tag  in model.tagList) {
        [arr addObject:tag.tag_name];
    }
    [_arrM addObjectsFromArray:arr];
    QGTypeView* view = [[QGTypeView alloc] initWithFrame:CGRectMake(self.headIma.maxX , self.teacherdeil.maxY+5, MQScreenW, 45) andDatasource:_arrM :nil];
    
    [self.contentView addSubview:view];
     [_adress setTitle:model.address ];
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
