//
//  showWebView.m
//  ALG
//
//  Created by Horus on 16/9/10.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "showWebView.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "PinlunCell.h"
#import "SDRefresh.h"
#import "FenXiang.h"
#import "LoginAndRegisterVC.h"
#import "WebSheZi.h"

@interface showWebView ()
{
    UIWebView *AwebView;
    NSFileManager *fileManager;
    int pageNum;
    UITableView *pinlunTableView;
    NSMutableArray *arrayData;
    UILabel *totalPL;
    BOOL showFX;
    BOOL showSZ;
    FenXiang *fxView;
    WebSheZi *szView;
    NSString *btnTitle;
    UIView *noPinlunView;
}

@property (nonatomic, strong) ChatKeyBoardView *chatKeyBoardView;
@property(nonatomic,retain)  MBProgressHUD *HUD;
@property (nonatomic, strong) SDRefreshFooterView *refreshFooterView;

@end

@implementation showWebView

-(instancetype)initWithNSString:(NSString *)htmlString title:(NSString *)title articleID:(NSInteger)articleID ImageUrl:(NSString *)imageUrl
{
    if (self=[super init]) {
        self.htmlString=htmlString;
        self.Atitle=title;
        self.articleID=articleID;
        self.imageUrl=imageUrl;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    pageNum=1;
    arrayData=[NSMutableArray array];
    showFX=YES;
    showSZ=YES;
    
    self.view.backgroundColor=[UIColor colorWithRed:222.0 green:226.0 blue:212.0 alpha:1.0];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationWhiteBG"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *leftItemButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftItemButton.frame=CGRectMake(0, 0, 20, 20);
    [leftItemButton setBackgroundImage:[UIImage imageNamed:@"btn_back_2_New"] forState:UIControlStateNormal];
    [leftItemButton addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftItemButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    self.navigationController.interactivePopGestureRecognizer.enabled=YES;
    
    UIImageView *redImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 5, 60)];
    redImage.backgroundColor=[UIColor redColor];
    [self.view addSubview:redImage];
    
    UILabel *Atitle=[[UILabel alloc]initWithFrame:CGRectMake(redImage.frame.origin.x+redImage.frame.size.width+5, redImage.frame.origin.y, self.view.bounds.size.width-50, 60)];
    Atitle.text=self.Atitle;
    Atitle.backgroundColor=[UIColor clearColor];
    Atitle.numberOfLines=2;
    [self.view addSubview:Atitle];
    
    AwebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height-164)];
    AwebView.backgroundColor=[UIColor clearColor];
    AwebView.delegate=self;
    [AwebView loadHTMLString:self.htmlString baseURL:nil];
    [self.view addSubview:AwebView];
    
    UIButton *pinlun=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [pinlun setBackgroundImage:[UIImage imageNamed:@"btn_comment"] forState:UIControlStateNormal];
    [pinlun addTarget:self action:@selector(pinlunButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *pinlunItem=[[UIBarButtonItem alloc]initWithCustomView:pinlun];
    UIButton *fenxiang=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [fenxiang setBackgroundImage:[UIImage imageNamed:@"btn_share"] forState:UIControlStateNormal];
    UIBarButtonItem *fenxiangItem=[[UIBarButtonItem alloc]initWithCustomView:fenxiang];
    [fenxiang addTarget:self action:@selector(fenxiangBtn) forControlEvents:UIControlEventTouchUpInside];
    UIButton *shezhi=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [shezhi setBackgroundImage:[UIImage imageNamed:@"btn_function"] forState:UIControlStateNormal];
    [shezhi addTarget:self action:@selector(sheziBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shezhiItem=[[UIBarButtonItem alloc]initWithCustomView:shezhi];
    
    [self.navigationItem setRightBarButtonItems:@[shezhiItem,fenxiangItem,pinlunItem]];
    
    self.chatKeyBoardView = [[ChatKeyBoardView alloc]initWithDelegate:self superView:self.view];
    self.chatKeyBoardView.frame = CGRectMake(0,CGRectGetHeight(self.view.bounds)-104,self.view.bounds.size.width, CGRectGetHeight(self.view.bounds)+0.6);
    
    fileManager=[NSFileManager defaultManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fenxiangBtn) name:@"closeShare" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sheziBtn) name:@"closeShare1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setZT:) name:@"setZT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNight:) name:@"night" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDayLight:) name:@"daylight" object:nil];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
    for (UIView *scrollview in AwebView.subviews) {
        scrollview.userInteractionEnabled=YES;
        [scrollview addGestureRecognizer:tap];
        for (UIView *browserView in scrollview.subviews) {
            browserView.userInteractionEnabled=YES;
            [browserView addGestureRecognizer:tap];
        }
    }
    [self.view addGestureRecognizer:tap];
}


