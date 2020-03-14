//
//  UIView+BLUHierarchy.h
//  Blue
//
//  Created by Bowen on 26/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class UICollectionView, UITableView, NSArray;
//
///*!
// @category UIView (BLU_UIView_Hierarchy)
// 
//	@abstract UIView hierarchy category.
// */
//@interface UIView (BLU_UIView_Hierarchy)
//
///*!
// @method viewController:
// 
// @return Returns the UIViewController object that manages the receiver.
// */
//@property (nonatomic, readonly, strong) UIViewController *viewController;
//
///*!
// @method superScrollView:
// 
// @return Returns the UIScrollView object if any found in view's upper hierarchy.
// */
//@property (nonatomic, readonly, strong) UIScrollView *superScrollView;
//
///*!
// @method superTableView:
// 
// @return Returns the UITableView object if any found in view's upper hierarchy.
// */
//@property (nonatomic, readonly, strong) UITableView *superTableView;
//
///*!
// @method superCollectionView:
// 
// @return Returns the UICollectionView object if any found in view's upper hierarchy.
// */
//@property (nonatomic, readonly, strong) UICollectionView *superCollectionView;
//
///*!
// @method responderSiblings:
// 
// @return returns all siblings of the receiver which canBecomeFirstResponder.
// */
//@property (nonatomic, readonly, copy) NSArray *responderSiblings;
//
///*!
// @method deepResponderViews:
// 
// @return returns all deep subViews of the receiver which canBecomeFirstResponder.
// */
//@property (nonatomic, readonly, copy) NSArray *deepResponderViews;
//
///*!
// @method isInsideSearchBar:
// 
// @return returns YES if the receiver object is UISearchBarTextField, otherwise return NO.
// */
//@property (nonatomic, getter=isSearchBarTextField, readonly) BOOL searchBarTextField;
//
///*!
// @method isAlertViewTextField:
// 
// @return returns YES if the receiver object is UIAlertSheetTextField, otherwise return NO.
// */
//@property (nonatomic, getter=isAlertViewTextField, readonly) BOOL alertViewTextField;
//
///*!
// @method convertTransformToView::
// 
// @return returns current view transform with respect to the 'toView'.
// */
//-(CGAffineTransform)convertTransformToView:(UIView*)toView;
//
///*!
// @method subHierarchy:
// 
// @return Returns a string that represent the information about it's subview's hierarchy. You can use this method to debug the subview's positions.
// */
//@property (nonatomic, readonly, copy) NSString *subHierarchy;
//
///*!
// @method superHierarchy:
// 
// @return Returns an string that represent the information about it's upper hierarchy. You can use this method to debug the superview's positions.
// */
//@property (nonatomic, readonly, copy) NSString *superHierarchy;
//
//
//@end
//
///*!
// @category UIView (BLU_UIView_Frame)
// 
//	@abstract UIView frame category.
// */
@interface UIView (BLU_UIView_Frame)

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat x, y, width, height;
@property (nonatomic, assign) CGFloat left, right, top, bottom;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, readonly) CGPoint boundsCenter;

@end
