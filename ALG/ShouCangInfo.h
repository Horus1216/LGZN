//
//  ShouCangInfo.h
//  ALG
//
//  Created by Horus on 16/9/12.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShouCangInfo : NSObject<NSCoding>

@property(nonatomic,retain) NSString *htmlString;
@property(nonatomic,retain) NSString *Atitle;
@property(nonatomic) NSInteger articleID;
@property(nonatomic) BOOL isShouCang;
@property(nonatomic) NSString *imageUrl;

@end
