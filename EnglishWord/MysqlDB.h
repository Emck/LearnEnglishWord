//
//  MysqlDB.h
//  EnglishWord
//
//  Created by Li Emck on 12-03-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <mysql.h>
#import "MysqlRow.h"

@interface MysqlDB : NSObject {
    MYSQL *MysqlConnect;
    MYSQL_RES *Result;
}

// 连接mysql
-(BOOL )Connect:(NSString *)host connectUser:(NSString *)user connectPassword:(NSString *)password connectName:(NSString *)name;
// 执行query
-(int )Query:(NSString *)Sql;
// 返回结果
-(MysqlRow *) getRow;
// fetch结果集
-(NSMutableArray *)FetchRow;
-(NSMutableArray *)FetchRowString;
-(NSMutableArray *)FetchAllRows;
// 关闭连接
-(void)Disconnect;

@end
