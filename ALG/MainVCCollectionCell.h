//
//  MainVCCollectionCell.h
//  ALG
//
//  Created by Horus on 16/9/6.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainVCCollectionCell : UICollectionViewCell

@property(nonatomic,retain) UIImageView *iamgeView;
@property(nonatomic,retain) UILabel *imageLabel;

-(void)setInfo:(NSDictionary *)infoDic;

@end
