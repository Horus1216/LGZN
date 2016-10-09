//
//  WebSheZi.m
//  ALG
//
//  Created by Horus on 16/9/13.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "WebSheZi.h"

@interface WebSheZi ()
{
    UISlider *liangDu;
}
@end

@implementation WebSheZi


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


-(void)setWebView:(NSString *)btnTitle
{
    if (btnTitle) {
        [self.ZhiTi setTitle:btnTitle forState:UIControlStateNormal];
    }
    CGFloat value = [UIScreen mainScreen].brightness;
    liangDu=[[UISlider alloc]initWithFrame:CGRectMake(self.pmLiangDu.frame.origin.x+self.pmLiangDu.frame.size.width+40, self.pmLiangDu.frame.origin.y+8, 150, 10)];
    liangDu.value = value;
    [liangDu addTarget:self action:@selector(setLiangDu:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:liangDu];
    NSString *modal=[[NSUserDefaults standardUserDefaults] objectForKey:@"yejianMode"];
    if ([modal isEqualToString:@"night"]) {
        self.yeJian.on=YES;
    }
    else
    {
        self.yeJian.on=NO;
    }

}

- (IBAction)CloseBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeShare1" object:nil];
}

- (IBAction)setZT:(id)sender {
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"设置字体大小" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"大号",@"中号",@"小号", nil];
    [actionSheet showInView:self];
}

- (IBAction)setLiangDu:(id)sender {
    UISlider *slider=(UISlider *)sender;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [[UIScreen mainScreen] setBrightness:slider.value];
}

- (IBAction)setYJ:(id)sender {
    UISwitch *btn=(UISwitch *)sender;
    if (btn.isOn) {
        [[NSUserDefaults standardUserDefaults] setObject:@"night" forKey:@"yejianMode"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"night" object:nil];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"daylight" forKey:@"yejianMode"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"daylight" object:nil];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setZT" object:@"140"];
            [self.ZhiTi setTitle:@"大号" forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setZT" object:@"100"];
            [self.ZhiTi setTitle:@"中号" forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setZT" object:@"80"];
            [self.ZhiTi setTitle:@"小号" forState:UIControlStateNormal];
        }
            break;

        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeShare1" object:nil];
}

@end
