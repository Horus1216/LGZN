//
//  showWebView.h
//  ALG
//
//  Created by Horus on 16/9/10.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatKeyBoardView.h"

@interface showWebView : UIViewController<UIWebViewDelegate,UITextFieldDelegate,ChatKeyBoardViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property(nonatomic,retain) NSString *htmlString;
@property(nonatomic,retain) NSString *Atitle;
@property(nonatomic) NSInteger articleID;
@property(nonatomic) NSString *imageUrl;

-(instancetype)initWithNSString:(NSString *)htmlString title:(NSString *)title articleID:(NSInteger)articleID ImageUrl:(NSString *)imageUrl;

@end
