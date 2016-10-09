//
//  CusTabelViewCell.m
//  ALG
//
//  Created by Horus on 16/9/9.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "CusTabelViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface CusTabelViewCell ()
{
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *contentLabel;
}

@end

@implementation CusTabelViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        imageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:imageView];
        
        titleLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:titleLabel];
        
        contentLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:contentLabel];
    }
    return self;
}

-(void)setInfoWith:(NSDictionary *)infoDic indexNumber:(NSInteger)indexNumber
{
    
    switch (indexNumber%2) {
        case 0:
        {
            titleLabel.frame=CGRectMake(10, 15, self.frame.size.width-90, 15);
            titleLabel.font=[UIFont systemFontOfSize:15];
            titleLabel.text=[infoDic objectForKey:@"title"];
            titleLabel.textColor=[UIColor brownColor];
            
            contentLabel.frame=CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height+10, titleLabel.frame.size.width, 30);
            contentLabel.numberOfLines=2;
            contentLabel.font=[UIFont systemFontOfSize:10];
            contentLabel.text=[infoDic objectForKey:@"summary"];
            
            NSString *url=[infoDic objectForKey:@"imageURL"];
            imageView.frame=CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width+5, titleLabel.frame.origin.y-5, 60, 60);
            [imageView setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"defaultimg"]];
            
        }
            break;
        case 1:
        {
            imageView.frame=CGRectMake(10, 10, 60, 60);
            NSString *url=[infoDic objectForKey:@"imageURL"];
            [imageView setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"defaultimg"]];
            
            titleLabel.frame=CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+10, imageView.frame.origin.y-5, self.frame.size.width-90, 15);
            titleLabel.text=[infoDic objectForKey:@"title"];
            titleLabel.textColor=[UIColor brownColor];
            
            contentLabel.frame=CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height+10, titleLabel.frame.size.width, 30);
            contentLabel.numberOfLines=2;
            contentLabel.font=[UIFont systemFontOfSize:10];
            contentLabel.text=[infoDic objectForKey:@"summary"];
        }
            
        default:
            break;
    }

}

@end
