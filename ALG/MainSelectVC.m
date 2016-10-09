//
//  MainSelectVC.m
//  ALG
//
//  Created by Horus on 16/9/6.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "MainSelectVC.h"
#import "MainSelectVCCell.h"

@interface MainSelectVC ()
{
    UITableView *AtableView;
    NSArray *arrayData;
    NSDictionary *showDic;
}
@end

@implementation MainSelectVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:222.0 green:226.0 blue:212.0 alpha:1.0];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savingData=[libraryPath stringByAppendingPathComponent:@"SavingData"];
    NSString *categoryData=[savingData stringByAppendingPathComponent:@"categoryData.plist"];
    BOOL isDirectory=NO;
    if ([fileManager fileExistsAtPath:categoryData isDirectory:&isDirectory]) {
        arrayData=[NSArray arrayWithContentsOfFile:categoryData];
    }
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    label.text=@"菜单选择";
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

-(void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savingData=[libraryPath stringByAppendingPathComponent:@"SavingData"];
    BOOL isDirectory=NO;
    NSString *showImageView=[savingData stringByAppendingPathComponent:@"showImageView.plist"];
    if ([fileManager fileExistsAtPath:showImageView isDirectory:&isDirectory]) {
        showDic=[NSDictionary dictionaryWithContentsOfFile:showImageView];
    }
    NSMutableArray *arrayYes=[showDic objectForKey:@"YES"];
    
    static NSString *identify=@"myCell";
    MainSelectVCCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell=[[MainSelectVCCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        for (NSNumber *obj in arrayYes) {
            if (indexPath.row==[obj integerValue]) {
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
            }
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
    }
    if (arrayData) {
        [cell setInfo:[arrayData objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainSelectVCCell *cell=(MainSelectVCCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height+10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savingData=[libraryPath stringByAppendingPathComponent:@"SavingData"];
    BOOL isDirectory=NO;
    NSString *showImageView=[savingData stringByAppendingPathComponent:@"showImageView.plist"];
    if ([fileManager fileExistsAtPath:showImageView isDirectory:&isDirectory]) {
        showDic=[NSDictionary dictionaryWithContentsOfFile:showImageView];
    }
    
    NSMutableArray *arrayYes=[showDic objectForKey:@"YES"];
    

    
    MainSelectVCCell *cell=(MainSelectVCCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType==UITableViewCellAccessoryCheckmark) {
        if ([arrayYes count]==4) {
            return;
        }
        cell.accessoryType=UITableViewCellAccessoryNone;
        [arrayYes removeObject:[NSNumber numberWithInteger:indexPath.row]];
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        [arrayYes addObject:[NSNumber numberWithInteger:indexPath.row]];
    }
    [arrayYes sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSInteger ob1=(NSInteger)obj1;
        NSInteger ob2=(NSInteger)obj2;
        return ob1>ob2;
    }];
    [showDic writeToFile:showImageView atomically:YES];
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

@end
