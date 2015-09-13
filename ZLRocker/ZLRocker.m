//
//  ZLRocker.m
//  ZMRockerDemo
//
//  Created by ZhangLiang on 15/9/13.
//  Copyright (c) 2015年 com.zmodo. All rights reserved.
//

#import "ZLRocker.h"

#define kRadius ([self bounds].size.width * 0.5f)
#define kTrackRadius kRadius * 0.7f    // 控制中心点偏移量

@interface ZLRocker ()
{
    CGFloat _x;
    CGFloat _y;
}

@property (strong, nonatomic) UIImageView *handleImageView;

@end

@implementation ZLRocker

- (void)awakeFromNib
{
    [self commonInit];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    [self setRockerStyle:RockStyleOpaque];
    
    _direction = RockDirectionCenter;
    
    if (!_handleImageView) {
        UIImage *handleImage = [UIImage imageNamed:@"setting_btn_yaogan_yellow"];
        
        _handleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width*0.5f-handleImage.size.width*0.5f,
                                                                         self.bounds.size.height*0.5f-handleImage.size.height*0.5f,
                                                                         50,
                                                                         50)];
        _handleImageView.image = handleImage;
        
        [self addSubview:_handleImageView];
    }
    
    _x = 0;
    _y = 0;
    
    [self resetHandle];
}

- (void)setRockerStyle:(RockStyle)style
{
    //    NSArray *imageNames = @[@"rockerOpaqueBg",@"rockerTranslucentBg"];
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[self scaleToSize:[UIImage imageNamed:@"setting_yaogan"] size:CGSizeMake(150, 150)]]];
}

- (void)resetHandle
{
    // _handleImageView.image = [UIImage imageNamed:@"setting_btn_yaogan_yellow"];
    
    _x = 0.0;
    _y = 0.0;
    
    CGRect handleImageFrame = [_handleImageView frame];
    handleImageFrame.origin = CGPointMake(([self bounds].size.width - [_handleImageView bounds].size.width) * 0.5f,
                                          ([self bounds].size.height - [_handleImageView bounds].size.height) * 0.5f);
    [_handleImageView setFrame:handleImageFrame];
}

- (void)setHandlePositionWithLocation:(CGPoint)location
{
    _x = location.x - kRadius;
    _y = -(location.y - kRadius);
    
    float r = sqrt(_x * _x + _y * _y);
    
    if (r >= kTrackRadius) {
        
        _x = kTrackRadius * (_x / r);
        _y = kTrackRadius * (_y / r);
        
        location.x = _x + kRadius;
        location.y = -_y + kRadius;
        
        [self rockerValueChanged];
    }
    
    CGRect handleImageFrame = [_handleImageView frame];
    handleImageFrame.origin = CGPointMake(location.x - ([_handleImageView bounds].size.width * 0.5f),
                                          location.y - ([_handleImageView bounds].size.width * 0.5f));
    [_handleImageView setFrame:handleImageFrame];
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _handleImageView.image = [UIImage imageNamed:@"setting_btn_yaogan_yellow"];
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    [self setHandlePositionWithLocation:location];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    
    [self setHandlePositionWithLocation:location];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resetHandle];
    
    [self rockerValueChanged];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resetHandle];
    
    [self rockerValueChanged];
}

- (void)rockerValueChanged
{
    NSInteger rockerDirection = -1;
    
    float arc = atan2f(_y,_x);
    
    if ((arc > (3.0f/4.0f)*M_PI &&  arc < M_PI) || (arc < -(3.0f/4.0f)*M_PI &&  arc > -M_PI)) {
        rockerDirection = RockDirectionLeft;
    }else if (arc > (1.0f/4.0f)*M_PI &&  arc < (3.0f/4.0f)*M_PI) {
        rockerDirection = RockDirectionUp;
    }else if ((arc > 0 &&  arc < (1.0f/4.0f)*M_PI) || (arc < 0 &&  arc > -(1.0f/4.0f)*M_PI)) {
        rockerDirection = RockDirectionRight;
    }else if (arc > -(3.0f/4.0f)*M_PI &&  arc < -(1.0f/4.0f)*M_PI) {
        rockerDirection = RockDirectionDown;
    }else if (0 == _x && 0 == _y)
    {
        rockerDirection = RockDirectionCenter;
    }
    
    if (-1 != rockerDirection && rockerDirection != _direction) {
        _direction = rockerDirection;
        
        if ([self.delegate respondsToSelector:@selector(rockerDidChangeDirection:)])
        {
            [self.delegate rockerDidChangeDirection:self];
        }
    }
}

@end