-(void)tapGesture
{
    [self.chatKeyBoardView tapAction];
}

-(void)setNight:(NSNotification *)msg
{
    NSString *script2 = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.background='%@'", @"#132346"];
    [AwebView stringByEvaluatingJavaScriptFromString:script2];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationYeWanBG"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationYeWanBG"] forBarMetrics:UIBarMetricsDefault];
}

-(void)setDayLight:(NSNotification *)msg
{
    NSString *script2 = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.background='%@'", @"#FFFFFF"];
    [AwebView stringByEvaluatingJavaScriptFromString:script2];
    self.view.backgroundColor=[UIColor colorWithRed:222.0 green:226.0 blue:212.0 alpha:1.0];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationWhiteBG"] forBarMetrics:UIBarMetricsDefault];
}

-(void)setZT:(NSNotification *)msg
{
    if ([msg.object isEqualToString:@"140"]) {
        btnTitle=@"大号";
    }
    else if ([msg.object isEqualToString:@"100"])
    {
        btnTitle=@"中号";
    }
    else
    {
        btnTitle=@"小号";
    }
    int zhiTi=[msg.object intValue];
    NSString *script = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", zhiTi];
    [AwebView stringByEvaluatingJavaScriptFromString:script];
    [AwebView reloadInputViews];
}

-(void)sheziBtn
{
    [self.chatKeyBoardView tapAction];
    if (fxView) {
        [fxView removeFromSuperview];
        fxView=nil;
        showFX=YES;
    }
    if (showSZ==YES) {
        szView=[[NSBundle mainBundle] loadNibNamed:@"WebSheZi" owner:self.view options:nil][0];
        szView.frame=CGRectMake(0, -216, self.view.bounds.size.width, 216);
        [szView setWebView:btnTitle];
        [self.view addSubview:szView];
        [UIView animateWithDuration:0.6 animations:^{
            szView.transform=CGAffineTransformMakeTranslation(0, 216);
        }];
        showSZ=NO;
    }
    else
    {
        [UIView animateWithDuration:0.6 animations:^{
            szView.transform=CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            [szView removeFromSuperview];
            szView=nil;
            showSZ=YES;
        }];
    }
}

