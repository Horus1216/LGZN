//
//  MainVCCollectionCell.m
//  ALG
//
//  Created by Horus on 16/9/6.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "MainVCCollectionCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MainVCCollectionCell


-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        self.iamgeView=[[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.iamgeView];
        
        self.imageLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.imageLabel];
    }
    return self;
}

-(void)setInfo:(NSDictionary *)infoDic
{
    self.iamgeView.frame=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-40);
    NSString *url=[infoDic objectForKey:@"bigImageURL"];
    [self.iamgeView setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"defaultimg"]];
    
    self.imageLabel.frame=CGRectMake(0, self.iamgeView.frame.origin.y+self.iamgeView.frame.size.height, self.bounds.size.width, 40);
    self.imageLabel.text=[infoDic objectForKey:@"categoryInfo"];
    self.imageLabel.textAlignment=NSTextAlignmentCenter;
    self.imageLabel.font=[UIFont systemFontOfSize:12];
}

@end
