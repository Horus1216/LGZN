//
//  MainController.m
//  ALG
//
//  Created by Horus on 16/9/6.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "MainController.h"
#import "AFNetworking.h"
#import "MainVCCollectionCell.h"
#import "MainSelectVC.h"
#import "UIImageView+AFNetworking.h"
#import "TableViewStyleVC.h"
#import "CollectionStyleVC.h"
#import "TotalSheZiVC.h"

#define k1ScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define k1ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface MainController ()
{
    NSFileManager *fileManager;
    UICollectionView *AcollectionView;
    NSMutableArray *mainArrayData;
    NSMutableArray *getSavingData;
    NSDictionary *showDic;
    UIImageView *btnImage;
}

@property (nonatomic, strong) iCarousel *myCarousel;

@end

@implementation MainController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:222.0 green:226.0 blue:212.0 alpha:1.0];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationYellowBG"] forBarMetrics:UIBarMetricsDefault];
    UIImageView *itemView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    itemView.image=[UIImage imageNamed:@"CrazyFashion"];
    self.navigationItem.titleView=itemView;
    
    mainArrayData=[NSMutableArray array];
    
    UIButton *leftItemButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftItemButton.frame=CGRectMake(0, 0, 30, 30);
    [leftItemButton setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [leftItemButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftItemButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightItemButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.frame=CGRectMake(0, 0, 30, 30);
    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightItemButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=@"http://appcms.m2lux.com/interface/GetCategory.php";
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        fileManager=[NSFileManager defaultManager];
        NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *savingData=[libraryPath stringByAppendingPathComponent:@"SavingData"];
        NSString *categoryData=[savingData stringByAppendingPathComponent:@"categoryData.plist"];
        BOOL isDirectory=NO;
        BOOL isFile=YES;
        NSString *showImageView=[savingData stringByAppendingPathComponent:@"showImageView.plist"];
        NSString *tagFile=[libraryPath stringByAppendingPathComponent:@"tagFile"];
        NSString *isCollection=[tagFile stringByAppendingPathComponent:@"isCollection.tag"];
        
        if (![fileManager fileExistsAtPath:categoryData isDirectory:&isDirectory]) {
           [fileManager createFileAtPath:categoryData contents:nil attributes:nil];
        }
        if ([fileManager fileExistsAtPath:categoryData isDirectory:&isDirectory]) {
            if (responseObject) {
                [(NSMutableArray *)responseObject writeToFile:categoryData atomically:YES];
            }
            if ([fileManager fileExistsAtPath:isCollection isDirectory:&isFile]) {
                [self performSelector:@selector(addCollectionView:) withObject:(NSMutableArray *)responseObject afterDelay:1.0];
            }
            else
            {
                [self performSelector:@selector(addScrollView:) withObject:(NSMutableArray *)responseObject afterDelay:1.0];
            }
        }
        if (![fileManager fileExistsAtPath:showImageView isDirectory:&isDirectory]) {
            [fileManager createFileAtPath:showImageView contents:nil attributes:nil];
            NSMutableArray *array=[NSMutableArray arrayWithCapacity:8];
            for (int i=0; i<[(NSMutableArray *)responseObject count]; i++) {
                [array addObject:[NSNumber numberWithInteger:i]];
            }
            NSDictionary *showImageViewDic=@{@"YES":array};
            [showImageViewDic writeToFile:showImageView atomically:YES];
        }
        if (mainArrayData) {
            [mainArrayData removeAllObjects];
        }
        if ([fileManager fileExistsAtPath:showImageView isDirectory:&isDirectory]) {
            showDic=[NSDictionary dictionaryWithContentsOfFile:showImageView];
        }
        if ([fileManager fileExistsAtPath:categoryData isDirectory:&isDirectory]) {
            getSavingData=[NSMutableArray arrayWithContentsOfFile:categoryData];
        }
        for (NSNumber *obj in [showDic objectForKey:@"YES"]) {
            [mainArrayData addObject:[getSavingData objectAtIndex:[obj integerValue]]];
        }
        

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    
    btnImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-104, self.view.bounds.size.width, 40)];
    btnImage.backgroundColor=[UIColor colorWithRed:222.0 green:226.0 blue:212.0 alpha:1.0];
    btnImage.userInteractionEnabled=YES;
    [self.view addSubview:btnImage];
    
    UIButton *select=[UIButton buttonWithType:UIButtonTypeCustom];
    select.frame=CGRectMake((btnImage.bounds.size.width-40)/2, 0, 40, 40);
    [select addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    [select setBackgroundImage:[UIImage imageNamed:@"AddButton"] forState:UIControlStateNormal];
    [btnImage addSubview:select];
}

-(void)rightButtonAction
{
    TotalSheZiVC *vc=[[TotalSheZiVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)leftButtonAction
{
    fileManager=[NSFileManager defaultManager];
    NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    BOOL isFile=YES;
    NSString *tagFile=[libraryPath stringByAppendingPathComponent:@"tagFile"];
    NSString *isCollection=[tagFile stringByAppendingPathComponent:@"isCollection.tag"];
    NSString *isScrollView=[tagFile stringByAppendingPathComponent:@"isScrollView.tag"];
    if ([fileManager fileExistsAtPath:isCollection isDirectory:&isFile]) {
        [fileManager removeItemAtPath:isCollection error:nil];
        [fileManager createFileAtPath:isScrollView contents:nil attributes:nil];
        
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            AcollectionView.transform=CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            AcollectionView.alpha=0.0;
            if (!self.myCarousel) {
                [self addScrollView:mainArrayData];
            }
            else
            {
                self.myCarousel.transform=CGAffineTransformMakeScale(1.0, 1.0);
                self.myCarousel.alpha=1.0;
            }
        }];
    }
    else
    {
        [fileManager removeItemAtPath:isScrollView error:nil];
        [fileManager createFileAtPath:isCollection contents:nil attributes:nil];
        
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.myCarousel.transform=CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            self.myCarousel.alpha=0.0;
            if (!AcollectionView) {
                [self addCollectionView:mainArrayData];
            }
            else
            {
                AcollectionView.transform=CGAffineTransformMakeScale(1.0, 1.0);
                AcollectionView.alpha=1.0;
            }
        }];
    }
    
}

