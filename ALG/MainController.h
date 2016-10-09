//
//  MainController.h
//  ALG
//
//  Created by Horus on 16/9/6.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface MainController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,iCarouselDataSource,iCarouselDelegate>

@end
