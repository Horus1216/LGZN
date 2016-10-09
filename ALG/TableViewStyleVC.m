//
//  TableViewStyleVC.m
//  ALG
//
//  Created by Horus on 16/9/8.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "TableViewStyleVC.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "CusTabelViewCell.h"
#import "showWebView.h"
#import "SDRefresh.h"
#import "MBProgressHUD.h"

@interface TableViewStyleVC ()
{
    NSFileManager *fileManager;
    NSString *categoryData;
    NSMutableArray *articleArray;
    NSMutableArray *articleTableArray;
    UIScrollView *AscrollView;
    UIPageControl *pageControll;
    UILabel *titleLabel;
    int indexNum;
    UITableView *AtableView;
    int page;
    UIScrollView *backScrollView;
    
}
@property (nonatomic, strong) SDRefreshHeaderView *refreshHeaderView;
@property (nonatomic, strong) SDRefreshFooterView *refreshFooterView;

@end


@implementation TableViewStyleVC

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
    
    backScrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    backScrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:backScrollView];
    
    indexNum=1;
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
            }
            [self performSelector:@selector(refreshData) withObject:nil afterDelay:1];
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
    articleTableArray=[NSMutableArray array];
    for (int i=6; i<[articleArray count]; i++) {
        [articleTableArray addObject:articleArray[i]];
    }
    backScrollView.contentSize=CGSizeMake(self.view.bounds.size.width, 64+AscrollView.frame.size.height+[articleTableArray count]*80);
    AtableView.frame=CGRectMake(0, AscrollView.frame.origin.y+AscrollView.frame.size.height, self.view.bounds.size.width, [articleTableArray count]*80);
    
    [AscrollView reloadInputViews];
    [AtableView reloadData];
    
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

-(void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear
{
    articleArray=[NSMutableArray arrayWithContentsOfFile:categoryData];
    articleTableArray=[NSMutableArray array];
    for (int i=6; i<[articleArray count]; i++) {
        [articleTableArray addObject:articleArray[i]];
    }
    
    AscrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 170)];
    AscrollView.backgroundColor=[UIColor clearColor];
    AscrollView.showsHorizontalScrollIndicator=NO;
    AscrollView.bounces=YES;
    AscrollView.pagingEnabled=YES;
    AscrollView.delegate=self;
    [backScrollView addSubview:AscrollView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [AscrollView addGestureRecognizer:tap];
    
    
    UIImageView *showTitle=[[UIImageView alloc]initWithFrame:CGRectMake(0, AscrollView.bounds.size.height-25, AscrollView.bounds.size.width, 25)];
    showTitle.image=[UIImage imageNamed:@"navigationYeWanBG"];
    showTitle.alpha=0.5;
    [backScrollView addSubview:showTitle];
    
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, AscrollView.bounds.size.height-25, AscrollView.bounds.size.width, 25)];
    titleLabel.text=[articleArray[0] objectForKey:@"title"];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont systemFontOfSize:12];
    [backScrollView addSubview:titleLabel];
    
    pageControll=[[UIPageControl alloc]initWithFrame:CGRectZero];
    pageControll.numberOfPages=6;
    pageControll.pageIndicatorTintColor=[UIColor whiteColor];
    pageControll.currentPageIndicatorTintColor=[UIColor lightGrayColor];
    CGSize size=[pageControll sizeForNumberOfPages:6];
    pageControll.frame=CGRectMake(AscrollView.bounds.size.width-size.width, AscrollView.bounds.size.height-30, size.width, size.height);
    [backScrollView addSubview:pageControll];
    
    for (int i=0; i<6; i++) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(AscrollView.bounds.size.width*(i+1), 0, AscrollView.bounds.size.width, AscrollView.bounds.size.height)];
        NSDictionary *dic=[articleArray objectAtIndex:i];
        NSString *url=[dic objectForKey:@"imageURL"];
        [imageView setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"defaultimg"]];
        [AscrollView addSubview:imageView];
    }
    
    UIImageView *imageView0=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AscrollView.bounds.size.width, AscrollView.bounds.size.height)];
    NSDictionary *dic0=[articleArray objectAtIndex:5];
    NSString *url0=[dic0 objectForKey:@"imageURL"];
    [imageView0 setImageWithURL:[NSURL URLWithString:url0] placeholderImage:[UIImage imageNamed:@"defaultimg"]];
    [AscrollView addSubview:imageView0];
    
    UIImageView *imageView8=[[UIImageView alloc]initWithFrame:CGRectMake(7*AscrollView.bounds.size.width, 0, AscrollView.bounds.size.width, AscrollView.bounds.size.height)];
    NSDictionary *dic8=[articleArray objectAtIndex:0];
    NSString *url8=[dic8 objectForKey:@"imageURL"];
    [imageView8 setImageWithURL:[NSURL URLWithString:url8] placeholderImage:[UIImage imageNamed:@"defaultimg"]];
    [AscrollView addSubview:imageView8];
    AscrollView.contentOffset=CGPointMake(AscrollView.bounds.size.width, 0);
    AscrollView.contentSize=CGSizeMake(AscrollView.bounds.size.width*8, AscrollView.bounds.size.height);
    
    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    
    AtableView=[[UITableView alloc]initWithFrame:CGRectMake(0, AscrollView.frame.origin.y+AscrollView.frame.size.height, self.view.bounds.size.width, [articleTableArray count]*80) style:UITableViewStylePlain];
    AtableView.backgroundColor=[UIColor clearColor];
    AtableView.delegate=self;
    AtableView.dataSource=self;
    AtableView.scrollEnabled=NO;
    [backScrollView addSubview:AtableView];
    backScrollView.contentSize=CGSizeMake(self.view.bounds.size.width, 170+64+[articleTableArray count]*80);
    
    self.refreshHeaderView = [SDRefreshHeaderView refreshView];
    [self.refreshHeaderView addToScrollView:backScrollView];
    __weak TableViewStyleVC *weakSelf = self;
    self.refreshHeaderView.beginRefreshingOperation = ^{
        [weakSelf reloadNetworkData:YES];
    };
    
    
    self.refreshFooterView = [SDRefreshFooterView refreshView];
    [self.refreshFooterView addToScrollView:backScrollView];
    self.refreshFooterView.beginRefreshingOperation = ^{
        [weakSelf reloadNetworkData:NO];
    };
    
}