-(void)fenxiangBtn
{
    [self.chatKeyBoardView tapAction];
    if (szView) {
        [szView removeFromSuperview];
        szView=nil;
        showSZ=YES;
    }
    if (showFX==YES) {
        fxView=[[NSBundle mainBundle] loadNibNamed:@"FenXiang" owner:self.view options:nil][0];
        fxView.frame=CGRectMake(0, -216, self.view.bounds.size.width, 216);
        [fxView setInfoWithString:@[[NSNumber numberWithInteger:self.articleID],self.Atitle,self.htmlString,self.imageUrl]];
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

-(void)pinlunButton
{
//    [self.chatKeyBoardView.chatInputTextView resignFirstResponder];
    [self.chatKeyBoardView tapAction];
    if (pinlunTableView) {
        [pinlunTableView removeFromSuperview];
        pinlunTableView=nil;
        AwebView.frame=CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height-104);
        return;
    }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        NSString *url=@"http://112.74.108.147:9080/Yidaforum/user/commentlist.do";
        NSDictionary *parameter=@{@"articleid":[NSString stringWithFormat:@"%li",(long)self.articleID],@"pageno":[NSString stringWithFormat:@"%i",pageNum]};
        [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if ([[responseObject objectForKey:@"code"]integerValue]==200) {
                if ([responseObject objectForKey:@"result"]) {
                    NSDictionary *resultDic=[responseObject objectForKey:@"result"];
                    if ([resultDic class]!=[NSNull class]) {
                        if ([arrayData count]!=0) {
                            [arrayData removeAllObjects];
                        }
                        [arrayData addObjectsFromArray:[resultDic objectForKey:@"commentlist"]];
                        int total=[[resultDic objectForKey:@"total"]intValue];
                        if (total<=3) {
                            pinlunTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.chatKeyBoardView.frame.origin.y-30-50*total, self.view.bounds.size.width, 50*total+30) style:UITableViewStylePlain];
                        }
                        else
                        {
                            pinlunTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.chatKeyBoardView.frame.origin.y-30-50*3, self.view.bounds.size.width, 50*3+30) style:UITableViewStylePlain];
                        }
                        pinlunTableView.delegate=self;
                        pinlunTableView.dataSource=self;
                        pinlunTableView.backgroundColor=[UIColor colorWithRed:222.0/255 green:226.0/255 blue:212.0/255 alpha:1.0];
                        [self.view addSubview:pinlunTableView];
                        
                        AwebView.frame=CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height-100-pinlunTableView.frame.size.height);
                        
                        self.refreshFooterView = [SDRefreshFooterView refreshView];
                        [self.refreshFooterView addToScrollView:pinlunTableView];
                        showWebView *weakSelf=self;
                        self.refreshFooterView.beginRefreshingOperation = ^{
                            [weakSelf reloadNetworkData:NO];
                        };
                    }
                    else
                    {
                        noPinlunView=[[UIView alloc]initWithFrame:CGRectMake(0, self.chatKeyBoardView.frame.origin.y-30, self.view.bounds.size.width, 30)];
                        noPinlunView.backgroundColor=[UIColor whiteColor];
                        totalPL=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 30)];
                        totalPL.text=@"暂无评论~";
                        totalPL.font=[UIFont systemFontOfSize:15];
                        [noPinlunView addSubview:totalPL];
                        [self.view addSubview:noPinlunView];
                    }
                }
            }
            else
            {
                noPinlunView=[[UIView alloc]initWithFrame:CGRectMake(0, self.chatKeyBoardView.frame.origin.y-30, self.view.bounds.size.width, 30)];
                noPinlunView.backgroundColor=[UIColor whiteColor];
                totalPL=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 30)];
                totalPL.text=@"暂无评论~";
                totalPL.font=[UIFont systemFontOfSize:15];
                [noPinlunView addSubview:totalPL];
                [self.view addSubview:noPinlunView];
                
            }
            
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            noPinlunView=[[UIView alloc]initWithFrame:CGRectMake(0, self.chatKeyBoardView.frame.origin.y-30, self.view.bounds.size.width, 30)];
            noPinlunView.backgroundColor=[UIColor whiteColor];
            totalPL=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 30)];
            totalPL.text=@"暂无评论~";
            totalPL.font=[UIFont systemFontOfSize:15];
            [noPinlunView addSubview:totalPL];
            [self.view addSubview:noPinlunView];
        }];
    

}

