//
//  QGSearchScreeningSelectView.m
//  qiqiaoguo
//
//  Created by cws on 16/9/8.
//
//

#import "QGSearchScreeningSelectView.h"
#import "QGTableView.h"
#import "QGSearchScreeningModel.h"
#import "QGScreeningCell.h"

@interface QGSearchScreeningSelectView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)QGTableView *tableView;
@property (nonatomic, strong)QGTableView *leftTableView;
@property (nonatomic, strong)QGTableView *rightTableView;
@property (nonatomic, strong)UIView *contentView;

@property (nonatomic, copy)NSIndexPath *leftSelectIndexPath;
@property (nonatomic, assign)NSInteger sortSelectID;

@property (nonatomic, strong)UIView *blackView;

@end


static const CGFloat cellHeight = 48;
static const CGFloat contentViewMaxHeight = cellHeight * 5.5;

@implementation QGSearchScreeningSelectView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];

    }
    return self;
}


- (void)configUI{
    
    self.clipsToBounds = YES;
    _tableView = [QGTableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _leftTableView = [QGTableView new];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.backgroundColor = APPBackgroundColor;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _rightTableView = [[QGTableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rightTableView.backgroundColor = [UIColor whiteColor];
    [_rightTableView registerClass:[QGScreeningCell class] forCellReuseIdentifier:@"QGScreeningCell"];
    
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor whiteColor];
    
    [_contentView addSubview:_tableView];
    [_contentView addSubview:_leftTableView];
    [_contentView addSubview:_rightTableView];
    [self addSubview:_contentView];
    
    
    
    _contentView.frame = CGRectMake(0, -300, MQScreenW, 300);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(_contentView);
    }];
    [_leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_contentView);
        make.width.equalTo(@(MQScreenW/3));
    }];
    [_rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(_contentView);
        make.left.equalTo(_leftTableView.mas_right);
    }];
    _blackView = [UIView new];
    [self addSubview:_blackView];
    
    [_blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(_contentView.mas_bottom);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    [_blackView addGestureRecognizer:tap];
    
}

- (void)setType:(QGSearchOptionType)type{
    _type = type;
    if (type == QGSearchOptionTypeCourse) {
        _model = _courseModel;
        return;
    }
    _model = _orgModel;
}

- (void)setSelectType:(QGScreeningSelectType)selectType{
    _selectType = selectType;
    if (_selectType == QGScreeningSelectTypeCourseCate) {
        _tableView.hidden = YES;
        _leftTableView.hidden = NO,
        _rightTableView.hidden = NO;
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
    }else{
        _tableView.hidden = NO;
        _leftTableView.hidden = YES,
        _rightTableView.hidden = YES;
        [self.tableView reloadData];
    }
    [self updateUI];
}

- (void)setLeftTabselectedID:(NSInteger)leftTabselectedID{
    _leftTabselectedID = leftTabselectedID;
    [_rightTableView reloadData];
    [_leftTableView reloadData];
    [self selectRightTable];
    [self updateUI];
}

- (void)setCateID:(NSInteger)cateID{
    
    _cateID = cateID;
    _selectCouseID = cateID;

}

- (void)show{
    if (!self.hidden) {
        return;
    }
    self.hidden = NO;
    
    [UIView animateWithDuration:.2 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _contentView.Y = 0;
    }];
    
    UITableViewCell *cell = [_leftTableView cellForRowAtIndexPath:_leftSelectIndexPath];
    [cell setSelected:YES animated:NO];
}

