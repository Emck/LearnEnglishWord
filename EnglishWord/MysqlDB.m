//
//  MysqlDB.m
//  EnglishWord
//
//  Created by Li Emck on 12-03-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MysqlDB.h"

@implementation MysqlDB

-(id)init
{
    return self;
}

-(BOOL)Connect:(NSString *)host connectUser:(NSString *)user connectPassword:(NSString *)password connectName:(NSString *)name
{
    MysqlConnect = mysql_init(MysqlConnect);
    if (MysqlConnect == NULL) return false;
    MysqlConnect = mysql_real_connect(MysqlConnect,[host UTF8String],[user UTF8String],[password UTF8String],[name UTF8String],MYSQL_PORT,NULL,0);
    if (MysqlConnect == NULL) return false;    
    mysql_set_character_set(MysqlConnect, "utf8");
    return true;
}

-(void)Disconnect
{
    mysql_close(MysqlConnect);
}

-(int)Query:(NSString *)Sql
{
    int flg = mysql_query(MysqlConnect, [Sql UTF8String]);
    Result = mysql_store_result(MysqlConnect);
    return flg;
}

-(MysqlRow *) getRow
{
    MYSQL_ROW mrow;
    int fieldCount = mysql_field_count(MysqlConnect);
    if ((mrow = mysql_fetch_row(Result)))
    {
        MysqlRow *Row = [MysqlRow alloc];
        [Row setCount:fieldCount];
        [Row setDatas:mrow];
        [Row setLength:mysql_fetch_lengths(Result)];
        return Row;
    }
    else
        return NULL;
}

-(NSMutableArray *)FetchRow
{
    MYSQL_ROW row;
    NSMutableArray *rowArray = [[NSMutableArray alloc] init];
    int fieldCount = mysql_field_count(MysqlConnect);
    if ((row = mysql_fetch_row(Result)))
    {
        for(int i = 0; i < fieldCount; i++)
        {
            if (row[i] == NULL)
                [rowArray addObject:[NSNull null]];                
            else
                [rowArray addObject:[NSString stringWithUTF8String:row[i]]];
        }
    }
    row = NULL;
    return rowArray;
}

//    NSMutableArray *row = [Mysql FetchRow];
//    NSLog(@"host:%@  user:%@",[row objectAtIndex:0],[row objectAtIndex:1]);


-(NSMutableArray *)FetchRowString
{
    MYSQL_ROW row;
    NSMutableArray *rowArray = [[NSMutableArray alloc] init];
    int fieldCount = mysql_field_count(MysqlConnect);
    if ((row = mysql_fetch_row(Result)))
    {
        for(int i = 0; i < fieldCount; i++)
        {
            [rowArray addObject:[NSString stringWithUTF8String:row[i]]];
        }
    }
    row = NULL;
    return rowArray;
}

-(NSMutableArray *)FetchAllRows
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    long rowCount = mysql_num_rows(Result);
    for(long i = 0; i < rowCount; i++)
    {
        [resultArray addObject:[self FetchRowString]];
    }
    return resultArray;
}

@end
