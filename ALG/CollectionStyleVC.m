//
//  CollectionStyleVC.m
//  ALG
//
//  Created by Horus on 16/9/10.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "CollectionStyleVC.h"
#import "AFNetworking.h"
#import "CusCollectionViewCell.h"
#import "showWebView.h"
#import "SDRefresh.h"
#import "MBProgressHUD.h"

@interface CollectionStyleVC ()
{
    UICollectionView *AcollectionView;
    NSFileManager *fileManager;
    NSString *categoryData;
    NSMutableArray *articleArray;
    int page;
}

@property (nonatomic, strong) SDRefreshHeaderView *refreshHeaderView;
@property (nonatomic, strong) SDRefreshFooterView *refreshFooterView;

@end

@implementation CollectionStyleVC

-(instancetype)initWithDictionary:(NSDictionary *)infoDic
{
    if (self=[super init]) {
        self.infoDic=infoDic;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:222.0 green:226.0 blue:212.0 alpha:1.0];
    page=1;
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    label.text=[self.infoDic objectForKey:@"categoryName"];
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
    
    fileManager=[NSFileManager defaultManager];
    NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savingData=[libraryPath stringByAppendingPathComponent:@"SavingData"];
    NSString *dataName=[NSString stringWithFormat:@"categoryData_%@.plist",[self.infoDic objectForKey:@"categoryId"]];
    categoryData=[savingData stringByAppendingPathComponent:dataName];
    BOOL isFile=YES;
    if (![fileManager fileExistsAtPath:categoryData isDirectory:&isFile]) {
        [fileManager createFileAtPath:categoryData contents:nil attributes:nil];
    }
    
    int categoryId=[[self.infoDic objectForKey:@"categoryId"]intValue];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=@"http://appcms.m2lux.com/interface/GetArticle.php";
    NSDictionary *parameter=@{@"categoryId":[NSString stringWithFormat:@"%i",categoryId],@"isPad":@"0",@"count":@"10"};
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (responseObject) {
            [(NSArray *)responseObject writeToFile:categoryData atomically:YES];
            [self viewWillAppear];
        }
    }
         failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
             
         }];
}

-(void)viewWillAppear
{
    articleArray=[NSMutableArray arrayWithContentsOfFile:categoryData];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
    AcollectionView=[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    AcollectionView.backgroundColor=[UIColor clearColor];
    AcollectionView.delegate=self;
    AcollectionView.dataSource=self;
    [self.view addSubview:AcollectionView];
    
    [AcollectionView registerClass:[CusCollectionViewCell class] forCellWithReuseIdentifier:@"CusCollectionViewCell"];
    
    self.refreshHeaderView = [SDRefreshHeaderView refreshView];
    [self.refreshHeaderView addToScrollView:AcollectionView];
    __weak CollectionStyleVC *weakSelf = self;
    self.refreshHeaderView.beginRefreshingOperation = ^{
        [weakSelf reloadNetworkData:YES];
    };
    
    
    self.refreshFooterView = [SDRefreshFooterView refreshView];
    [self.refreshFooterView addToScrollView:AcollectionView];
    self.refreshFooterView.beginRefreshingOperation = ^{
        [weakSelf reloadNetworkData:NO];
    };
}

- (void)reloadNetworkData:(BOOL)flag {
    
    int categoryId=[[self.infoDic objectForKey:@"categoryId"]intValue];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=@"http://appcms.m2lux.com/interface/GetArticle.php";
    if (flag) {
        NSDictionary *parameter=@{@"categoryId":[NSString stringWithFormat:@"%i",categoryId],@"isPad":@"0",@"count":@"10"};
        [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if (responseObject) {
                [(NSArray *)responseObject writeToFile:categoryData atomically:YES];
                if (articleArray) {
                    [articleArray removeAllObjects];
                    articleArray=nil;
                }
                articleArray=[NSMutableArray arrayWithContentsOfFile:categoryData];
                [self performSelector:@selector(refreshData) withObject:nil afterDelay:1];
            }
        }
             failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                 [self performSelector:@selector(refreshDataFail) withObject:nil afterDelay:1];
             }];
    }
    else {
        page++;
        NSDictionary *parameter=@{@"categoryId":[NSString stringWithFormat:@"%i",categoryId],@"page":[NSString stringWithFormat:@"%i",page],@"isPad":@"0",@"count":@"10"};
        [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            if (responseObject) {
                [articleArray addObjectsFromArray:(NSArray *)responseObject];
                [articleArray writeToFile:categoryData atomically:YES];
            }
            [self performSelector:@selector(refreshData) withObject:nil afterDelay:1];
        }
             failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                 [self performSelector:@selector(refreshDataFail) withObject:nil afterDelay:1];
             }];
    }
}

- (void)refreshDataFail {
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"刷新失败～";
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

- (void)refreshData {
    
    [self.refreshHeaderView endRefreshing];
    [self.refreshFooterView endRefreshing];
    [AcollectionView reloadData];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"刷新完成～";
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [articleArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify=@"CusCollectionViewCell";
    NSDictionary *dic=[articleArray objectAtIndex:indexPath.row];
    CusCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell setImageString:[dic objectForKey:@"imageURL"] Title:[dic objectForKey:@"title"]];
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 10, 15, 10);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((AcollectionView.frame.size.width-30)/2, 200);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=[articleArray objectAtIndex:indexPath.row];
    showWebView *vc=[[showWebView alloc]initWithNSString:[dic objectForKey:@"content"] title:[dic objectForKey:@"title"] articleID:[[dic objectForKey:@"articleId"] integerValue] ImageUrl:[dic objectForKey:@"imageURL"]];
    [self.navigationController pushViewController:vc animated:YES];
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
