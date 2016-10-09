//
//  ShouCangVC.m
//  ALG
//
//  Created by Horus on 16/9/14.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "ShouCangVC.h"
#import "ShouCangInfo.h"
#import "UIImageView+AFNetworking.h"
#import "ShouCangCell.h"
#import "showWebView.h"

@interface ShouCangVC ()
{
    UITableView *AtableView;
    NSMutableArray *dataArray;
}
@end

@implementation ShouCangVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:222.0 green:226.0 blue:212.0 alpha:1.0];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    label.text=@"我的收藏";
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
    rightItemButton.frame=CGRectMake(0, 0, 40, 30);
    [rightItemButton setTitle:@"编辑" forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(deleteTableView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightItemButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    self.navigationController.interactivePopGestureRecognizer.enabled=YES;
    
    AtableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    AtableView.delegate=self;
    AtableView.dataSource=self;
    AtableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:AtableView];
    
    NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savingData=[libraryPath stringByAppendingPathComponent:@"SavingData"];
    NSString *shouCang=[savingData stringByAppendingPathComponent:@"shouCang"];
    dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:shouCang];
}

- (void)deleteTableView:(UIButton*)button
{
    if ([button.titleLabel.text isEqualToString:@"编辑"])
    {
        [AtableView setEditing:YES animated:YES];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        return;
    }
    if ([button.titleLabel.text isEqualToString:@"完成"])
    {
        [AtableView setEditing:NO animated:YES];
        [button setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (!tableView.editing) return UITableViewCellEditingStyleNone;
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSUInteger row = [indexPath row];
        if (dataArray && row < [dataArray count])
        {
            [dataArray removeObjectAtIndex:row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }
        NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *savingData=[libraryPath stringByAppendingPathComponent:@"SavingData"];
        NSString *shouCang=[savingData stringByAppendingPathComponent:@"shouCang"];
        [NSKeyedArchiver archiveRootObject:dataArray toFile:shouCang];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShouCangInfo *info=[dataArray objectAtIndex:indexPath.row];
    static NSString *identify=@"myCell";
    ShouCangCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell=[[ShouCangCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.backgroundColor=[UIColor clearColor];
    }
    if (dataArray) {
        [cell setInfoWithShouCangInfo:info];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShouCangInfo *info=[dataArray objectAtIndex:indexPath.row];
    showWebView *vc=[[showWebView alloc]initWithNSString:info.htmlString title:info.Atitle articleID:info.articleID ImageUrl:info.imageUrl];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savingData=[libraryPath stringByAppendingPathComponent:@"SavingData"];
    NSString *shouCang=[savingData stringByAppendingPathComponent:@"shouCang"];
    dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:shouCang];
    [AtableView reloadData];
    
    NSString *modal=[[NSUserDefaults standardUserDefaults] objectForKey:@"yejianMode"];
    if ([modal isEqualToString:@"night"]) {
        [self exchangeBackGround:YES];
    }
    else
    {
        [self exchangeBackGround:NO];
    }
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
