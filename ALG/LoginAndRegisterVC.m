//
//  LoginAndRegisterVC.m
//  ALG
//
//  Created by Horus on 16/9/10.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "LoginAndRegisterVC.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface LoginAndRegisterVC ()
{
    UIScrollView *backScrollView;
    UITextField *loginName;
    UITextField *loginPW;
    UITextField *registerName;
    UITextField *registerPW;
    UITextField *registerNickName;
    NSFileManager *fileManager;
    CGFloat totalHeight;
    CGFloat totalHeight1;
}
@end

@implementation LoginAndRegisterVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:222.0/255.0 green:226.0/255.0 blue:212.0/255.0 alpha:1.0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillEndShow:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignAllFirstResponder)];
    
    backScrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    backScrollView.scrollEnabled=NO;
    backScrollView.showsHorizontalScrollIndicator=NO;
    backScrollView.contentSize=CGSizeMake(self.view.bounds.size.width*2, self.view.bounds.size.height);
    [self.view addSubview:backScrollView];
    [backScrollView addGestureRecognizer:tap];
    
    [self addLoginView];
    [self addRegisterView];
}

-(void)keyboardWillShow:(NSNotification *)msg
{
    if (backScrollView.contentOffset.x==0) {
        CGRect keyboradFrame=[msg.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardHeight=keyboradFrame.size.height;
        if (totalHeight<keyboardHeight) {
            [UIView animateWithDuration:1.0 animations:^{
                backScrollView.transform=CGAffineTransformMakeTranslation(0, -keyboardHeight+totalHeight-10);
            }];
        }
    }
    else
    {
        CGRect keyboradFrame=[msg.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardHeight=keyboradFrame.size.height;
        if (totalHeight1<keyboardHeight) {
            [UIView animateWithDuration:1.0 animations:^{
                backScrollView.transform=CGAffineTransformMakeTranslation(0, -keyboardHeight+totalHeight1-10);
            }];
        }
    }

}

-(void)keyboardWillEndShow:(NSNotification *)msg
{
    [UIView animateWithDuration:1.0 animations:^{
        backScrollView.transform=CGAffineTransformMakeTranslation(0, 0);
    }];
}

-(void)addLoginView
{
    UIImageView *loginView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    loginView.userInteractionEnabled=YES;
    loginView.image=[UIImage imageNamed:@"login.jpg"];
    [backScrollView addSubview:loginView];
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(15, 30, 40, 20);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    backBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    backBtn.backgroundColor=[UIColor clearColor];
    [loginView addSubview:backBtn];
    
    UIButton *registerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame=CGRectMake(self.view.bounds.size.width-55, 30, 40, 20);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [registerBtn addTarget:self action:@selector(registerbtn) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerBtn.backgroundColor=[UIColor clearColor];
    [loginView addSubview:registerBtn];
    
    UIImageView *fashion=[[UIImageView alloc]initWithFrame:CGRectMake(60, 80, self.view.bounds.size.width-120, 60)];
    fashion.image=[UIImage imageNamed:@"CrazyFashion"];
    [loginView addSubview:fashion];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, fashion.frame.origin.y+fashion.frame.size.height+15, 200, 20)];
    label.font=[UIFont systemFontOfSize:15];
    label.center=CGPointMake(fashion.center.x, fashion.frame.origin.y+fashion.frame.size.height+15);
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.text=@"乐享购物，丰富无限！";
    [loginView addSubview:label];
    
    UILabel *zhanghao=[[UILabel alloc]initWithFrame:CGRectMake(15, label.frame.origin.y+label.frame.size.height+20, 40, 20)];
    zhanghao.text=@"账号";
    zhanghao.textColor=[UIColor whiteColor];
    zhanghao.font=[UIFont systemFontOfSize:15];
    [loginView addSubview:zhanghao];
    
    loginName=[[UITextField alloc]initWithFrame:CGRectMake(zhanghao.frame.origin.x+zhanghao.frame.size.width+10, zhanghao.frame.origin.y, 230, 20)];
    loginName.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"输入帐号" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    loginName.font=[UIFont systemFontOfSize:15];
    loginName.textColor=[UIColor whiteColor];
    [loginView addSubview:loginName];
    
    UIImageView *loginNameLine=[[UIImageView alloc]initWithFrame:CGRectMake(zhanghao.frame.origin.x, zhanghao.frame.origin.y+zhanghao.frame.size.height+5, zhanghao.frame.size.width+loginName.frame.size.width, 1)];
    loginNameLine.backgroundColor=[UIColor whiteColor];
    [loginView addSubview:loginNameLine];
    
    UILabel *mima=[[UILabel alloc]initWithFrame:CGRectMake(15, loginNameLine.frame.origin.y+loginNameLine.frame.size.height+20, 40, 20)];
    mima.text=@"密码";
    mima.textColor=[UIColor whiteColor];
    mima.font=[UIFont systemFontOfSize:15];
    [loginView addSubview:mima];
    
    loginPW=[[UITextField alloc]initWithFrame:CGRectMake(mima.frame.origin.x+mima.frame.size.width+10, mima.frame.origin.y, 230, 20)];
    loginPW.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"输入密码" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    loginPW.font=[UIFont systemFontOfSize:15];
    loginPW.secureTextEntry=YES;
    loginPW.textColor=[UIColor whiteColor];
    loginPW.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    [loginView addSubview:loginPW];
    
    UIButton *secure=[UIButton buttonWithType:UIButtonTypeCustom];
    secure.frame=CGRectMake(loginPW.frame.origin.x+loginPW.frame.size.width-40, loginPW.frame.origin.y+3, 20, 14);
    [secure setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
    [secure addTarget:self action:@selector(secureBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:secure];
    
    UIImageView *loginPWLine=[[UIImageView alloc]initWithFrame:CGRectMake(mima.frame.origin.x, mima.frame.origin.y+mima.frame.size.height+5, mima.frame.size.width+loginPW.frame.size.width, 1)];
    loginPWLine.backgroundColor=[UIColor whiteColor];
    [loginView addSubview:loginPWLine];
    
    UILabel *zddl=[[UILabel alloc]initWithFrame:CGRectMake(loginPWLine.frame.origin.x+loginPWLine.frame.size.width-65, loginPWLine.frame.origin.y+loginPWLine.frame.size.height+10, 60, 20)];
    zddl.text=@"自动登录";
    zddl.textColor=[UIColor whiteColor];
    zddl.font=[UIFont systemFontOfSize:15];
    [loginView addSubview:zddl];
    
    fileManager=[NSFileManager defaultManager];
    BOOL isFile=YES;
    NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *tagFile=[libraryPath stringByAppendingPathComponent:@"tagFile"];
    NSString *autoLogin=[tagFile stringByAppendingPathComponent:@"autologin.tag"];

    UIButton *autoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    if ([fileManager fileExistsAtPath:autoLogin isDirectory:&isFile]) {
        [autoBtn setBackgroundImage:[UIImage imageNamed:@"复选框_选中"] forState:UIControlStateNormal];
    }
    else
    {
        [autoBtn setBackgroundImage:[UIImage imageNamed:@"复选框_默认"] forState:UIControlStateNormal];
    }
    autoBtn.frame=CGRectMake(zddl.frame.origin.x-25, zddl.frame.origin.y, 20, 20);
    [autoBtn addTarget:self action:@selector(autoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:autoBtn];
    
    UIButton *loginbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [loginbtn setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:99.0/225.0 blue:87.0/255.0 alpha:0.6]];
    loginbtn.frame=CGRectMake(0, 0, 140, 30);
    [loginbtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [loginbtn addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    loginbtn.center=CGPointMake(self.view.center.x, autoBtn.frame.origin.y+autoBtn.frame.size.height+40);
    [loginView addSubview:loginbtn];
    
    totalHeight=self.view.bounds.size.height-loginbtn.frame.origin.y-loginbtn.frame.size.height;
}

-(void)addRegisterView
{
    UIImageView *loginView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    loginView.userInteractionEnabled=YES;
    loginView.image=[UIImage imageNamed:@"login.jpg"];
    [backScrollView addSubview:loginView];
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(15, 30, 40, 20);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction1) forControlEvents:UIControlEventTouchUpInside];
    backBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    backBtn.backgroundColor=[UIColor clearColor];
    [loginView addSubview:backBtn];
    
    UIImageView *fashion=[[UIImageView alloc]initWithFrame:CGRectMake(60, 80, self.view.bounds.size.width-120, 60)];
    fashion.image=[UIImage imageNamed:@"CrazyFashion"];
    [loginView addSubview:fashion];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, fashion.frame.origin.y+fashion.frame.size.height+15, 200, 20)];
    label.font=[UIFont systemFontOfSize:15];
    label.center=CGPointMake(fashion.center.x, fashion.frame.origin.y+fashion.frame.size.height+15);
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.text=@"乐享购物，丰富无限！";
    [loginView addSubview:label];
    
    UILabel *zhanghao=[[UILabel alloc]initWithFrame:CGRectMake(15, label.frame.origin.y+label.frame.size.height+20, 40, 20)];
    zhanghao.text=@"账号";
    zhanghao.textColor=[UIColor whiteColor];
    zhanghao.font=[UIFont systemFontOfSize:15];
    [loginView addSubview:zhanghao];
    
    registerName=[[UITextField alloc]initWithFrame:CGRectMake(zhanghao.frame.origin.x+zhanghao.frame.size.width+10, zhanghao.frame.origin.y, 230, 20)];
    registerName.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"输入帐号" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    registerName.font=[UIFont systemFontOfSize:15];
    registerName.textColor=[UIColor whiteColor];
    [loginView addSubview:registerName];
    
    UIImageView *loginNameLine=[[UIImageView alloc]initWithFrame:CGRectMake(zhanghao.frame.origin.x, zhanghao.frame.origin.y+zhanghao.frame.size.height+5, zhanghao.frame.size.width+loginName.frame.size.width, 1)];
    loginNameLine.backgroundColor=[UIColor whiteColor];
    [loginView addSubview:loginNameLine];
    
    UILabel *nick=[[UILabel alloc]initWithFrame:CGRectMake(15, loginNameLine.frame.origin.y+loginNameLine.frame.size.height+20, 60, 20)];
    nick.text=@"设置昵称";
    nick.textColor=[UIColor whiteColor];
    nick.font=[UIFont systemFontOfSize:15];
    [loginView addSubview:nick];
    
    registerNickName=[[UITextField alloc]initWithFrame:CGRectMake(nick.frame.origin.x+nick.frame.size.width+10, nick.frame.origin.y, 210, 20)];
    registerNickName.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"输入昵称" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    registerNickName.font=[UIFont systemFontOfSize:15];
    registerNickName.textColor=[UIColor whiteColor];
    [loginView addSubview:registerNickName];
    
    UIImageView *loginPWLine=[[UIImageView alloc]initWithFrame:CGRectMake(nick.frame.origin.x, nick.frame.origin.y+nick.frame.size.height+5, nick.frame.size.width+registerNickName.frame.size.width, 1)];
    loginPWLine.backgroundColor=[UIColor whiteColor];
    [loginView addSubview:loginPWLine];
    
    UILabel *PassW=[[UILabel alloc]initWithFrame:CGRectMake(15, loginPWLine.frame.origin.y+loginPWLine.frame.size.height+20, 60, 20)];
    PassW.text=@"设置密码";
    PassW.textColor=[UIColor whiteColor];
    PassW.font=[UIFont systemFontOfSize:15];
    [loginView addSubview:PassW];
    
    registerPW=[[UITextField alloc]initWithFrame:CGRectMake(PassW.frame.origin.x+PassW.frame.size.width+10, PassW.frame.origin.y, 210, 20)];
    registerPW.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"输入昵称" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    registerPW.font=[UIFont systemFontOfSize:15];
    registerPW.secureTextEntry=YES;
    registerPW.textColor=[UIColor whiteColor];
    registerPW.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    [loginView addSubview:registerPW];
    
    UIButton *secure=[UIButton buttonWithType:UIButtonTypeCustom];
    secure.frame=CGRectMake(registerPW.frame.origin.x+registerPW.frame.size.width-40,registerPW.frame.origin.y+3, 20, 14);
    [secure setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
    [secure addTarget:self action:@selector(secureBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:secure];
    
    UIImageView *PWLine=[[UIImageView alloc]initWithFrame:CGRectMake(PassW.frame.origin.x, PassW.frame.origin.y+PassW.frame.size.height+5, PassW.frame.size.width+registerPW.frame.size.width, 1)];
    PWLine.backgroundColor=[UIColor whiteColor];
    [loginView addSubview:PWLine];
    
    UIButton *loginbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [loginbtn setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:99.0/225.0 blue:87.0/255.0 alpha:0.6]];
    loginbtn.frame=CGRectMake(0, 0, 140, 30);
    [loginbtn setTitle:@"注册" forState:UIControlStateNormal];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [loginbtn addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    loginbtn.center=CGPointMake(self.view.center.x, PWLine.frame.origin.y+PWLine.frame.size.height+40);
    [loginView addSubview:loginbtn];
    
    totalHeight1=self.view.bounds.size.height-loginbtn.frame.origin.y-loginbtn.frame.size.height;
}

-(void)registerBtnClicked:(UIButton *)btn
{
    [registerNickName resignFirstResponder];
    [registerName resignFirstResponder];
    [registerPW resignFirstResponder];
    
    NSString *nameRegex = @"^[A-Za-z]{6,12}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
    if (![test evaluateWithObject:registerName.text]) {
        [self mbProgressHUD:@"用户名只能由6～12位字母组成"];
        return;
    }
    NSString *nickRegex = @"^[a-zA-Z\u4e00-\u9fa5]{2,4}$";
    NSPredicate *test2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nickRegex];
    if (![test2 evaluateWithObject:registerNickName.text]) {
        [self mbProgressHUD:@"昵称为2～4位汉字或字母组合"];
        return;
    }
    NSString *secretRegex = @"^\\d{6}$";
    NSPredicate *test3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",secretRegex];
    if (![test3 evaluateWithObject:registerPW.text]) {
        [self mbProgressHUD:@"密码只能由6位数字组成"];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=@"http://112.74.108.147:9080/Yidaforum/user/userregister.do";
    NSDictionary *parameter=@{@"username":registerName.text,@"nickname":registerNickName.text,@"passwd":registerPW.text};
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject){
        NSDictionary *dic=(NSDictionary *)responseObject;
        if ([[dic objectForKey:@"code"] integerValue]==200) {
            [self mbProgressHUD:@"注册成功"];
            loginName.text=registerName.text;
            loginPW.text=registerPW.text;
            [self performSelector:@selector(backBtnAction1) withObject:nil afterDelay:1.5];
        }
        if ([[dic objectForKey:@"code"] integerValue]==203) {
            [self mbProgressHUD:@"用户已存在"];
        }
         
     }failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
         [self mbProgressHUD:[error localizedDescription]];
     }];
}

