//
//  VVAudioPlayerManager.m
//  vvim
//
//  Created by gaoxiaowei on 16/3/11.
//  Copyright © 2016年 51vv. All rights reserved.
//

#import "VVAudioPlayerManager.h"

NSString * const VVAudioPlayNotifyStatus = @"OnAudioPlayStatus";

@implementation VVAudioPlayerManager

#pragma mark *** Common methods ***
+(instancetype)shared{
    static VVAudioPlayerManager * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instance = [[VVAudioPlayerManager alloc] init];
        [instance Init];
    });
    return instance;
}

-(void)Init
{
    _playStatus =VVAudioPlayerStatus_Idle;
    _streamUrl=@"";
    _picUrl=@"";
    _audioTitle=@"";
    _h5Url=@"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outputDeviceChanged:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
}
- (void)dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
   [self stop];
}

-(BOOL)play:(NSString*)streamUrl{
    if(streamUrl !=nil &&![streamUrl isEqualToString:@""]){
        _streamUrl=streamUrl;
        [self stop];
        NSURL *url=[[NSURL alloc]initWithString:_streamUrl];
        AFSoundItem *item =[[AFSoundItem alloc]initWithStreamingURL:url];
        NSMutableArray *items= [NSMutableArray arrayWithObjects:item, nil];
        _queue = [[AFSoundQueue alloc] initWithItems:items];
        [_queue playCurrentItem];
        _playStatus =VVAudioPlayerStatus_Playing;
        [self notifyAudioPlayStatus];
        [_queue listenFeedbackUpdatesWithBlock:^(AFSoundItem *item) {
            NSLog(@"VVAudioPlayerManager Item duration: %ld - time elapsed: %ld", (long)item.duration, (long)item.timePlayed);
            _duration =item.duration;
            _timePlayed =item.timePlayed;
            if (_delegate!=nil && [_delegate respondsToSelector:@selector(OnAudioPlayChange: timePlayed:)]) {
                [_delegate OnAudioPlayChange:item.duration timePlayed:item.timePlayed];
            }
            
        } andFinishedBlock:^(AFSoundItem *nextItem) {
            NSLog(@"VVAudioPlayerManager Finished item, next one is %@", nextItem.title);
            _playStatus =VVAudioPlayerStatus_Finished;
            if (_delegate!=nil && [_delegate respondsToSelector:@selector(OnAudioPlayChange: timePlayed:)]) {
                [_delegate OnAudioPlayChange:item.duration timePlayed:item.duration];
            }
            [self stop];
        }];
        return YES;
    }
    return NO;
}

-(BOOL)play:(NSString*)streamUrl withPicUrl:(NSString*)picUrl withAudioTitle:(NSString*)audioTitle withH5Url:(NSString*)h5Url;{
    if ([self play:streamUrl]) {
        _picUrl =picUrl;
        _audioTitle =audioTitle;
        _h5Url =h5Url;
        return YES;
    }
    
    return NO;
}
-(void)pause{
    if (_queue!=nil) {
        [_queue pause];
         _playStatus =VVAudioPlayerStatus_Pause;
        [self notifyAudioPlayStatus];
    }
}
-(void)resume{
    if (_queue!=nil) {
        [_queue playCurrentItem];
         _playStatus =VVAudioPlayerStatus_Playing;
        _isinterruption =NO;
        [self notifyAudioPlayStatus];
    }
    
}
-(void)stop{
    if (_queue!=nil) {
        [_queue clearQueue];
        _queue=nil;
        _playStatus =VVAudioPlayerStatus_Idle;
        [self notifyAudioPlayStatus];
    }
    
}
-(BOOL)isPlayed{
    if (_playStatus ==VVAudioPlayerStatus_Playing) {
        return YES;
    }
    return  NO;
}
-(void)notifyAudioPlayStatus{
    NSDictionary *notify_data = @{@"isPlayed":@([self isPlayed])};
    NSNotification * notification= [NSNotification notificationWithName:VVAudioPlayNotifyStatus object:notify_data];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
- (void)outputDeviceChanged:(NSNotification *)aNotification
{
    if (aNotification!=nil) {
        NSString *changeNotification=aNotification.name;
        if ([changeNotification isEqualToString:@"AVAudioSessionRouteChangeNotification"]) {
            int reason_value =[[aNotification.userInfo valueForKey:@"AVAudioSessionRouteChangeReasonKey"]intValue];
            NSLog(@"outputDeviceChanged:reason_value:%d",reason_value);
            if ((reason_value ==1 ||reason_value ==2) && [self isPlayed]) {
                if(CURRENT_IOS_VERISON <= 8){
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self resume];
                    });
                }
                else{
                     [self resume];
                }
    
                
            }
        }
        
    }

}

@end
