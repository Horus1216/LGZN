//
//  CollectionStyleVC.h
//  ALG
//
//  Created by Horus on 16/9/10.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionStyleVC : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,retain) NSDictionary *infoDic;
-(instancetype)initWithDictionary:(NSDictionary *)infoDic;

@end
