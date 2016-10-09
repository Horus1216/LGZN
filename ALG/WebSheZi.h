//
//  WebSheZi.h
//  ALG
//
//  Created by Horus on 16/9/13.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebSheZi : UIView<UIActionSheetDelegate>

@property(nonatomic,retain) NSString *btnTitle;
@property (strong, nonatomic) IBOutlet UISwitch *yeJian;
//@property (strong, nonatomic) IBOutlet UISlider *liangDu;
@property (strong, nonatomic) IBOutlet UIButton *ZhiTi;
@property (strong, nonatomic) IBOutlet UILabel *pmLiangDu;

-(void)setWebView:(NSString *)btnTitle;

@end
