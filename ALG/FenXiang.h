//
//  FenXiang.h
//  ALG
//
//  Created by Horus on 16/9/11.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface FenXiang : UIView<TencentSessionDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property(nonatomic,retain) NSString *htmlString;
@property(nonatomic,retain) NSString *Atitle;
@property(nonatomic) NSInteger articleID;
@property(nonatomic) NSString *imageUrl;
@property(nonatomic) BOOL isSheZi;

@property (strong, nonatomic) IBOutlet UIButton *scButton;

-(void)setInfoWithString:(NSArray *)webInfo;

@end
