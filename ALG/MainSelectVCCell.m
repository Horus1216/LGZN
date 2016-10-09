//
//  MainSelectVCCell.m
//  ALG
//
//  Created by Horus on 16/9/6.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "MainSelectVCCell.h"

@interface MainSelectVCCell ()
{
    UILabel *titelLabel;
    UILabel *contentLabel;
}
@end

@implementation MainSelectVCCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titelLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:titelLabel];
        
        contentLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:contentLabel];
    }
    return self;
}

-(void)setInfo:(NSDictionary *)infoDic
{
    titelLabel.frame=CGRectMake(20, 15, 60, 25);
    titelLabel.text=[infoDic objectForKey:@"categoryName"];
    self.height=40;
    
    contentLabel.frame=CGRectMake(20, titelLabel.frame.origin.y+titelLabel.frame.size.height+10, 260, 20);
    contentLabel.text=[infoDic objectForKey:@"categoryInfo"];
    contentLabel.textColor=[UIColor lightGrayColor];
    contentLabel.font=[UIFont systemFontOfSize:12];
    
    self.height+=30;
}

@end