-(void)backBtnAction1
{
    [UIView animateWithDuration:1.0 animations:^{
        backScrollView.contentOffset=CGPointMake(0, 0);
    }];
}

-(void)registerbtn
{
    [UIView animateWithDuration:1.0 animations:^{
        backScrollView.contentOffset=CGPointMake(self.view.bounds.size.width, 0);
    }];
    
}

-(void)secureBtn
{
    if (backScrollView.contentOffset.x==0) {
        if (loginPW.isSecureTextEntry) {
            loginPW.secureTextEntry=NO;
        }
        else
        {
            loginPW.secureTextEntry=YES;
        }
    }
    else
    {
        if (registerPW.isSecureTextEntry) {
            registerPW.secureTextEntry=NO;
        }
        else
        {
            registerPW.secureTextEntry=YES;
        }
    }

}

-(void)backBtnAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)autoBtnClicked:(UIButton *)btn
{
    BOOL isFile=YES;
    NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *tagFile=[libraryPath stringByAppendingPathComponent:@"tagFile"];
    NSString *autoLogin=[tagFile stringByAppendingPathComponent:@"autologin.tag"];
    NSString *notAutoLogin=[tagFile stringByAppendingPathComponent:@"notAutoLogin.tag"];
    if ([fileManager fileExistsAtPath:autoLogin isDirectory:&isFile]) {
        [btn setBackgroundImage:[UIImage imageNamed:@"复选框_默认"] forState:UIControlStateNormal];
        [fileManager removeItemAtPath:autoLogin error:nil];
        [fileManager createFileAtPath:notAutoLogin contents:nil attributes:nil];
    }
    else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"复选框_选中"] forState:UIControlStateNormal];
        [fileManager removeItemAtPath:notAutoLogin error:nil];
        [fileManager createFileAtPath:autoLogin contents:nil attributes:nil];
    }
}

