//
//  ChatEmojiIcons.m
//  joinup_iphone
//
//  Created by shen_gh on 15/8/4.
//  copyRight (c) 2015年 com.joinup(Beijing). All rights reserved.
//

#import "ChatEmojiIcons.h"

@implementation ChatEmojiIcons

//获取表情包
+ (NSArray *)emojis {
    static NSArray *_emojis;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获取表情plist
        NSString *emojiFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Emoji.plist"];
        NSDictionary *emojiDic = [[NSDictionary alloc] initWithContentsOfFile:emojiFilePath];
        NSArray *allKeys = emojiDic.allKeys;
        NSMutableArray *array=[NSMutableArray array];
        for (NSString *key in allKeys) {
            [array addObject:[emojiDic valueForKey:key]];
        }
        _emojis = array;
    });
    return _emojis;
}

+(NSInteger)getEmojiPopCount{
    return [[self class] emojis].count;
}

+ (NSString *)getEmojiNameByTag:(NSInteger)tag {
    NSArray *emojis = [[self class] emojis];
    return emojis[tag];
}

+(NSString *)getEmojiPopIMGNameByTag:(NSInteger)tag{
    NSString * name = [[self class]getEmojiNameByTag:tag];
    return [[self class]imgNameWithName:name];
}

+ (NSString *)getEmojiPopNameByTag:(NSInteger)tag {
    NSString *key = [NSString stringWithFormat:@"%@", [self getEmojiNameByTag:tag]];
    return NSLocalizedString(key, @"");
}

+(NSString *)imgNameWithName:(NSString*)name{
    return [NSString stringWithFormat:@"%@",name];
}

@end
