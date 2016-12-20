//
//  WordInfo.m
//  EnglishWord
//
//  Created by Li Emck on 12-03-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WordInfo.h"

@implementation WordInfo

-(Boolean )InitData:(MysqlRow *)Row
{
    if (Row.Count <=0) return false;
    if (Row.Datas == NULL) return false;
    
//    NSNumberFormatter *numberFormat = [NSNumberFormatter alloc];
    if (Row.Lengths[0]>0)
        ID = [[NSString stringWithUTF8String:Row.Datas[0]] integerValue];
    if (Row.Lengths[1]>0)
        Word = [NSString stringWithUTF8String:Row.Datas[1]];
    if (Row.Lengths[2]>0)
        Status = [[NSString stringWithUTF8String:Row.Datas[2]] integerValue];
    if (Row.Lengths[3]>0)
        Pron = [NSString stringWithUTF8String:Row.Datas[3]];
    if (Row.Lengths[4]>0)
        Chinese = [NSString stringWithUTF8String:Row.Datas[4]];
    if (Row.Lengths[5]>0)
        Example = [NSString stringWithUTF8String:Row.Datas[5]];
    if (Row.Lengths[6]>0)
        Memo = [NSString stringWithUTF8String:Row.Datas[6]];
    if (Row.Lengths[7]>0)
        Type = [NSString stringWithUTF8String:Row.Datas[7]];
    if (Row.Lengths[8]>0)
        Voice = [[ NSData alloc ] initWithBytes: Row.Datas[8] length: Row.Lengths[8]];
    return true;
}

-(long )ID
{
    return ID;
}

-(NSString *)Word
{
    return Word;
}

-(NSString *)Pron
{
    return Pron;
}

-(long )Status
{
    return Status;
}

-(NSString *)Chinese
{
    return Chinese;
}

-(NSString *)Example
{
    return Example;
}

-(NSString *)Memo
{
    return Memo;
}

-(NSString *)Type
{
    return Type;
}

-(NSData *)Voice
{
    return Voice;
}

@end
