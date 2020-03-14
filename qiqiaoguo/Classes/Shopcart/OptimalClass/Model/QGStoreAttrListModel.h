//
//  QGStoreAttrListModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/18.
//
//

#import <Foundation/Foundation.h>

@interface QGStoreAttrListModel : NSObject
@property (nonatomic,copy) NSString *attribute_id;
@property (nonatomic,strong) NSArray *attribute_value;

@property (nonatomic,copy) NSString *attribute_name;
@end
@interface QGStoreAttributeValueModel : NSObject
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString  *value;

@end