//
//  ViewController.m
//  ZLRocker
//
//  Created by ZhangLiang on 15/9/14.
//  Copyright (c) 2015年 tent. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <ZLRockerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rocker.delegate = self;
}

- (void)rockerDidChangeDirection:(ZLRocker *)rocker
{
    NSLog(@"Direction : %ld",(long)rocker.direction);
    
    NSArray *directios = @[@"Left",@"Up",@"Right",@"Down",@"Center"];
    
    _label.text = directios[rocker.direction];
}

@end
