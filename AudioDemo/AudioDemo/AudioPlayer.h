//
//  AudioPlayer.h
//  MusicPlayer
//
//  Created by lanou3g on 15/9/15.
//  Copyright (c) 2015年 LYX. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AudioPlayer;

@protocol AudioPlayerDelegate <NSObject>

//再播放中每秒都执行的事件
- (void)audioplayerPlayWith:(AudioPlayer *)audioplayer Progress:(float)progress;

//当一首歌曲播放完成之后执行这个事件
- (void)audioplayerDidFinishItem:(AudioPlayer *)audioplayer;

@end


@interface AudioPlayer : NSObject


@property(nonatomic,assign)id<AudioPlayerDelegate>delegate;
@property(nonatomic,assign)BOOL isPlaying;
+(AudioPlayer*)sharePlayer;
-(void)play;
-(void)pause;
-(void)seekToTime:(float)time;
-(void)setPrepareMusicUrl:(NSString*)urlStr;



@end
