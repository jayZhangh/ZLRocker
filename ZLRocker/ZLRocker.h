//
//  ZLRocker.h
//  ZMRockerDemo
//
//  Created by ZhangLiang on 15/9/13.
//  Copyright (c) 2015年 com.zmodo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RockStyle)
{
    RockStyleOpaque = 0,
    RockStyleTranslucent
};

typedef NS_ENUM(NSInteger, RockDirection)
{
    RockDirectionLeft = 0,
    RockDirectionUp,
    RockDirectionRight,
    RockDirectionDown,
    RockDirectionCenter,
};

@protocol ZLRockerDelegate;

@interface ZLRocker : UIView

@property (weak ,nonatomic) id <ZLRockerDelegate> delegate;
@property (nonatomic, readonly) RockDirection direction;

- (void)setRockerStyle:(RockStyle)style;

@end

@protocol ZLRockerDelegate <NSObject>

@optional
- (void)rockerDidChangeDirection:(ZLRocker *)rocker;

@end
