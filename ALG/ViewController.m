//
//  ViewController.m
//  ALG
//
//  Created by Horus on 16/9/6.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIImageView *viewAnimation;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    viewAnimation=[[UIImageView alloc]initWithFrame:self.view.bounds];
    viewAnimation.image=[UIImage imageNamed:@"appstart"];
    [self.view addSubview:viewAnimation];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [UIView beginAnimations:@"startAnimation" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startAnimationEnd)];
    viewAnimation.transform=CGAffineTransformMakeScale(1.5, 1.5);
    viewAnimation.alpha=0.0;
    [UIView commitAnimations];
    
}

-(void)startAnimationEnd
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startAnimationEnd" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
