//
//  AppDelegate.m
//  ALG
//
//  Created by Horus on 16/9/6.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "AppDelegate.h"
#import "MainController.h"
#import "LoginAndRegisterVC.h"
#import "AFNetworking.h"


#define weiboAppKey @"1116081389"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTabbarController) name:@"startAnimationEnd" object:nil];
    
    [WXApi registerApp:@"wx859994ec854ac8b7"];
    [WeiboSDK registerApp:weiboAppKey];
    
    NSFileManager *manager=[NSFileManager defaultManager];
    NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"%@\n",libraryPath);
    NSString *savingData=[libraryPath stringByAppendingPathComponent:@"SavingData"];
    NSString *tagFile=[libraryPath stringByAppendingPathComponent:@"tagFile"];
    BOOL isDirectory=YES;
    if (![manager fileExistsAtPath:savingData isDirectory:&isDirectory]) {
        [manager createDirectoryAtPath:savingData withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if (![manager fileExistsAtPath:tagFile isDirectory:&isDirectory]) {
        [manager createDirectoryAtPath:tagFile withIntermediateDirectories:NO attributes:nil error:nil];
    }
    BOOL isFile=YES;
    NSString *isCollection=[tagFile stringByAppendingPathComponent:@"isCollection.tag"];
    NSString *isScrollView=[tagFile stringByAppendingPathComponent:@"isScrollView.tag"];
    if (![manager fileExistsAtPath:isCollection isDirectory:&isFile]&&![manager fileExistsAtPath:isScrollView isDirectory:&isFile]) {
        [manager createFileAtPath:isCollection contents:nil attributes:nil];
    }
    NSString *autoLogin=[tagFile stringByAppendingPathComponent:@"autologin.tag"];
    NSString *notAutoLogin=[tagFile stringByAppendingPathComponent:@"notAutoLogin.tag"];
    if (![manager fileExistsAtPath:autoLogin isDirectory:&isFile]&&![manager fileExistsAtPath:notAutoLogin isDirectory:&isFile]) {
        [manager createFileAtPath:autoLogin contents:nil attributes:nil];
    }
    NSString *loginSucc=[tagFile stringByAppendingPathComponent:@"loginSucc.tag"];
    NSString *loginFail=[tagFile stringByAppendingPathComponent:@"loginFail.tag"];
    NSString *userInfo=[savingData stringByAppendingPathComponent:@"userInfo.plist"];
    if ([manager fileExistsAtPath:autoLogin isDirectory:&isFile]&&[manager fileExistsAtPath:loginSucc isDirectory:&isFile]) {
        NSDictionary *dic=[NSDictionary dictionaryWithContentsOfFile:userInfo];
        NSString *loginName=[dic objectForKey:@"username"];
        NSString *loginPW=[dic objectForKey:@"passwd"];
        AFHTTPRequestOperationManager *afManager = [AFHTTPRequestOperationManager manager];
        afManager.responseSerializer = [AFJSONResponseSerializer serializer];
        NSString *url=@"http://112.74.108.147:9080/Yidaforum/user/userlogin.do";
        NSDictionary *parameter=@{@"username":loginName,@"passwd":loginPW};
        [afManager POST:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            NSDictionary *dic=(NSDictionary *)responseObject;
            if ([[dic objectForKey:@"code"] integerValue]==200) {
               
            }
            else
            {
                BOOL isDirectory=NO;
                if (![manager fileExistsAtPath:loginFail isDirectory:&isDirectory]) {
                    [manager removeItemAtPath:loginSucc error:nil];
                    [manager createFileAtPath:loginFail contents:nil attributes:nil];
                }
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];

    }
    return YES;
}

-(void)setTabbarController
{
    MainController *mainVC=[[MainController alloc]init];
    UINavigationController *nvg=[[UINavigationController alloc]initWithRootViewController:mainVC];
    self.window.rootViewController=nvg;
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
    return [WeiboSDK handleOpenURL:url delegate:self];
}
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"微信分享结果"];
        NSString *strMsg = @"哦, 分享失败了";
        if (resp.errCode == 0)
        {
            strMsg = @"分享成功";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                        message:strMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if (response.statusCode == WeiboSDKResponseStatusCodeSuccess){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"分享成功"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"你取消了分享"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"分享失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
