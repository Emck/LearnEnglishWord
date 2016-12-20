//
//  ViewController.m
//  EnglishWord
//
//  Created by Li Emck on 12-03-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)initWindowData
{
    // currentSound = [NSSound alloc];
    Speech = [[NSSpeechSynthesizer alloc] init]; //start with default voice
    //[Speech setVoice:@"com.apple.speech.synthesis.voice.ting-ting.premium"];
    //[Speech startSpeakingString:@"测试"];
    [Speech setVoice:@"com.apple.speech.synthesis.voice.Alex"];
    [Speech setVolume:2.0];
    
    Mysql = [[MysqlDB alloc] init];
    if ([Mysql Connect:@"localhost" connectUser:@"root" connectPassword:@"" connectName:@"english"] == true) {     // 连接数据库失败...
        [Mysql Query:@"select count(id) as counts from words where status=1"];
        NSMutableArray *row = [Mysql FetchRow];
        [textStatusTotal setTitleWithMnemonic:[row objectAtIndex:0]];
        [Mysql Disconnect];
        Mysql = NULL;
    }
}

- (void)initPlayIndex
{
    // 生成顺序的播放索引...
    PlayIndex = [[NSMutableArray alloc] init];
    for (int i=0; i<[WordsInfo count]; i++) {
        [PlayIndex addObject: [NSNumber numberWithInt:i]];
    }
    // 判断是否需要随机...
    if ([ButtonRandom state] == true) {           // 如果是随机播放则打乱顺序...
        for(int i = 0; i<[PlayIndex count]; i++) {
            int m = (arc4random() % ([PlayIndex count] - i)) + i;
            [PlayIndex exchangeObjectAtIndex:i withObjectAtIndex: m];
        }   
    }
}

-(void)UnitInterva:(NSTimer *)timer;
{
    WaitNextFlag = 0;
}

-(void)WordInterval:(NSTimer *)timer
{
    WaitNextFlag = 4;
}

-(void)FirstUnitInterval:(NSTimer *)timer
{
    WaitNextFlag = 4;
}

-(void)CheckPlaying:(NSTimer *)timer
{
    if (isPause == true || [Speech isSpeaking] == YES) {  // 如果当前是暂停状态或正在播放语音,则跳出等待下一次触发检查
        return;
    }

    switch(WaitNextFlag) {
        case 5: return;
        case 4: {
            if (iWordPlayReps <=0) {
                WaitNextFlag = 1;
                return;
            }
            [Speech startSpeakingString:[textWord stringValue]];
            iWordPlayReps--;
            WaitNextFlag = 3;  // 标识已开启等待单还未完成
            return;
        }
        case 3: {
            [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(WordInterval:) userInfo:nil repeats:NO];
            return;
        }
        case 2: {
            WaitNextFlag = 5;  // 标识已开启等待单还未完成
            if ([[textWaitSpeech stringValue] doubleValue] >0)
                [NSTimer scheduledTimerWithTimeInterval:[[textWaitSpeech stringValue] doubleValue] target:self selector:@selector(FirstUnitInterval:) userInfo:nil repeats:NO];
            else
                WaitNextFlag = 4;
            return;
        }
        case 1: { // 准备开启等待状态
            WaitNextFlag = 5;  // 标识已开启等待单还未完成
            [NSTimer scheduledTimerWithTimeInterval:[[ButtonInterval stringValue] integerValue] target:self selector:@selector(UnitInterva:) userInfo:nil repeats:NO];
            return;
        }
        case 0: { // 等待已完成,立刻播放下一条
            // 判断是否播放到最后一个
            if (CurrentFlag >= [WordsInfo count]) {             // 已播放到最后一个则..
                if ([ButtonRepeat state] == true) {             // 如果是循环播放则...
                    CurrentFlag = 0;
                    [self initPlayIndex];                       // 初始化播放列表(顺序播放或随机播放)
                }
                else {
                    [self buttonStopClick:0];                   // 停止触发器
                    // 提示已经播放完毕
                }
                return;
            }
            // NSLog(@"%d",CurrentID);

            WordInfo *wordInfo = [WordsInfo objectAtIndex:[[PlayIndex objectAtIndex:CurrentFlag] intValue]];
            
            if ([wordInfo Word] != NULL && [wordInfo Chinese] != NULL) {
                CurrentID = [wordInfo ID];
                [textWord setTitleWithMnemonic:[wordInfo Word]];
                [textWord2 setTitleWithMnemonic:[wordInfo Word]];
                [textPron setTitleWithMnemonic:[NSString stringWithFormat:@"[%@]",[wordInfo Pron]]];
                [textChinese setString:[wordInfo Chinese]];
                
                if ([wordInfo Example] == NULL)
                    [textExample setString:@""];
                else
                    [textExample setString:[wordInfo Example]];
                //        if ([wordInfo Voice] != NULL)
                //        {
                //            [currentSound initWithData:[wordInfo Voice]];
                //            if ([currentSound isPlaying] == NO) [currentSound play];
                //            else [currentSound stop];
                //        }
                [textStatusStatus setTitleWithMnemonic:[NSString stringWithFormat:@"Play ID: %ld",CurrentID]];
                [textStatusIndex setTitleWithMnemonic:[NSString stringWithFormat:@"%d",CurrentFlag + 1]];
                WaitNextFlag = 2;  // 标示准备接受等待
                iWordPlayReps = [[[ButtonWordReps selectedItem] title] integerValue]; // 每个单词重复朗读次数
            }
            CurrentFlag++;
            return;
        }
    }
}

