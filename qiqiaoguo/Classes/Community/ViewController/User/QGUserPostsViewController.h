//
//  QGUserPostsViewController.h
//  qiqiaoguo
//
//  Created by cws on 16/7/16.
//
//

#import "QGViewController.h"
#import "QGHttpManager+User.h"

@interface QGUserPostsViewController : QGViewController
@property (nonatomic, assign, getter=isEditAble) BOOL editAble;
@property (nonatomic, assign)UserPostType type;
@end
