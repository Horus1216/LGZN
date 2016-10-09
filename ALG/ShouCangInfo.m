//
//  ShouCangInfo.m
//  ALG
//
//  Created by Horus on 16/9/12.
//  Copyright © 2016年 Horus. All rights reserved.
//

#import "ShouCangInfo.h"

@implementation ShouCangInfo

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]){
        self.articleID = [aDecoder decodeIntegerForKey:@"articleID"];
        self.Atitle = [aDecoder decodeObjectForKey:@"Atitle"];
        self.htmlString = [aDecoder decodeObjectForKey:@"htmlString"];
        self.isShouCang = [aDecoder decodeBoolForKey:@"isShouCang"];
        self.imageUrl=[aDecoder decodeObjectForKey:@"imageUrl"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.articleID forKey:@"articleID"];
    [aCoder encodeObject:self.Atitle forKey:@"Atitle"];
    [aCoder encodeObject:self.htmlString forKey:@"htmlString"];
    [aCoder encodeBool:self.isShouCang forKey:@"isShouCang"];
    [aCoder encodeObject:self.imageUrl forKey:@"imageUrl"];
}

@end