- (bool)getWordsFromDataBase
{
    Mysql = [[MysqlDB alloc] init];
    if ([Mysql Connect:@"localhost" connectUser:@"root" connectPassword:@"" connectName:@"english"] == false) {     // 连接数据库失败...
        return false;
    }
    
    // 获取此次要循环播放的单词列表(仅id和words)
    NSString *Sql;
    NSMutableArray *Words = [[NSMutableArray alloc] init];
    Sql = [NSString stringWithFormat:@"select id,word from words where id>=%@ and id <=%@ and status=1 order by id",[textFieldBegin stringValue],[textFieldEnd stringValue]];
    //Sql = [NSString stringWithFormat:@"select id,word from words where id=35 and status=1 order by id"];
    [Mysql Query:Sql];
    NSMutableArray *result = [Mysql FetchAllRows];
    NSMutableArray *row;
    if ([result count] <=0) {
        return false;
    }
    for(int i = 0; i < [result count]; i++) {
        row = [result objectAtIndex:i];
        [Words addObject:[row objectAtIndex:1]];
    }
    
    // 获取此次要循环播放的所有单词详细数据
    WordsInfo = [[NSMutableArray alloc] init];
    MysqlRow *Row;
    for (int i=0; i<[Words count]; i++) {
        Sql = [NSString stringWithFormat:@"select * from words where word='%@'",[Words objectAtIndex:i]];
        [Mysql Query:Sql];
        
        Row = [Mysql getRow];
        WordInfo *wordInfo = [WordInfo alloc];
        [wordInfo InitData:Row];
        [WordsInfo addObject:wordInfo];
        //    NSMutableArray *result = [Mysql FetchAllRows];
        //    for(int i = 0; i < [result count]; i++)
        //    {
        //        //NSMutableArray *row = [result objectAtIndex:i];
        //        NSMutableArray *row = [[NSMutableArray alloc] initWithArray:[result objectAtIndex:i]];
        //        NSLog(@"\n%d:\n\t host:%@ \n\t user:%@",(i+1),[row objectAtIndex:0],[row objectAtIndex:2]);
        //    }
        
        //    NSLog(@"host:%@  user:%@",[row objectAtIndex:0],[row objectAtIndex:1]);        
        
        //    NSMutableArray *row = [Mysql FetchRow];
        //    NSLog(@"host:%@  user:%@",[row objectAtIndex:0],[row objectAtIndex:1]);
    }
    [Mysql Disconnect];
    return true;
}

- (IBAction)buttonStartClick:(id)pId;
{
    textChinese.font = [NSFont fontWithName:@"Arial" size:30];
    textExample.font = [NSFont fontWithName:@"Arial" size:18];
    [self initWindowData];
    
    if ([self getWordsFromDataBase] == false) {
        // 提示未获取到单词列表
        return;
    }
    [ButtonStart setEnabled:false];
    [ButtonPause setEnabled:true];
    [ButtonRePlayOne setEnabled:false];
    [ButtonStop setEnabled:true];
    
    [textStatusCount setTitleWithMnemonic:[[NSNumber numberWithLong:[WordsInfo count]] stringValue]];
//    NSTableColumn *column = [NSTableColumn alloc];
//    [tableViewWords addTableColumn:column];

    // 初始化播放列表(顺序播放或随机播放)
    [self initPlayIndex];

    // 后续操作交给定时器来完成....
    isPause = false;
    WaitNextFlag = 0;
    CurrentFlag = 0;
    // 初始化定时器
    TimeIntervalPlay = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(CheckPlaying:) userInfo:nil repeats:YES];
    [textStatusStatus setTitleWithMnemonic:@"Start..."];
}

- (IBAction)buttonPauseClick:(id)sender
{
    if (isPause == true) {
        isPause = false;
        [ButtonPause setTitle:@"Pause"];
        [textStatusStatus setTitleWithMnemonic:[NSString stringWithFormat:@"Continue by ID: %ld",CurrentID]];
        [ButtonRePlayOne setEnabled:false];
    }
    else {
        isPause = true;
        [ButtonPause setTitle:@"Continue"];
        [textStatusStatus setTitleWithMnemonic:[NSString stringWithFormat:@"Pause by ID: %ld",CurrentID]];
        [ButtonRePlayOne setEnabled:true];
    }
    
}

- (IBAction)buttonRePlayOneClick:(id)sender
{
    [Speech startSpeakingString:[textWord stringValue]];
}

- (IBAction)buttonStopClick:(id)pId;
{
//    [currentSound stop];
    [Speech stopSpeaking];
    if (TimeIntervalPlay != NULL) {
        [TimeIntervalPlay invalidate];  // 关闭定时器
        TimeIntervalPlay = NULL;
    }
    [ButtonStart setEnabled:true];
    [ButtonPause setEnabled:false];
    isPause = false;
    [ButtonPause setTitle:@"Pause"];
    [ButtonRePlayOne setEnabled:false];
    [ButtonStop setEnabled:false];
    [textStatusStatus setTitleWithMnemonic:@"Stop..."];
}

@end
