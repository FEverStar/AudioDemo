//
//  VVAudioPlayerViewController.m
//  vvim
//
//  Created by gaoxiaowei on 16/3/11.
//  Copyright © 2016年 51vv. All rights reserved.
//

#import "MusicPlayingController.h"
#import "AudioPlayer.h"
#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)
#define urlString @"http://cdn.y.baidu.com/yinyueren/029d2f150643972c8d470453dea717b1.mp3"
@interface MusicPlayingController ()<AudioPlayerDelegate>

@property(nonatomic,strong)AudioPlayer *audioPlayer;
@property (nonatomic, strong) UIButton *starOrPauseBtn;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *playtime_label;
@property (nonatomic, strong) UISlider *sliderTime;

@end

@implementation MusicPlayingController

+(MusicPlayingController*)shareController
{
    static MusicPlayingController *playingcontroller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playingcontroller = [MusicPlayingController new];
    });
    return playingcontroller;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadControls];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startPlay];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[AudioPlayer sharePlayer] pause];
    [_starOrPauseBtn setTitle:@"播放" forState:UIControlStateNormal];
}

- (void)loadControls {

    _audioPlayer = [AudioPlayer sharePlayer];
    _imgView = [[UIImageView alloc]init];
    [self.view addSubview:_imgView];
    _imgView.image = [UIImage imageNamed:@"梁朝伟"];
    _imgView.frame = CGRectMake(0, 0, 200, 200);
    _imgView.center = CGPointMake(SCREEN_WIDTH / 2, 200);
    _imgView.layer.cornerRadius = 100;
    _imgView.layer.masksToBounds = YES;
    
    _sliderTime = [[UISlider alloc]init];
    [self.sliderTime addTarget:self action:@selector(timeOfSlider:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_sliderTime];
    _sliderTime.frame = CGRectMake(50, 450, 300, 20);
    _sliderTime.center = CGPointMake(SCREEN_WIDTH / 2, 350);

    _playtime_label = [[UILabel alloc]init];
    _playtime_label.text = @"播放时间";
    _playtime_label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_playtime_label];
    _playtime_label.frame = CGRectMake(0, 0, 100, 30);
    _playtime_label.textAlignment = NSTextAlignmentCenter;
    _playtime_label.center = CGPointMake(SCREEN_WIDTH / 2, 400);


    
    _starOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_starOrPauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [_starOrPauseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_starOrPauseBtn addTarget:self action:@selector(starOrpause:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_starOrPauseBtn];
    _starOrPauseBtn.frame = CGRectMake(0, 0, 50, 50);
    _starOrPauseBtn.center = CGPointMake(SCREEN_WIDTH / 2, 450);

}

//时间条滑动事件
-(void)timeOfSlider:(UISlider*)sender
{
    [[AudioPlayer sharePlayer]seekToTime:sender.value];
}

-(void)startPlay
{
    [self updateUI];
    
    [_audioPlayer setPrepareMusicUrl:urlString];
    _audioPlayer.delegate = self;

}
- (void)starOrpause:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([AudioPlayer sharePlayer].isPlaying) {
        [[AudioPlayer sharePlayer] pause];
        [btn setTitle:@"播放" forState:UIControlStateNormal];
    }
    else
    {
        [[AudioPlayer sharePlayer] play];
        [btn setTitle:@"暂停" forState:UIControlStateNormal];
    }
}
-(void)updateUI{
    _imgView.transform = CGAffineTransformMakeRotation(0);
}

- (void)audioplayerDidFinishItem:(AudioPlayer *)audioplayer{
}
-(void)audioplayerPlayWith:(AudioPlayer *)audioplayer Progress:(float)progress
{
    NSLog(@"%f",progress);
    _imgView.transform = CGAffineTransformRotate(_imgView.transform, M_PI/100);
    //更新时间
    //已经播放时间
    int minutes = (int)progress/60;
    int seconds = (int)progress %60;

    
    if (seconds < 10) {
        _playtime_label.text = [NSString stringWithFormat:@"%d:0%d",minutes, seconds];
    }else{
        _playtime_label.text = [NSString stringWithFormat:@"%d:%d",minutes, seconds];
    }
    
    //更新进度条
//    _sliderTime.value = progress;
}

@end
