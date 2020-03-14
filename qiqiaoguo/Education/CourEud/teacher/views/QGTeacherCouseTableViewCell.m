//
//  QGTeacherCouseTableViewCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/24.
//
//

#import "QGTeacherCouseTableViewCell.h"
#import "QGCourLIstGroupCollectionViewCell.h"

#import "QGCourseDetailViewController.h"
@interface QGTeacherCouseTableViewCell()

@property (nonatomic ,strong) UILabel *colorlable;

@property (nonatomic ,strong) UILabel *naneLable;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UILabel *linelable;

@end
@implementation QGTeacherCouseTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) { // 初始化子控件
        
        
         [self p_createUI];
      }
    return self;
}

- (void)p_createUI
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    [flow setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flow.minimumInteritemSpacing = 0;
    flow.minimumLineSpacing = 10;
    flow.itemSize = CGSizeMake(144, 140);
    flow.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 150) collectionViewLayout:flow];
    [self.collectionView registerNib:[UINib nibWithNibName:@"QGCourLIstGroupCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_collectionView];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    ;
    
    return _dataSource.count;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"cell";
    QGCourLIstGroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    QGEduCoursedeilModel *model = _dataSource[indexPath.row];
    
    [cell.groupImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_path] placeholderImage:nil];
    if ([model.type isEqualToString:@"3"] || [model.type isEqualToString:@"4"]) {
         cell.name.attributedText = [self configTitle:model.title];
    }else {
          cell.name.text = model.title;
    }
    cell.price.text =[NSString stringWithFormat:@"￥%@",model.class_price] ;
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   QGEduCoursedeilModel *model = _dataSource[indexPath.row];
    QGCourseDetailViewController *vc = [[QGCourseDetailViewController alloc] init];
    vc.course_id = model.id;
    
    UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    [viewController.navigationController pushViewController:vc animated:YES];
    NSLog(@"选择了%ld个cell",indexPath.row);
}
- (NSMutableAttributedString *)configTitle:(NSString *)title{
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",title]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    UIImageView *image =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"audition-icon"]];
    [image sizeToFit];
    attch.image = [UIImage imageNamed:@"audition-icon"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, -2,image.width, image.height);
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    
    return attri;
}



@end

