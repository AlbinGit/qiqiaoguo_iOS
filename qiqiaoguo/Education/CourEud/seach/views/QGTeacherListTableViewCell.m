//
//  QGOrgTeacherTableViewCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/20.
//
//

#import "QGTeacherListTableViewCell.h"




@interface QGTeacherListTableViewCell ()

@property (nonatomic,strong) NSMutableArray *arrM;
@end
@implementation QGTeacherListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    _arrM = [NSMutableArray array];
    

    
    
    
}


- (void)setTeacherModel:(QGTeacherListModel *)teacherModel {
    
    _teacherModel = teacherModel;
    self.teacherdeil.text = _teacherModel.signature;
    [self.headIma sd_setImageWithURL:[NSURL URLWithString:_teacherModel.head_img] placeholderImage:nil]; ;
    
    NSMutableArray *arr = [NSMutableArray array];
    
    
    for ( QGCourseTagModel *tag  in teacherModel.tagList) {
        [arr addObject:tag.tag_name];
    }
    [_arrM addObjectsFromArray:arr];
    QGTypeView* view = [[QGTypeView alloc] initWithFrame:CGRectMake(self.headIma.maxX , self.teacherdeil.maxY, MQScreenW, 45) andDatasource:_arrM :nil];
    
    [self.contentView addSubview:view];
    self.teachername.text = _teacherModel.name;
    
}

- (void)setModel:(QGEduTeacherModel *)model {
    
    _model = model;
    self.teacherdeil.text = _model.signature;
//    self.teacherdeil.text = _model.org_name;

    [self.headIma sd_setImageWithURL:[NSURL URLWithString:_model.head_img] placeholderImage:nil]; ;

    self.teachername.text = model.name;
    
    
    NSMutableArray *arr = [NSMutableArray array];
    
    
    for ( QGCourseTagModel *tag  in model.tagList) {
        [arr addObject:tag.tag_name];
    }
    [_arrM addObjectsFromArray:arr];
    QGTypeView* view = [[QGTypeView alloc] initWithFrame:CGRectMake(self.headIma.maxX , self.teacherdeil.maxY, MQScreenW, 45) andDatasource:_arrM :nil];
    
    [self.contentView addSubview:view];
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