-(void)tapAction
{
    showWebView *vc=[[showWebView alloc]initWithNSString:[[articleArray objectAtIndex:pageControll.currentPage] objectForKey:@"content"] title:[[articleArray objectAtIndex:pageControll.currentPage] objectForKey:@"title"] articleID:[[[articleArray objectAtIndex:pageControll.currentPage] objectForKey:@"content"] integerValue] ImageUrl:[[articleArray objectAtIndex:pageControll.currentPage] objectForKey:@"imageURL"]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [articleTableArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify=@"myCell";
    CusTabelViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell=[[CusTabelViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.backgroundColor=[UIColor clearColor];
    }
    if (articleTableArray) {
        [cell setInfoWith:[articleTableArray objectAtIndex:indexPath.row] indexNumber:indexPath.row];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic=[articleTableArray objectAtIndex:indexPath.row];
    showWebView *vc=[[showWebView alloc]initWithNSString:[dic objectForKey:@"content"] title:[dic objectForKey:@"title"] articleID:[[dic objectForKey:@"articleId"] integerValue] ImageUrl:[dic objectForKey:@"imageURL"]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)autoScroll
{
    [UIView animateWithDuration:1.5 animations:^{
        [AscrollView scrollRectToVisible:CGRectMake(AscrollView.bounds.size.width*(indexNum+1), 0, AscrollView.bounds.size.width, AscrollView.bounds.size.height) animated:NO];
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:AscrollView];
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==AscrollView) {
        indexNum=scrollView.contentOffset.x/scrollView.bounds.size.width;
        pageControll.currentPage=indexNum-1;
        
        if (indexNum==7) {
            [scrollView setContentOffset:CGPointMake(1*scrollView.bounds.size.width, 0)];
            pageControll.currentPage=0;
            titleLabel.text=[articleArray[0] objectForKey:@"title"];
            return;
        }
        if (indexNum==0) {
            [scrollView setContentOffset:CGPointMake(6*scrollView.bounds.size.width, 0)];
            pageControll.currentPage=5;
            titleLabel.text=[articleArray[5] objectForKey:@"title"];
        }
        titleLabel.text=[articleArray[pageControll.currentPage] objectForKey:@"title"];
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

@end
