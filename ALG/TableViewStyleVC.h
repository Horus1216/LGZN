//
//  TableViewStyleVC.h
//  ALG
//
//  Created by Horus on 16/9/8.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewStyleVC : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain) NSDictionary *infoDic;

-(instancetype)initWithDictionary:(NSDictionary *)infoDic;

@end