-(void)addScrollView:(NSArray *)dataArray
{
    self.myCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/2-130, self.view.bounds.size.width, 260)];
    self.myCarousel.backgroundColor = [UIColor clearColor];
    self.myCarousel.delegate = self;
    self.myCarousel.dataSource = self;
    self.myCarousel.type = iCarouselTypeLinear;
    [self.view addSubview:self.myCarousel];
    
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [mainArrayData count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k1ScreenWidth*0.56, k1ScreenHeight*0.45)];
        
        UIImageView *myView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height-40)];
        NSDictionary *dic=[mainArrayData objectAtIndex:index];
        NSString *url=[dic objectForKey:@"bigImageURL"];
        [myView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultimg"]];
        [view addSubview:myView];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, myView.frame.origin.y+myView.frame.size.height, myView.bounds.size.width, 30)];
        label.text=[dic objectForKey:@"categoryInfo"];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:12];
        [view addSubview:label];
    }

    return view;
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    transform = CATransform3DRotate(transform, M_PI/8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.myCarousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option) {
        case iCarouselOptionWrap: {
            return YES;
        }
        case iCarouselOptionSpacing: {
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax: {
            if (self.myCarousel.type == iCarouselTypeCustom)  {
                return 0.0f;
            }
            return value;
        }
        default:
            return value;
    }
    
    return value;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    NSDictionary *dic=[mainArrayData objectAtIndex:index];
    if ([[dic objectForKey:@"composeType"]integerValue]==1) {
        TableViewStyleVC *vc=[[TableViewStyleVC alloc]initWithDictionary:[mainArrayData objectAtIndex:index]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        CollectionStyleVC *vc=[[CollectionStyleVC alloc]initWithDictionary:[mainArrayData objectAtIndex:index]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
     NSArray *visibleViews = carousel.visibleItemViews;
     UIView *currentView = carousel.currentItemView;
    for (UIView *view in visibleViews) {
        if (view!=currentView) {
            view.alpha=0.4;
        }
        else
        {
            view.alpha=1.0;
        }
    }
}

-(void)addCollectionView:(NSArray *)dataArray
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    AcollectionView=[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    AcollectionView.delegate=self;
    AcollectionView.dataSource=self;
    AcollectionView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:AcollectionView];
    
    [AcollectionView registerClass:[MainVCCollectionCell class] forCellWithReuseIdentifier:@"MainVCCollectionCell"];
    
    [self.view bringSubviewToFront:btnImage];
}

-(void)selectAction
{
    MainSelectVC *vc=[[MainSelectVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [mainArrayData count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify=@"MainVCCollectionCell";
    MainVCCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell setInfo:[mainArrayData objectAtIndex:indexPath.row]];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((AcollectionView.bounds.size.width-30)/2, 220);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 10, 40, 10);
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
    NSDictionary *dic=[mainArrayData objectAtIndex:indexPath.row];
    if ([[dic objectForKey:@"composeType"]integerValue]==1) {
        TableViewStyleVC *vc=[[TableViewStyleVC alloc]initWithDictionary:[mainArrayData objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        CollectionStyleVC *vc=[[CollectionStyleVC alloc]initWithDictionary:[mainArrayData objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (mainArrayData) {
        [mainArrayData removeAllObjects];
    }
    
    fileManager=[NSFileManager defaultManager];
    NSString *libraryPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savingData=[libraryPath stringByAppendingPathComponent:@"SavingData"];
    BOOL isDirectory=NO;
    NSString *showImageView=[savingData stringByAppendingPathComponent:@"showImageView.plist"];
    NSString *categoryData=[savingData stringByAppendingPathComponent:@"categoryData.plist"];
    if ([fileManager fileExistsAtPath:showImageView isDirectory:&isDirectory]) {
        showDic=[NSDictionary dictionaryWithContentsOfFile:showImageView];
    }
    if ([fileManager fileExistsAtPath:categoryData isDirectory:&isDirectory]) {
        getSavingData=[NSMutableArray arrayWithContentsOfFile:categoryData];
    }
    for (NSNumber *obj in [showDic objectForKey:@"YES"]) {
        [mainArrayData addObject:[getSavingData objectAtIndex:[obj integerValue]]];
    }
    [AcollectionView reloadData];
    [self.myCarousel reloadData];
    
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
        btnImage.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationYeWanBG"]];
    }
    else
    {
        self.view.backgroundColor=[UIColor colorWithRed:222.0 green:226.0 blue:212.0 alpha:1.0];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationYellowBG"] forBarMetrics:UIBarMetricsDefault];
        btnImage.backgroundColor=[UIColor colorWithRed:222.0 green:226.0 blue:212.0 alpha:1.0];
    }
}

@end
