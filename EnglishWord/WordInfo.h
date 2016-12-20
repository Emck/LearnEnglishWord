//
//  WordInfo.h
//  EnglishWord
//
//  Created by Li Emck on 12-03-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MysqlRow.h"

@interface WordInfo : NSObject
{
    long ID;
    NSString *Word;
    long Status;
    NSString *Pron;
    NSString *Chinese;
    NSString *Example;
    NSString *Memo;
    NSString *Type;
    NSData *Voice;
}

-(long )ID;
-(NSString *)Word;
-(NSString *)Pron;
-(long )Status;
-(NSString *)Chinese;
-(NSString *)Example;
-(NSString *)Memo;
-(NSString *)Type;
-(NSData *)Voice;

-(Boolean )InitData:(MysqlRow *)Row;

@end
