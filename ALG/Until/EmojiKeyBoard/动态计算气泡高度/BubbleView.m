//
//  BubbleView.m
//  YDEmoji
//
//  Created by Mr Qian on 16/4/10.
//  Copyright © 2016年 Mr Qian. All rights reserved.
//

#import "BubbleView.h"

@implementation BubbleView

#define BEGIN_FLAG @"[em"   //表情前置标记
#define END_FLAG @"]"       //表情后置标记
#define CHATFONT [UIFont systemFontOfSize:15] //字体大小
#define KFacialSizeWidth  24 //表情符宽度
#define KFacialSizeHeight 24 //表情符高度

//气泡单例
+ (BubbleView*)bubble {
    static BubbleView *g_bubble = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       g_bubble = [[BubbleView alloc] init];
    });
    return g_bubble;
}

//根据文本内容和指定宽，高动态计算文本高度，返回一个子视图气泡
- (UIView*)bubbleText:(NSString*)text width:(CGFloat)w {
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, w)];
    NSMutableArray *msgArray = [NSMutableArray array];
    [self getImageRange:text array:msgArray];//图文(文本、表情)混排
    
    int maxWidth = w-35;//设置最大宽度
    
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat width = 0;
    CGFloat height = KFacialSizeHeight;
    CGFloat H = KFacialSizeHeight;
    if (msgArray && [msgArray count])
    {
        for (int i = 0; i < [msgArray count]; i++)
        {
            NSString *str = [msgArray objectAtIndex:i];
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                if (upX > maxWidth)
                {
                    upY = upY+H;
                    width = upX;
                    height = upY+H;
                    upX = 0;
                }
                
                //[em_18]
                NSRange rg = [str rangeOfString:@"_"];
                NSString *tmp = [str substringFromIndex:rg.location+1];
                NSString *strIndex = [tmp substringWithRange:NSMakeRange(0, tmp.length-1)];//表情所索
                NSString *imgPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"face.bundle/%@@2x.png", strIndex]];
                UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
                UIImageView *img=[[UIImageView alloc] initWithImage:image];
                img.userInteractionEnabled = NO;
                img.backgroundColor = [UIColor clearColor];
                img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [returnView addSubview:img];
                
                upX = upX+KFacialSizeWidth;
                if (width < maxWidth)
                {
                    width = upX;
                }
            }
            else
            {
                for (int j = 0; j < [str length]; j++)
                {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX > maxWidth)
                    {
                        upY = upY+H;
                        width = upX;
                        height = upY+H;
                        upX = 0;
                    }
                    
                    // 计算文本的高度
                    NSDictionary *attribute = @{NSFontAttributeName:CHATFONT};
                    CGSize size = [temp boundingRectWithSize:CGSizeMake(w, 100) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
                    
                    H = H > size.height ? H : size.height;
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,H)];
                    la.font = CHATFONT;
                    la.text = temp;
                    la.textAlignment = NSTextAlignmentLeft;
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    
                    upX = upX+size.width;
                    if (width < maxWidth)
                    {
                        width = upX;
                    }
                }
            }
        }
    }
    
    returnView.frame = CGRectMake(0, 0, width, height);
    returnView.backgroundColor = [UIColor clearColor];
    
    return returnView;
}

/**
 功能:图文(文本、表情)混排
 参数:消息字符串 当前消息数组
 返回值:无
 */
- (void)getImageRange:(NSString*)message array:(NSMutableArray*)array
{
    NSRange range = [message rangeOfString:BEGIN_FLAG];
    NSRange range1 = [message rangeOfString:END_FLAG];
    
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0)
    {
        if (range.location > 0)
        {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str array:array];
        }
        else
        {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字后是“”的字符串
            if (![nextstr isEqualToString:@""])
            {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str array:array];
            }
            else
            {
                return;
            }
        }
    }
    else if (message != nil)
    {
        [array addObject:message];
        return;
    }
}

@end
