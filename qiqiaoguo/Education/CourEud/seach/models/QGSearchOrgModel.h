//
//  QGSearchOrgModel.h
//  LongForTianjie
//
//  Created by 李姝睿 on 15/11/17.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QGSearchOrgModel : NSObject

/**机构id*/
@property (nonatomic, copy)NSString *org_id;
/**机构名称*/
@property (nonatomic, copy)NSString *name;
/**名称缩写*/
@property (nonatomic, copy)NSString *name_short;
/**机构图片*/
@property (nonatomic, copy)NSString *head_img;


/**地址*/
@property (nonatomic, copy)NSString *address;
/**经纬度*/
@property (nonatomic, copy)NSString *longlat;
@property (nonatomic, copy)NSString *licence_number;

@property (nonatomic,copy) NSString *teacher_count;
/**签名*/
@property (nonatomic, copy)NSString *signature;
/**介绍*/
@property (nonatomic, copy)NSString *intro;
@property (nonatomic, copy)NSString *licence_audit;
@property (nonatomic,strong) NSArray *tagList;
@end
@interface QGsearchOrgTagmodel : NSObject

@property (nonatomic,copy) NSString *tag_id;
@property (nonatomic,copy)NSString *tag_name;

@end