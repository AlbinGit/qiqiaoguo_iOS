//
//  QGAttributeBuyCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/18.
//
//

#import "QGAttributeBuyCell.h"

@implementation QGAttributeBuyCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)minusClick:(id)sender
{
    int num = [_buyNumLbl.text intValue];
    if (num > 1)
    {
        num--;
        _buyNumLbl.text = [NSString stringWithFormat:@"%d",num];
        if (_buyCellBlock)
        {
            _buyCellBlock(num);
        }
        NSLog(@"%@",_buyNumLbl.text);
    }
    else if (num == 1)
    {
        [[SAProgressHud sharedInstance] showSuccessWithWindow:@"亲,不能在减了额!"];
    }
    
}
- (IBAction)addClick:(id)sender {
    
    int num = [_buyNumLbl.text intValue];
    if (num < 99)
    {
        num++;
        _buyNumLbl.text = [NSString stringWithFormat:@"%d",num];
        NSLog(@"%@",_buyNumLbl.text);
        if (_buyCellBlock) {
            _buyCellBlock(num);
        }

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
