//
//  QGOptimalProductGridLayout.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/11.
//
//

#import "QGOptimalProductGridLayout.h"

@interface QGOptimalProductGridLayout()
/** 所有的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
@end

@implementation QGOptimalProductGridLayout

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    [self.attrsArray removeAllObjects];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    if (_cellType ==QGOptimalProductGridLayoutOne) {
        
        
        for (int i = 0; i < 1; i++) {
            // 创建UICollectionViewLayoutAttributes
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            // 设置布局属性
            CGFloat width = self.collectionView.frame.size.width ;
            if (i == 0) {
                
                attrs.frame = CGRectMake(0, 0, width, width*0.5);
            }
            
            
            // 添加UICollectionViewLayoutAttributes
            [self.attrsArray addObject:attrs];
        }
           }else if (_cellType == QGOptimalProductGridLayoutTwo){
        
               for (int i = 0; i < count; i++) {
                   // 创建UICollectionViewLayoutAttributes
                   NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                   UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                   
                   // 设置布局属性
                   CGFloat width = self.collectionView.frame.size.width * 0.5;
                   if (i == 0) {
                       
                       attrs.frame = CGRectMake(0, 0, width, width*0.5);
                   } else if (i == 2) {
                       
                       attrs.frame = CGRectMake(width, 0,width, width*0.5);
                   } else if (i == 1) {
                       
                       attrs.frame = CGRectMake(0, width*0.5, width,width*0.5);
                   }
                   else if (i == 3) {
                       
                       attrs.frame = CGRectMake(width,width*0.5, width, width*0.5);
                   }
                   
                   
                   // 添加UICollectionViewLayoutAttributes
                   [self.attrsArray addObject:attrs];
               }

        
           }else if(_cellType == QGOptimalProductGridLayoutThree){
               
               
               for (int i = 0; i < count; i++) {
                   // 创建UICollectionViewLayoutAttributes
                   NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                   UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                   
                   // 设置布局属性
                   CGFloat width = self.collectionView.frame.size.width * 0.5;
                   if (i == 0) {
                       
                       attrs.frame = CGRectMake(0, 0, width*2, width*0.5);
                   } else if (i == 1) {
                       
                       attrs.frame = CGRectMake(0, width*0.5,width*2, width*0.5);
                   }
                   
                   
                   // 添加UICollectionViewLayoutAttributes
                   [self.attrsArray addObject:attrs];
               }
               
               
           }else if (_cellType == QGOptimalProductGridLayoutFour){
               
               
               for (int i = 0; i < count; i++) {
                   // 创建UICollectionViewLayoutAttributes
                   NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                   UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                   
                   // 设置布局属性
        
                  CGFloat width = self.collectionView.frame.size.width*0.5;
                   if (i == 0) {
                       
                       attrs.frame = CGRectMake(0, 0, width, width);
                   } else if (i == 1) {
                       
                       attrs.frame = CGRectMake(width, 0,width, width*0.5);
                   } else if (i == 2) {
                       
                       attrs.frame = CGRectMake(width, width*0.5, width*0.5,width*0.5);
                   }
                   else if (i == 3) {
                       
                       attrs.frame = CGRectMake(width+width*0.5,width*0.5, width*0.5, width*0.5);
                   }
                   
                   
                   // 添加UICollectionViewLayoutAttributes
                   [self.attrsArray addObject:attrs];
               }
               
               
               
               
           }if (_cellType == QGOptimalProductGridLayoutFive) {
               
               for (int i = 0; i < count; i++) {
                   // 创建UICollectionViewLayoutAttributes
                   NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                   UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                   
                   // 设置布局属性
                   
                   CGFloat heigth = self.collectionView.frame.size.width*0.5;
                   CGFloat width = self.collectionView.frame.size.width/3;
                   if (i == 0) {
                       
                       attrs.frame = CGRectMake(0, 0, width, heigth);
                   } else if (i == 1) {
                       
                       attrs.frame = CGRectMake(width, 0,width, heigth);
                   } else if (i == 2) {
                       
                       attrs.frame = CGRectMake(width*2, 0, width,heigth*0.5);
                   }
                   else if (i == 3) {
                       
                       attrs.frame = CGRectMake(width*2,heigth*0.5, width, heigth*0.5);
                   }
                   
                   
                   // 添加UICollectionViewLayoutAttributes
                   [self.attrsArray addObject:attrs];
               }
               
               
               
           }if (_cellType == QGOptimalProductGridLayoutSix) {
               
               
               for (int i = 0; i < count; i++) {
                   // 创建UICollectionViewLayoutAttributes
                   NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                   UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                   
                   // 设置布局属性
                   
                   CGFloat heigth = self.collectionView.frame.size.width*0.5;
                   CGFloat width = self.collectionView.frame.size.width/3;
                   if (i == 0) {
                       
                       attrs.frame = CGRectMake(0, 0, width, heigth);
                   } else if (i == 1) {
                       
                       attrs.frame = CGRectMake(width, 0, width*2,heigth*0.5);
                   } else if (i == 2) {
                       
                       attrs.frame = CGRectMake(width, heigth*0.5, width*2,heigth*0.5);
                   }
                 
                   
                   // 添加UICollectionViewLayoutAttributes
                   [self.attrsArray addObject:attrs];
               }
                  }else if (_cellType == QGOptimalProductGridLayoutSeven){
                    for (int i = 0; i < count; i++) {
                   // 创建UICollectionViewLayoutAttributes
                   NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                   UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                   
                   // 设置布局属性
                   
                   CGFloat heigth = self.collectionView.frame.size.width*0.5;
                   CGFloat width = self.collectionView.frame.size.width/3;
                   if (i == 0) {
                       
                       attrs.frame = CGRectMake(0, 0,width*2, heigth*0.5);
                   } else if (i == 1) {
                       
                       attrs.frame = CGRectMake(0, heigth*0.5, width*2,heigth*0.5);
                   } else if (i == 2) {
                       
                       attrs.frame = CGRectMake(width*2, 0, width,heigth);
                   }
                   
                   
                   // 添加UICollectionViewLayoutAttributes
                   [self.attrsArray addObject:attrs];
               }
               
               
           }else if (_cellType ==  QGOptimalProductGridLayoutEight) {
                     for (int i = 0; i < count; i++) {
               // 创建UICollectionViewLayoutAttributes
               NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
               UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
               
               // 设置布局属性
               
               CGFloat heigth = self.collectionView.frame.size.width*0.5;
               CGFloat width = self.collectionView.frame.size.width/3;
               
               if (i == 0) {
                   
                   attrs.frame = CGRectMake(0, 0, width, heigth);
               } else if (i == 1) {
                   
                   attrs.frame = CGRectMake(width,0, width, heigth);
               } else if (i == 2) {
                   
                   attrs.frame = CGRectMake(width*2, 0, width, heigth);
               }
                         // 添加UICollectionViewLayoutAttributes
                         [self.attrsArray addObject:attrs];
               
            }
                }else if (_cellType == QGOptimalProductGridLayoutNine){
               
               
               for (int i = 0; i < count; i++) {
                   // 创建UICollectionViewLayoutAttributes
                   NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                   UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                   
                   // 设置布局属性
                   CGFloat width = self.collectionView.frame.size.width * 0.5;
                   if (i == 0) {
                       
                       attrs.frame = CGRectMake(0, 0, width, width);
                   } else if (i == 1) {
                       
                       attrs.frame = CGRectMake( width,0,width, width);
                   }
                   
                   
                   // 添加UICollectionViewLayoutAttributes
                   [self.attrsArray addObject:attrs];
               }
           }
  
  
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

/**
 * 返回collectionView的内容大小
 */
