//
//  ShouCangCell.m
//  ALG
//
//  Created by Horus on 16/9/14.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "ShouCangCell.h"
#import "UIImageView+AFNetworking.h"
#import "TFHpple.h"

@interface ShouCangCell ()
{
    UIImageView *titleImage;
    UILabel *titleLabel;
    UILabel *content;
}
@end

@implementation ShouCangCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleImage=[[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:titleImage];
        titleLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:titleLabel];
        content=[[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:content];
    }
    return self;
}

-(void)setInfoWithShouCangInfo:(ShouCangInfo *)info
{
    titleImage.frame=CGRectMake(10, 10, 80, 80);
    [titleImage setImageWithURL:[NSURL URLWithString:info.imageUrl] placeholderImage:[UIImage imageNamed:@"defaultimg"]];
    
    titleLabel.frame=CGRectMake(titleImage.frame.origin.x+titleImage.frame.size.width+10, titleImage.frame.origin.y, self.contentView.frame.size.width-titleImage.frame.origin.x-titleImage.frame.size.width-45, 20);
    titleLabel.text=info.Atitle;
    titleLabel.font=[UIFont systemFontOfSize:15];
    titleLabel.textColor=[UIColor brownColor];
    
    NSData *htmlData = [info.htmlString dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//span"];
    TFHppleElement *httpElement=[dataArray firstObject];
    
    content.frame=CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height+5, titleLabel.frame.size.width, 70-titleLabel.frame.size.height);
    content.numberOfLines=0;
    content.font=[UIFont systemFontOfSize:13];
    content.text=httpElement.text;
}

@end