- (void)hidden{
    if (self.hidden) {
        return;
    }
    [UIView animateWithDuration:.2 animations:^{
        _contentView.Y = -_contentView.height;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
}

- (void)resetOptions{
    self.leftTabselectedID = NSNotFound;
    self.tabselectedID = NSNotFound;
    self.areaSelectID = NSNotFound;
    self.sortSelectID = NSNotFound;
    self.selectCouseID = NSNotFound;
    self.leftSelectIndexPath = nil;
}

- (void)hiddenView{
    if ([self.delegate respondsToSelector:@selector(shouldSelectedWithModel:selectType:)]) {
        [self.delegate shouldSelectedWithModel:nil selectType:self.selectType];
    }
}

- (void)updateUI{
    
    if (self.selectType == QGScreeningSelectTypeCourseCate){
        
        CGFloat biggerHeight = _rightTableView.contentSize.height > _leftTableView.contentSize.height ? _rightTableView.contentSize.height : _leftTableView.contentSize.height;
        
        _contentView.height = biggerHeight < contentViewMaxHeight ? biggerHeight : contentViewMaxHeight;
        
        return;
    }
    _contentView.height = _tableView.contentSize.height < contentViewMaxHeight ? _tableView.contentSize.height : contentViewMaxHeight;
    
}

- (NSArray *)rightTableViewData{
    NSArray *arr = nil;
    NSArray *leftArr = self.type == QGSearchOptionTypeCourse ? _model.courseCateList :_model.orgCateList;
    for ( QGScreeningModel *model in leftArr) {
        if (model.courseID == _leftTabselectedID) {
            NSArray *arr = model.subListArray;
            return arr;
        }
    }
    
    return arr;
}

- (QGScreeningModel *)getRightTableViewModel{
    QGScreeningModel *arr = nil;
    NSArray *leftArr = self.type == QGSearchOptionTypeCourse ? _model.courseCateList :_model.orgCateList;
    for ( QGScreeningModel *model in leftArr) {
        if (model.courseID == _leftTabselectedID) {
            return model;
        }
    }
    
    return arr;
}

- (void)selectRightTable{
    NSArray *rightData = [self rightTableViewData];
    NSInteger section = NSNotFound;
    NSInteger row = NSNotFound;
    for (int i = 0; i < rightData.count; i++) {
        section = i;
        QGScreeningModel *model = rightData[i];
        for (int j = 0; j < model.subListArray.count; j++) {
            row = j;
            QGScreeningModel *submodel = model.subListArray[j];
            if (self.selectCouseID == submodel.courseID) {
                NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:section];
                [self.rightTableView scrollToRowAtIndexPath:index
                                        atScrollPosition:UITableViewScrollPositionTop animated:YES];
                return;
            }
        }
    }
}

#pragma mark table - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView != _rightTableView) {
        return 1;
    }
    NSArray *rightData = [self rightTableViewData];
    
    return rightData.count ?: 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _leftTableView) {
        NSArray *arr = self.type == QGSearchOptionTypeCourse ? _model.courseCateList : _model.orgCateList;
        return arr.count;
    }
    if (tableView == _rightTableView){
        return 1;
    }
    if (self.selectType == QGScreeningSelectTypeArea ) {
        return _model.areaList.count;
    }
    
    return _model.sortList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QGScreeningModel *model = [self tableview:tableView modelForIndexPath:indexPath];
    
    if (tableView == _rightTableView) {
        
        QGScreeningCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QGScreeningCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectID = self.selectCouseID;
        QGScreeningModel *model = [self getRightTableViewModel];
        QGScreeningModel *cellModel = model.subListArray[indexPath.section];
        cell.ScreeningModel = cellModel;

        @weakify(self);
        cell.btnBlock = ^(QGScreeningModel *model){
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(shouldSelectedWithModel:selectType:)]) {
                [self.delegate shouldSelectedWithModel:model selectType:self.selectType];
                self.selectCouseID = model.courseID;
            }
        };
        return cell;
    }
    
    
    static NSString *reuseId = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.textLabel.textColor = QGMainContentColor;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.text = model.name;
    if (tableView == _leftTableView) {
        cell.backgroundColor = APPBackgroundColor;
        cell.selectedBackgroundView = [UIView new];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        if (_leftTabselectedID == model.courseID && model.courseID > 0) {
            self.leftSelectIndexPath = indexPath;
        }

    }else{
        if ((_areaSelectID == model.courseID && self.selectType == QGScreeningSelectTypeArea) || (_sortSelectID == model.courseID && self.selectType == QGScreeningSelectTypeSort)) {
            cell.textLabel.textColor = QGMainRedColor;
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView ==_rightTableView) {
        return;
    }
    
    if (tableView == _leftTableView) {
        NSArray *arr = self.type == QGSearchOptionTypeCourse ?    _model.courseCateList : _model.orgCateList;
        QGScreeningModel *model = [arr[indexPath.row] copy];
        if (indexPath.row ==0) {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            _leftSelectIndexPath = nil;
            _leftTabselectedID = NSNotFound;
//            [self hidden];
            if ([model.name isEqualToString:@"全部"]) {
                model.name = @"全部分类";
            }
            if ([self.delegate respondsToSelector:@selector(shouldSelectedWithModel:selectType:)]) {
                [self.delegate shouldSelectedWithModel:model selectType:self.selectType];
            }
            return;
        }
        
        if (_leftSelectIndexPath != indexPath && _leftSelectIndexPath) {
            UITableViewCell *cell = [_leftTableView cellForRowAtIndexPath:_leftSelectIndexPath];
            [cell setSelected:NO animated:NO];
        }
        self.leftTabselectedID = model.courseID;
        self.leftSelectIndexPath = indexPath;
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *arr = _selectType == QGScreeningSelectTypeArea ? _model.areaList : _model.sortList;
    QGScreeningModel *model = [arr[indexPath.row] copy];
    if (_selectType == QGScreeningSelectTypeArea) {
        _areaSelectID = model.courseID;
        if ([model.name isEqualToString:@"全部"]) {
            model.name = @"全部区域";
        }
    }else{
        _sortSelectID = model.courseID;
    }
    if ([self.delegate respondsToSelector:@selector(shouldSelectedWithModel:selectType:)]) {
        [self.delegate shouldSelectedWithModel:model selectType:self.selectType];
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView != _rightTableView) {
        return nil;
    }
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MQScreenW, 41)];
    UILabel *label = [UILabel makeThemeLabelWithType:BLULabelTypeMainContent];
    [headerView addSubview:label];

    headerView.backgroundColor = [UIColor whiteColor];
    NSArray *arr = [self rightTableViewData];
    QGScreeningModel *model = arr[section];

    label.text = model.name;
    [label sizeToFit];
    label.X = 10;
    label.Y= 10;
    
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _rightTableView) {
        
        CGSize size = [self.rightTableView sizeForCellWithCellClass:[QGScreeningCell class] cacheByIndexPath:indexPath width:MQScreenW/3*2 configuration:^(QGCell *cell) {
            QGScreeningCell *screeningcell = cell;
            QGScreeningModel *model = [self getRightTableViewModel];
            screeningcell.ScreeningModel = model.subListArray[indexPath.section];
            
        }];
        return size.height;
    }
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView ==_rightTableView) {
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000001;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_leftSelectIndexPath) {
        
        UITableViewCell *cell = [_leftTableView cellForRowAtIndexPath:_leftSelectIndexPath];
        [cell setSelected:YES animated:NO];
    }
    if (_sortSelectID > 0 && self.selectType == QGScreeningSelectTypeSort) {
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.textLabel.textColor = QGMainContentColor;
    }

}


- (QGScreeningModel *)tableview:(UITableView *)tableView modelForIndexPath:(NSIndexPath *)indexPath {
    QGScreeningModel *screeningmodel = nil;
    
    if (tableView == _leftTableView) {
        NSArray *arr = self.type == QGSearchOptionTypeCourse ? _model.courseCateList : _model.orgCateList;
        screeningmodel = arr[indexPath.row];
    }else if (tableView == _rightTableView){
        NSArray *rightData = [self rightTableViewData];
        screeningmodel = rightData[indexPath.section];
        return screeningmodel.subListArray[indexPath.row];
    }else{
        if (self.selectType == QGScreeningSelectTypeArea) {
            screeningmodel = _model.areaList[indexPath.row];
        }else if (self.selectType == QGScreeningSelectTypeSort){
            screeningmodel = _model.sortList[indexPath.row];
        }
    }
    
    return screeningmodel;
}

@end