- (CGSize)collectionViewContentSize
{
    
    if (_cellType == QGOptimalProductGridLayoutOne){
   
        
        
    CGFloat rowH = self.collectionView.frame.size.width * 0.5;
    return CGSizeMake(0,rowH);
        
    }else if(_cellType == QGOptimalProductGridLayoutSix || _cellType == QGOptimalProductGridLayoutSeven || _cellType ==  QGOptimalProductGridLayoutEight) {
      
        
    int count = (int)[self.collectionView numberOfItemsInSection:0];
    int rows = (count + 3 - 1) / 3;
    CGFloat rowH = self.collectionView.frame.size.width * 0.5;
    return CGSizeMake(0, rows * rowH);
        
        
    }else if (_cellType ==QGOptimalProductGridLayoutThree || _cellType == QGOptimalProductGridLayoutNine) {
        
        int count = (int)[self.collectionView numberOfItemsInSection:0];
        int rows = (count + 2 - 1) / 2;
        CGFloat rowH = self.collectionView.frame.size.width * 0.5;
        return CGSizeMake(0, rows * rowH);
        
    }else {
        int count = (int)[self.collectionView numberOfItemsInSection:0];
        int rows = (count + 4 - 1) / 4;
        CGFloat rowH = self.collectionView.frame.size.width * 0.5;
        return CGSizeMake(0, rows * rowH);
        
        
        
    }
    
   
}

@end
