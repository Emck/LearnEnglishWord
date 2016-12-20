//
//  MysqlRow.h
//  EnglishWord
//
//  Created by Li Emck on 12-03-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <mysql.h>

@interface MysqlRow : NSObject {
    int Count;
    MYSQL_ROW Datas;
    unsigned long *Lengths;
}
//
-(int )Count;
-(void)setCount:(int )count;
-(MYSQL_ROW )Datas;
-(void)setDatas:(MYSQL_ROW )datas;
-(unsigned long *)Lengths;
-(void)setLength:(unsigned long *)lengths;

@end
