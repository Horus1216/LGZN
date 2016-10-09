//
//  CusCollectionViewCell.m
//  ALG
//
//  Created by Horus on 16/9/10.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "CusCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface CusCollectionViewCell ()
{
    UILabel *Atitle;
    UIImageView *backImageView;
}
@end

@implementation CusCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        backImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:backImageView];
        
        Atitle=[[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:Atitle];
    }
    return self;
}

-(void)setImageString:(NSString *)imageString Title:(NSString *)titleString
{
    backImageView.frame=self.contentView.bounds;
   [backImageView setImageWithURL:[NSURL URLWithString:[imageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"defaultimg"]];
    
    Atitle.text=titleString;
    Atitle.alpha=0.7;
    Atitle.backgroundColor=[UIColor blackColor];
    Atitle.font=[UIFont systemFontOfSize:13];
    Atitle.textColor=[UIColor whiteColor];
    Atitle.numberOfLines=0;
    CGFloat height=[self height:Atitle];
    Atitle.frame=CGRectMake(0, self.contentView.bounds.size.height-height, self.contentView.bounds.size.width, height);
}

-(CGFloat)height:(UILabel *)label
{
    NSDictionary *attributeDic=@{NSFontAttributeName:label.font};
   return  [label.text boundingRectWithSize:CGSizeMake(self.contentView.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attributeDic context:nil].size.height;
}

@end
