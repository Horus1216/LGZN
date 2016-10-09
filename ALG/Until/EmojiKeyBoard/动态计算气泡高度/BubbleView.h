//
//  BubbleView.h
//  YDEmoji
//
//  Created by Mr Qian on 16/4/10.
//  Copyright © 2016年 Mr Qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BubbleView : NSObject

//气泡单例
+ (BubbleView*)bubble;

//根据文本内容和指定宽，高动态计算文本高度，返回一个子视图气泡
- (UIView*)bubbleText:(NSString*)text width:(CGFloat)w;

@end
