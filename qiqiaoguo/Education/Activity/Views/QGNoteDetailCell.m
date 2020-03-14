//
//  QGNoteDetailCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/25.
//
//

#import "QGNoteDetailCell.h"






@implementation QGNoteDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
 
        _textNote = [[QGTextView alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-10, MQScreenH-54-54)];
      
//        _textNote.userInteractionEnabled = NO;
        _textNote.textColor = [UIColor colorFromHexString:@"3333333"];
        _textNote.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_textNote];
        
    
        _nullLab=[[UILabel alloc]init];
        _nullLab.font=FONT_CUSTOM(15);
        _nullLab.text=@"暂无详情";
        _nullLab.textColor=PL_COLOR_160;
        [self.contentView addSubview:_nullLab];
        PL_CODE_WEAK(weakSelf);
        [_nullLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.contentView);
        }];
    }
    return self;
}
@end
