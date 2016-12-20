//
//  ViewController.h
//  EnglishWord
//
//  Created by Li Emck on 12-03-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MysqlDB.h"
#import "WordInfo.h"

@interface ViewController : NSViewController
{
    NSSpeechSynthesizer *Speech;                        // Speeh同步对象
    NSTimer *TimeIntervalPlay;                          // 定时器 主定时器,用于播放检测
    MysqlDB *Mysql;                                     // 用于数据操作的基础类
    //NSSound *currentSound;
    NSMutableArray *WordsInfo;                          // 保存所有单词信息
    NSMutableArray *PlayIndex;                          // 保存播放列表顺序
    int CurrentFlag;                                    // 播放列表标记
    long CurrentID;                                      // 当前播放的单词数据库ID
    int WaitNextFlag;                                   // 等待下一个单词播放标记
    long iWordPlayReps;                                  // 一个单词的播放循环次数
    bool isPause;                                       // 是否暂停状态
    
    IBOutlet NSTextField *textStatusStatus;             // 状态栏: 当前状态
    IBOutlet NSTextField *textStatusIndex;              // 状态栏: 当前正在播放第几个
    IBOutlet NSTextField *textStatusCount;              // 状态栏: 此次获取到要播放的单词个数
    IBOutlet NSTextField *textStatusTotal;              // 状态栏: 
    IBOutlet NSTextField *textWord;                     // 当前播放的单词(大字体)
    IBOutlet NSTextField *textWord2;                    // 当前播放的单词(小字体)
    IBOutlet NSTextField *textPron;                     // 当前播放的单词音标
    IBOutlet NSTextView  *textChinese;                  // 当前播放的单词中文说明
    IBOutlet NSTextView  *textExample;                  // 当前播放的单词举例
    
    IBOutlet NSTextField *ButtonInterval;               // 设置 单词播放间隔
    IBOutlet NSPopUpButton *ButtonWordReps;             // 设置 单词循环次数
    IBOutlet NSTextField *textFieldBegin;               // 设置 单词开始ID(数据库ID)
    IBOutlet NSTextField *textFieldEnd;                 // 设置 单词结束ID(数据库ID)
    IBOutlet NSButton *ButtonRandom;                    // 设置 是否随机从检索结果中播放
    IBOutlet NSButton *ButtonRepeat;                    // 设置 是否循环播放所有单词
    IBOutlet NSTextField *textWaitSpeech;               // 设置 播放前暂停时间


    IBOutlet NSButton *ButtonStart;                     // 按钮 开始播放任务
    IBOutlet NSButton *ButtonPause;                     // 按钮 暂停播放任务
    IBOutlet NSButton *ButtonRePlayOne;                 // 按钮 重复播放当前单词
    IBOutlet NSButton *ButtonStop;                      // 按钮 停止播放任务
}

- (void)initWindowData;                                 // 初始化数据
- (bool)getWordsFromDataBase;                           // 从数据库获取单词数据
- (void)initPlayIndex;                                  // 初始化播放索引(可设定随机索引)

- (IBAction)buttonStartClick:(id)sender;                // 事件 点击开始播放
- (IBAction)buttonPauseClick:(id)sender;                // 事件 点击暂停播放
- (IBAction)buttonRePlayOneClick:(id)sender;            // 事件 点击重复播放当前单词
- (IBAction)buttonStopClick:(id)sender;                 // 事件 点击停止播放

-(void)CheckPlaying:(NSTimer *)timer;                   // 定时器事件 播放检测,主任务定时器
-(void)UnitInterva:(NSTimer *)timer;                    // 定时器事件 用于处理一个单词多次循环播放后的处理
-(void)WordInterval:(NSTimer *)timer;                   // 定时器事件 用于处理每次单词播放后的处理
-(void)FirstUnitInterval:(NSTimer *)timer;              // 定时器事件 用于处理播放前暂停时间

@end
