//
//  FanKuiVC.m
//  ALG
//
//  Created by Horus on 16/9/15.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "FanKuiVC.h"
#import "AFNetworking.h"

@interface FanKuiVC ()
{
    BOOL firstClick;
}
@end

@implementation FanKuiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    firstClick=YES;
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:222.0/255 green:226.0/255 blue:212.0/255 alpha:1.0];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    label.text=@"意见反馈";
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=label;
    
    UIButton *leftItemButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftItemButton.frame=CGRectMake(0, 0, 20, 20);
    [leftItemButton setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItemButton addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftItemButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightItemButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.frame=CGRectMake(0, 0, 40, 40);
    [rightItemButton setTitle:@"发送" forState:UIControlStateNormal];
    rightItemButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [rightItemButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightItemButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    self.navigationController.interactivePopGestureRecognizer.enabled=YES;
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL isFile=YES;
    NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savingData=[libraryPath stringByAppendingPathComponent:@"SavingData"];
    NSString *userInfo=[savingData stringByAppendingPathComponent:@"userInfo.plist"];
    NSDictionary *dic=[NSDictionary dictionaryWithContentsOfFile:userInfo];
    if ([fileManager fileExistsAtPath:userInfo isDirectory:&isFile]) {
        self.Name.text=[dic objectForKey:@"nickname"];
    }
}

-(void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rightButtonAction
{
    if (firstClick==NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请勿重复发送" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return;
    }
    NSString *secretRegex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",secretRegex];
    if (![test evaluateWithObject:self.Telephone.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"手机号不合法" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return;
    }
    if (self.yiJian.text.length==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"内容不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        [alert show];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=@"http://112.74.108.147:6100/api/complaint";
    NSDictionary *dic=@{@"a":self.Name.text,@"b":self.Telephone.text,@"c":self.yiJian.text};
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *result=[responseObject objectForKey:@"z"];
        if ([[result objectForKey:@"a"] isEqualToString:@"200"]) {
            firstClick=NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"感谢您的反馈" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
            [alert show];
            return;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"发送失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
