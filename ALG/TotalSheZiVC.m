//
//  TotalSheZiVC.m
//  ALG
//
//  Created by Horus on 16/9/14.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "TotalSheZiVC.h"
#import "ShouCangVC.h"
#import "FenXiang.h"
#import "MBProgressHUD.h"
#import "LoginAndRegisterVC.h"
#import "FanKuiVC.h"

@interface TotalSheZiVC ()
{
    UITableView *AtableView;
    BOOL showFX;
    FenXiang *fxView;
    UILabel *Alabel;
}

@end

@implementation TotalSheZiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    showFX=YES;
    self.view.backgroundColor=[UIColor colorWithRed:222.0 green:226.0 blue:212.0 alpha:1.0];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    label.text=@"设置";
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=label;
    
    UIButton *leftItemButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftItemButton.frame=CGRectMake(0, 0, 20, 20);
    [leftItemButton setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItemButton addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftItemButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    self.navigationController.interactivePopGestureRecognizer.enabled=YES;
    
    AtableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    AtableView.delegate=self;
    AtableView.dataSource=self;
    AtableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:AtableView];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return 2;
    }
    if (section==2) {
        return 1;
    }
    if (section==3) {
        return 3;
    }
    if (section==4) {
        return 2;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify=@"myCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.backgroundColor=[UIColor clearColor];
    }
    if (indexPath.section==0) {
        cell.imageView.image=[UIImage imageNamed:@"icon_st_shoucang"];
        cell.textLabel.text=@"我的收藏";
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section==1) {
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (indexPath.row==0) {
            cell.imageView.image=[UIImage imageNamed:@"icon_st_yejian"];
            cell.textLabel.text=@"夜间模式";
            UISwitch *Aswitch=[[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
            [Aswitch addTarget:self action:@selector(yejianBtn:) forControlEvents:UIControlEventValueChanged];
            NSString *modal=[[NSUserDefaults standardUserDefaults] objectForKey:@"yejianMode"];
            if ([modal isEqualToString:@"night"]) {
                Aswitch.on=YES;
            }
            else
            {
                Aswitch.on=NO;
            }
            cell.accessoryView=Aswitch;
        }
        if (indexPath.row==1) {
            cell.imageView.image=[UIImage imageNamed:@"icon_st_liangdu"];
            cell.textLabel.text=@"屏幕亮度";
            CGFloat value = [UIScreen mainScreen].brightness;
            UISlider *Aslider=[[UISlider alloc]initWithFrame:CGRectMake(0, 0, 150, 10)];
            Aslider.value=value;
            cell.accessoryView=Aslider;
            [Aslider addTarget:self action:@selector(setLiangDu:) forControlEvents:UIControlEventValueChanged];
        }
    }
    if (indexPath.section==2) {
        cell.imageView.image=[UIImage imageNamed:@"icon_st_huancun"];
        cell.textLabel.text=@"清除缓存";
        Alabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
        Alabel.textAlignment=NSTextAlignmentCenter;
        NSFileManager * filemanager = [[NSFileManager alloc]init];
        NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *savingData=[libraryPath stringByAppendingPathComponent:@"SavingData"];
        BOOL isDirectory=YES;
        if([filemanager fileExistsAtPath:savingData isDirectory:&isDirectory]){
            NSDictionary * attributes = [filemanager attributesOfItemAtPath:savingData error:nil];
            NSNumber *theFileSize;
            if ([attributes objectForKey:NSFileSize])
            {
                theFileSize= [attributes objectForKey:NSFileSize];
            }
            Alabel.text=[NSString stringWithFormat:@"%.1fM",[theFileSize intValue]/1024.0];
        }
        cell.accessoryView=Alabel;
    }
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            cell.imageView.image=[UIImage imageNamed:@"icon_st_dafen"];
            cell.textLabel.text=@"为我们打分";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row==1) {
            cell.imageView.image=[UIImage imageNamed:@"icon_st_share"];
            cell.textLabel.text=@"分享";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row==2) {
            cell.imageView.image=[UIImage imageNamed:@"icon_st_fankui"];
            cell.textLabel.text=@"意见反馈";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    if (indexPath.section==4) {
        if (indexPath.row==0) {
            cell.imageView.image=[UIImage imageNamed:@"icon_st_banben"];
            cell.textLabel.text=@"当前版本";
            UILabel *banben=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
            banben.textAlignment=NSTextAlignmentCenter;
            banben.text=@"1.0";
            cell.accessoryView=banben;
        }
        if (indexPath.row==1) {
            cell.textLabel.text=@"退出登录";
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
        }
    }
    return cell;
}

-(void)yejianBtn:(UISwitch *)btn
{
    if (btn.isOn) {
        [[NSUserDefaults standardUserDefaults] setObject:@"night" forKey:@"yejianMode"];
        UIImageView *daylight=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        daylight.image=[UIImage imageNamed:@"pic_sun"];
        daylight.center=CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        [self.view addSubview:daylight];
    
        [UIView animateWithDuration:0.5 animations:^{
            daylight.transform=CGAffineTransformMakeScale(10, 10);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                daylight.image=[UIImage imageNamed:@"pic_moon"];
            } completion:^(BOOL finished) {
                sleep(1.0);
                [daylight removeFromSuperview];
            }];
            
        }];
        [self exchangeBackGround:YES];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"daylight" forKey:@"yejianMode"];
        UIImageView *daylight=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        daylight.image=[UIImage imageNamed:@"pic_moon"];
        daylight.center=CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        [self.view addSubview:daylight];
        
        [UIView animateWithDuration:0.5 animations:^{
            daylight.transform=CGAffineTransformMakeScale(10, 10);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                daylight.image=[UIImage imageNamed:@"pic_sun"];
            } completion:^(BOOL finished) {
                sleep(1.0);
                [daylight removeFromSuperview];
            }];
            
        }];
        [self exchangeBackGround:NO];
    }
}

