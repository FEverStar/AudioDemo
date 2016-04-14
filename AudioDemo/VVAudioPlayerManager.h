//
//  VVAudioPlayerManager.h
//  vvim
//
//  Created by gaoxiaowei on 16/3/11.
//  Copyright © 2016年 51vv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFSoundManager.h"

extern NSString * const VVAudioPlayNotifyStatus;

enum  VVAudioPlayerStatus{
    VVAudioPlayerStatus_Idle=0,
    VVAudioPlayerStatus_Playing,
    VVAudioPlayerStatus_Pause,
    VVAudioPlayerStatus_Finished,
};

@protocol VVAudioPlayerManagerDelegate <NSObject>
@optional
-(void) OnAudioPlayChange:(NSInteger)duration timePlayed:(NSInteger)timePlayed;

@end

@interface VVAudioPlayerManager : NSObject
{

}
@property (nonatomic, strong) AFSoundPlayback *playback;
@property (nonatomic, strong) AFSoundQueue *queue;
@property(weak,nonatomic)id<VVAudioPlayerManagerDelegate> delegate;

@property (nonatomic,copy,readonly) NSString* streamUrl;//url
@property (nonatomic,copy,readonly) NSString * picUrl;//图片url
@property (nonatomic,copy,readonly) NSString * audioTitle;//标题
@property (nonatomic,copy,readonly) NSString * h5Url;//h5 url

@property (nonatomic,assign,readonly) enum VVAudioPlayerStatus playStatus;//当前播放状态
@property (nonatomic,readonly) NSInteger duration;//播放总时长
@property (nonatomic,readonly) NSInteger timePlayed;//已播放时长
@property (nonatomic,assign) BOOL isinterruption;//是否被外部中断暂停

+(instancetype)shared;
-(BOOL)play:(NSString*)streamUrl;
-(BOOL)play:(NSString*)streamUrl withPicUrl:(NSString*)picUrl withAudioTitle:(NSString*)audioTitle withH5Url:(NSString*)h5Url;
-(void)pause;
-(void)resume;
-(BOOL)isPlayed;
@end