- (void)reloadNetworkData:(BOOL)flag {
    
    pageNum++;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=@"http://112.74.108.147:9080/Yidaforum/user/commentlist.do";
    NSDictionary *parameter=@{@"articleid":[NSString stringWithFormat:@"%li",(long)self.articleID],@"pageno":[NSString stringWithFormat:@"%i",pageNum]};
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([[responseObject objectForKey:@"code"]integerValue]==200) {
            if ([[responseObject objectForKey:@"result"] class]!=[NSNull class]) {
                NSDictionary *resultDic=[responseObject objectForKey:@"result"];
                [arrayData addObjectsFromArray:[resultDic objectForKey:@"commentlist"]];
            }
            [self performSelector:@selector(refreshData) withObject:nil afterDelay:1];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];

    
}
- (void)refreshData {
    
    [self.refreshFooterView endRefreshing];
    int total=(int)[arrayData count];
    if (total<=3) {
        pinlunTableView.frame=CGRectMake(0, self.chatKeyBoardView.frame.origin.y-30-50*total, self.view.bounds.size.width, 50*total+30);
    }
    else
    {
        pinlunTableView.frame=CGRectMake(0, self.chatKeyBoardView.frame.origin.y-30-50*3, self.view.bounds.size.width, 50*3+30);
    }
    [pinlunTableView reloadData];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:pinlunTableView];
    [self.view addSubview:HUD];
    HUD.labelText = @"刷新完成～";
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify=@"mycell";
    PinlunCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell=[[PinlunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.backgroundColor=[UIColor clearColor];
    }
    if (arrayData) {
        [cell setInfoWithDictionary:[arrayData objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    view.backgroundColor=[UIColor colorWithRed:222.0/255 green:226.0/255 blue:212.0/255 alpha:1.0];
    totalPL=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 30)];
    NSString *labelText=[NSString stringWithFormat:@"%lu条评论内容",(unsigned long)[arrayData count]];
    totalPL.text=labelText;
    totalPL.font=[UIFont systemFontOfSize:13];
    [view addSubview:totalPL];
    
    UIButton *refresh=[UIButton buttonWithType:UIButtonTypeCustom];
    refresh.frame=CGRectMake(view.bounds.size.width-50, 0, 30, 30);
    [refresh setImage:[UIImage imageNamed:@"refresh-click"] forState:UIControlStateNormal];
    [refresh addTarget:self action:@selector(refreshButton) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:refresh];
    return view;
}

-(void)refreshButton
{
    pageNum=0;
    if ([arrayData count]!=0) {
        [arrayData removeAllObjects];
    }
    [self reloadNetworkData:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *meta = [NSString stringWithFormat:@"var script = document.createElement('script');"
                      "script.type = 'text/javascript';"
                      "script.text = \"function ResizeImages() { "
                      "var myimg,oldwidth;"
                      "var maxwidth=%f;"
                      "for(i=0;i <document.images.length;i++){"
                      "myimg = document.images[i];"
                      "if(myimg.width > maxwidth){"
                      "oldwidth = myimg.width;"
                      "myimg.width = maxwidth;"
                      "myimg.height = myimg.height;"
                      "}"
                      "}"
                      "}\";"
                      "document.getElementsByTagName('head')[0].appendChild(script);", webView.bounds.size.width-100];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    NSString *script = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", 100];
    [webView stringByEvaluatingJavaScriptFromString:script];

    NSString *modal=[[NSUserDefaults standardUserDefaults] objectForKey:@"yejianMode"];
    if ([modal isEqualToString:@"night"]) {
        NSString *script2 = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.background='%@'", @"#132346"];
        [AwebView stringByEvaluatingJavaScriptFromString:script2];
    }

}


-(void)leftItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationWhiteBG"] forBarMetrics:UIBarMetricsDefault];
    NSString *modal=[[NSUserDefaults standardUserDefaults] objectForKey:@"yejianMode"];
    if ([modal isEqualToString:@"night"]) {
        [self exchangeBackGround:YES];
    }
    else
    {
        [self exchangeBackGround:NO];
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
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationWhiteBG"] forBarMetrics:UIBarMetricsDefault];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationYellowBG"] forBarMetrics:UIBarMetricsDefault];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"closeShare" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"closeShare1" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"setZT" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"night" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"daylight" object:nil];
}

-(void)keyBoardView:(ChatKeyBoardView*)keyBoard sendMessage:(NSString*)message {
    
    BOOL isFile=YES;
    NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *tagFile=[libraryPath stringByAppendingPathComponent:@"tagFile"];
    NSString *loginSucc=[tagFile stringByAppendingPathComponent:@"loginSucc.tag"];
    NSString *savingData=[libraryPath stringByAppendingPathComponent:@"SavingData"];
    NSString *userInfo=[savingData stringByAppendingPathComponent:@"userInfo.plist"];
    
    if (![fileManager fileExistsAtPath:loginSucc isDirectory:&isFile]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"你还未登录,请先登录!" delegate:self cancelButtonTitle:@"不用了" otherButtonTitles:@"现在登录", nil];
        [alert show];
    }
    if ([fileManager fileExistsAtPath:loginSucc isDirectory:&isFile]) {
        if (message && message.length > 0) {
            NSDictionary *dic=[NSDictionary dictionaryWithContentsOfFile:userInfo];
            NSString *userid=[dic objectForKey:@"id"];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            NSString *url=@"http://112.74.108.147:9080/Yidaforum/user/articlecomment.do";
            NSDictionary *parameter=@{@"userid":userid,@"articleid":[NSString stringWithFormat:@"%li",(long)self.articleID],@"content":message};
            [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                if ([[responseObject objectForKey:@"code"]integerValue]==200) {
                    if (pinlunTableView) {
                        [self refreshButton];
                    }
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            
        }];
    }
        else {
            self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:self.HUD];
            self.HUD.labelText = @"消息内容不能为空～";
            self.HUD.mode = MBProgressHUDModeText;
            [self.HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                [self.HUD removeFromSuperview];
                self.HUD = nil;
            }];
        }
    }

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

-(void)keyBoardView:(ChatKeyBoardView *)keyBoard ChangeDuration:(CGFloat)durtaion
{
    if (pinlunTableView) {
        [self.view insertSubview:pinlunTableView belowSubview:self.chatKeyBoardView];
    }
    if (noPinlunView) {
        [noPinlunView removeFromSuperview];
        noPinlunView=nil;
    }
}
@end