- (IBAction)setLiangDu:(id)sender {
    UISlider *slider=(UISlider *)sender;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [[UIScreen mainScreen] setBrightness:slider.value];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        ShouCangVC *vc=[[ShouCangVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section==2) {
        NSFileManager * filemanager = [[NSFileManager alloc]init];
        NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *savingData=[libraryPath stringByAppendingPathComponent:@"SavingData"];
        BOOL isDirectory=YES;
        if([filemanager fileExistsAtPath:savingData isDirectory:&isDirectory]){
            NSArray *array=[filemanager contentsOfDirectoryAtPath:savingData error:nil];
            for (NSString *fileName in array) {
                if (![fileName isEqualToString:@".DS_Store"]&&![fileName isEqualToString:@"categoryData.plist"]&&![fileName isEqualToString:@"shouCang"]&&![fileName isEqualToString:@"showImageView.plist"]&&![fileName isEqualToString:@"userInfo.plist"]) {
                    NSString *removeFile=[savingData stringByAppendingPathComponent:fileName];
                    [filemanager removeItemAtPath:removeFile error:nil];
                }
            }
        }
        Alabel.text=@"0M";
    }
    if (indexPath.section==3) {
        if (indexPath.row==0) {
            SKStoreProductViewController *vc=[[SKStoreProductViewController alloc]init];
            vc.delegate=self;
            [vc loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@"1106383024"} completionBlock:^(BOOL result, NSError * _Nullable error) {
                if (!error) {
                    [self presentViewController:vc animated:YES completion:^{
                        
                    }];
                }
            }];
        }
        if (indexPath.row==1) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fenxiangBtn) name:@"closeShare" object:nil];
            [self fenxiangBtn];
        }
        if (indexPath.row==2) {
            
            NSFileManager *fileManager=[NSFileManager defaultManager];
            BOOL isFile=YES;
            NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *tagFile=[libraryPath stringByAppendingPathComponent:@"tagFile"];
            NSString *loginSucc=[tagFile stringByAppendingPathComponent:@"loginSucc.tag"];

            if (![fileManager fileExistsAtPath:loginSucc isDirectory:&isFile]) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"你还未登录,请先登录!" delegate:self cancelButtonTitle:@"不用了" otherButtonTitles:@"现在登录", nil];
                [alert show];
            }
            if ([fileManager fileExistsAtPath:loginSucc isDirectory:&isFile]) {
               UIStoryboard *storeBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                FanKuiVC *vc=[storeBoard instantiateViewControllerWithIdentifier:@"FanKui"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    if (indexPath.section==4) {
        if (indexPath.row==1) {
            NSFileManager *fileManager=[NSFileManager defaultManager];
            BOOL isFile=YES;
            NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *tagFile=[libraryPath stringByAppendingPathComponent:@"tagFile"];
            NSString *loginSucc=[tagFile stringByAppendingPathComponent:@"loginSucc.tag"];
            NSString *loginFail=[tagFile stringByAppendingPathComponent:@"loginFail.tag"];
            if ([fileManager fileExistsAtPath:loginSucc isDirectory:&isFile]) {
                [fileManager removeItemAtPath:loginSucc error:nil];
                [fileManager createFileAtPath:loginFail contents:nil attributes:nil];
            }
            
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"已退出登录";
            HUD.mode = MBProgressHUDModeText;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
        }
    }
}



-(void)fenxiangBtn
{
    if (showFX==YES) {
        fxView=[[NSBundle mainBundle] loadNibNamed:@"FenXiang" owner:self.view options:nil][0];
        fxView.frame=CGRectMake(0, -216, self.view.bounds.size.width, 216);
        [fxView.scButton removeFromSuperview];
        fxView.isSheZi=YES;
        [self.view addSubview:fxView];
        [UIView animateWithDuration:0.6 animations:^{
            fxView.transform=CGAffineTransformMakeTranslation(0, 216);
        }];
        showFX=NO;
    }
    else
    {
        [UIView animateWithDuration:0.6 animations:^{
            fxView.transform=CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            [fxView removeFromSuperview];
            fxView=nil;
            showFX=YES;
        }];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            LoginAndRegisterVC *vc=[[LoginAndRegisterVC alloc]init];
            [self presentViewController:vc animated:YES completion:^{
                
            }];
        }
            break;
            
        default:
            break;
    }
}

-(void)exchangeBackGround:(BOOL)isYeJian
{
    if (isYeJian) {
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationYeWanBG"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationYeWanBG"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        self.view.backgroundColor=[UIColor colorWithRed:222.0 green:226.0 blue:212.0 alpha:1.0];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationYellowBG"] forBarMetrics:UIBarMetricsDefault];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *modal=[[NSUserDefaults standardUserDefaults] objectForKey:@"yejianMode"];
    if ([modal isEqualToString:@"night"]) {
        [self exchangeBackGround:YES];
    }
    else
    {
        [self exchangeBackGround:NO];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeShare" object:nil];
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
