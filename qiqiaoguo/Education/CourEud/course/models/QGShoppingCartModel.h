//
//  QGShoppingCartModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/9/12.
//
//

#import <Foundation/Foundation.h>

@interface QGShoppingCartModel : NSObject
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *sid;
@property (nonatomic,strong) NSArray *goodsList;
@end
