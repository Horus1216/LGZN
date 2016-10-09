//
//  PinlunCell.m
//  ALG
//
//  Created by Horus on 16/9/11.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "PinlunCell.h"

@interface PinlunCell ()
{
    UILabel *name;
    UILabel *content;
    UILabel *time;
}
@end

@implementation PinlunCell

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
        name=[[UILabel alloc]initWithFrame:CGRectZero];
        name.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:name];
        
        content=[[UILabel alloc]initWithFrame:CGRectZero];
        content.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:content];
        
        time=[[UILabel alloc]initWithFrame:CGRectZero];
        time.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:time];
    }
    return self;
}

-(void)setInfoWithDictionary:(NSDictionary *)infoDic
{
    name.frame=CGRectMake(10, 10, 100, 15);
    name.text=[infoDic objectForKey:@"nickname"];
    
    content.frame=CGRectMake(10, name.frame.origin.y+name.frame.size.height+5, 260, 20);
    content.text=[infoDic objectForKey:@"content"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"utime"]]];
    NSString *strDate = [dateFormatter stringFromDate:date];
    time.frame=CGRectMake(self.contentView.frame.size.width-120, name.frame.origin.y, 120, 15);
    time.text=strDate;
}

@end