-(void)resignAllFirstResponder
{
    [loginName resignFirstResponder];
    [loginPW resignFirstResponder];
    [registerNickName resignFirstResponder];
    [registerName resignFirstResponder];
    [registerPW resignFirstResponder];
}

-(void)loginBtnClicked:(UIButton *)btn
{
    [loginName resignFirstResponder];
    [loginPW resignFirstResponder];
    
    NSString *nameRegex = @"^[A-Za-z]{6,12}$";
    NSPredicate *testName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
    if (![testName evaluateWithObject:loginName.text]) {
        [self mbProgressHUD:@"用户名只能由6～12位字母组成"];
        return;
    }
    
    NSString *secretRegex = @"^\\d{6}$";
    NSPredicate *testPW = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",secretRegex];
    if (![testPW evaluateWithObject:loginPW.text]) {
        [self mbProgressHUD:@"密码只能由6位数字组成"];
        return;
    }
    
    BOOL isFile=YES;
    NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savingData=[libraryPath stringByAppendingPathComponent:@"SavingData"];
    NSString *userInfo=[savingData stringByAppendingPathComponent:@"userInfo.plist"];
    if ([fileManager fileExistsAtPath:userInfo isDirectory:&isFile]) {
        [fileManager createFileAtPath:userInfo contents:nil attributes:nil];
    }
    
    NSString *tagFile=[libraryPath stringByAppendingPathComponent:@"tagFile"];
    NSString *loginSucc=[tagFile stringByAppendingPathComponent:@"loginSucc.tag"];
    NSString *loginFail=[tagFile stringByAppendingPathComponent:@"loginFail.tag"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=@"http://112.74.108.147:9080/Yidaforum/user/userlogin.do";
    NSDictionary *parameter=@{@"username":loginName.text,@"passwd":loginPW.text};
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dic=(NSDictionary *)responseObject;
        if ([[dic objectForKey:@"code"] integerValue]==200) {
            [[dic objectForKey:@"result"] writeToFile:userInfo atomically:YES];
            [self mbProgressHUD:@"登录成功"];
            [self performSelector:@selector(backBtnAction) withObject:nil afterDelay:1.5];
            BOOL isDirectory=NO;
            if (![fileManager fileExistsAtPath:loginSucc isDirectory:&isDirectory]) {
                [fileManager createFileAtPath:loginSucc contents:nil attributes:nil];
                if ([fileManager fileExistsAtPath:loginFail isDirectory:&isDirectory]) {
                    [fileManager removeItemAtPath:loginFail error:nil];
                }
            }
        }
        else
        {
            [self mbProgressHUD:@"登录失败"];
            BOOL isDirectory=NO;
            if (![fileManager fileExistsAtPath:loginFail isDirectory:&isDirectory]) {
                [fileManager createFileAtPath:loginFail contents:nil attributes:nil];
                if ([fileManager fileExistsAtPath:loginSucc isDirectory:&isDirectory]) {
                    [fileManager removeItemAtPath:loginSucc error:nil];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [self mbProgressHUD:[error localizedDescription]];
    }];

}

-(void)mbProgressHUD:(NSString *)showString
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = showString;
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

@end
