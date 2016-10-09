//
//  FenXiang.m
//  ALG
//
//  Created by Horus on 16/9/11.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "FenXiang.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "ShouCangInfo.h"

@interface FenXiang ()
{
    NSMutableString *arrayData;
}
@end

@implementation FenXiang


-(void)setInfoWithString:(NSArray *)webInfo
{
    self.htmlString=[webInfo objectAtIndex:2];
    self.Atitle=[webInfo objectAtIndex:1];
    self.articleID=[[webInfo objectAtIndex:0] integerValue];
    self.imageUrl=[webInfo objectAtIndex:3];
    self.isSheZi=NO;
    
    arrayData=[NSMutableString string];
    
    NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savingData=[libraryPath stringByAppendingPathComponent:@"SavingData"];
    NSString *shouCang=[savingData stringByAppendingPathComponent:@"shouCang"];
    NSMutableArray *mapAry = [NSKeyedUnarchiver unarchiveObjectWithFile:shouCang];
    if (mapAry && [mapAry count]){
        for (ShouCangInfo *check in mapAry){
            NSString *Astring=[NSString stringWithFormat:@"(%li)",check.articleID];
            [arrayData appendString:Astring];
        }
        NSRange range=[arrayData rangeOfString:[NSString stringWithFormat:@"(%li)",self.articleID]];
        if (range.location!=NSNotFound) {
            [self.scButton setImage:[UIImage imageNamed:@"btn_shoucang_2_new"] forState:UIControlStateNormal];
        }
        else
        {
            [self.scButton setImage:[UIImage imageNamed:@"btn_shoucang_new"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)wexin:(id)sender {
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@""]];
    
    WXImageObject *ext = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cfashionicon" ofType:@"png"];
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
    ext.imageData = UIImagePNGRepresentation(image);
    message.mediaObject = ext;
    message.title = @"爱购指南App";
    message.description = @"爱购指南App,请上AppStore下载!";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}

- (IBAction)pengyouquan:(id)sender {
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@""]];
    
    WXImageObject *ext = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cfashionicon" ofType:@"png"];
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
    ext.imageData = UIImagePNGRepresentation(image);
    message.mediaObject = ext;
    message.title = @"爱购指南App";
    message.description = @"爱购指南App,请上AppStore下载!";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}
- (IBAction)weibo:(id)sender {
    WBMessageObject *msg = [WBMessageObject message];
    msg.text = @"爱购指南App,请上AppStore下载!";
    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cfashionicon" ofType:@"png"]];
    msg.imageObject = image;
    [self messageToSina:msg];
    
}
- (BOOL)support {
    BOOL isSpupport = YES;
    if ([QQApiInterface isQQInstalled]) {
        if ([QQApiInterface isQQSupportApi]) {
            isSpupport = YES;
        } else {
            isSpupport = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"当前QQ版本太低，现在最新?" delegate:self cancelButtonTitle:@"不了" otherButtonTitles:@"现在更新", nil];
            [alert show];
        }
    } else {
        isSpupport = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"分享内容前必须安装QQ应用，是否安装?" delegate:self cancelButtonTitle:@"不了" otherButtonTitles:@"现在安装", nil];
        [alert show];
    }
    return isSpupport;
}
- (IBAction)Qhaoyou:(id)sender {
    if ([self support]) {
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105341835"
                                                    andDelegate:self];
        NSData *imgData = UIImagePNGRepresentation([UIImage imageNamed:@"cfashionicon.png"]);
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                                   previewImageData:imgData
                                                              title:@"爱购指南App"
                                                       description :@"爱购指南App,请上AppStore下载!"];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        if (sent == EQQAPISENDSUCESS) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"分享失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}
- (IBAction)Qkongjian:(id)sender {
    if ([self support]) {
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105341835"
                                                    andDelegate:self];
        NSData *imgData = UIImagePNGRepresentation([UIImage imageNamed:@"cfashionicon.png"]);
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                                   previewImageData:imgData
                                                              title:@"爱购指南App"
                                                       description :@"爱购指南App,请上AppStore下载!"];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        if (sent == EQQAPISENDSUCESS) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"分享失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}
- (IBAction)shoucang:(id)sender {
    
    arrayData=[NSMutableString string];
    
    NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savingData=[libraryPath stringByAppendingPathComponent:@"SavingData"];
    NSString *shouCang=[savingData stringByAppendingPathComponent:@"shouCang"];
    NSMutableArray *mapAry = [NSKeyedUnarchiver unarchiveObjectWithFile:shouCang];
    if (mapAry && [mapAry count]){
        for (ShouCangInfo *check in mapAry){
            NSString *Astring=[NSString stringWithFormat:@"(%li)",check.articleID];
            [arrayData appendString:Astring];
        }
        NSRange range=[arrayData rangeOfString:[NSString stringWithFormat:@"(%li)",self.articleID]];
        if (range.location==NSNotFound) {
            ShouCangInfo *info=[[ShouCangInfo alloc]init];
            info.articleID=self.articleID;
            info.Atitle=self.Atitle;
            info.htmlString=self.htmlString;
            info.isShouCang=YES;
            info.imageUrl=self.imageUrl;
            [mapAry addObject:info];
            [NSKeyedArchiver archiveRootObject:mapAry toFile:shouCang];
        }
        else
        {
            for (ShouCangInfo *check in mapAry) {
                if (check.articleID==self.articleID) {
                    [mapAry removeObject:check];
                }
            }
            [NSKeyedArchiver archiveRootObject:mapAry toFile:shouCang];
            [self.scButton setImage:[UIImage imageNamed:@"btn_shoucang_new"] forState:UIControlStateNormal];
            
        }
    }
    else{
        mapAry = [NSMutableArray array];
        ShouCangInfo *info=[[ShouCangInfo alloc]init];
        info.articleID=self.articleID;
        info.Atitle=self.Atitle;
        info.htmlString=self.htmlString;
        info.isShouCang=YES;
        info.imageUrl=self.imageUrl;
        [mapAry addObject:info];
        [NSKeyedArchiver archiveRootObject:mapAry toFile:shouCang];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeShare" object:nil];
}
- (IBAction)guanbi:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeShare" object:nil];
}
- (void)messageToSina:(WBMessageObject*)object
{
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:object];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = YES;
    [WeiboSDK sendRequest:request];
}

- (void)tencentDidLogin {
}


- (void)tencentDidNotLogin:(BOOL)cancelled {
}

- (void)tencentDidNotNetWork {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"当前无网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *qqAddress = [QQApiInterface getQQInstallUrl];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:qqAddress]];
    }
}
@end
