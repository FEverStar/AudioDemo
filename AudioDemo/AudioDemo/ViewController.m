//
//  ViewController.m
//  AudioDemo
//
//  Created by L on 16/3/12.
//  Copyright © 2016年 L. All rights reserved.
//

#import "ViewController.h"
#import "MusicPlayingController.h"

@interface ViewController ()
@property (nonatomic, strong)UIButton *button;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(100, 100, 100, 100);
    [_button setTitle:@"点我" forState:UIControlStateNormal];
    _button.backgroundColor = [UIColor redColor];
    [self.view addSubview:_button];
    [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick{
    MusicPlayingController *vc = [[MusicPlayingController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
