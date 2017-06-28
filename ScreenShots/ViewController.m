//
//  ViewController.m
//  ScreenShots
//
//  Created by 王盛魁 on 2017/6/27.
//  Copyright © 2017年 WangShengKui. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 300, 30)];
    lbl.textColor = [UIColor redColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = @"测试位置1";
    [self.view addSubview:lbl];
    UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 300, 30)];
    lbl2.textColor = [UIColor redColor];
    lbl2.textAlignment = NSTextAlignmentCenter;
    lbl2.text = @"测试位置2";
    [self.view addSubview:lbl2];

    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"截取屏幕" style:UIBarButtonItemStylePlain target:self action:@selector(screenShotAction)];
    /*
     屏幕截图 通知
     点击屏幕快照事件
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureImage) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - 点击截取屏幕事件
- (void)screenShotAction{
    /*
     - (nullable UIView *)snapshotViewAfterScreenUpdates:(BOOL)afterUpdates;
     */
//    UIView *shotView = [self.view snapshotViewAfterScreenUpdates:NO];
//    UIView *shotView = [self.view snapshotViewAfterScreenUpdates:YES];
    /*
     - (nullable UIView *)resizableSnapshotViewFromRect:(CGRect)rect afterScreenUpdates:(BOOL)afterUpdates withCapInsets:(UIEdgeInsets)capInsets;
     */
    UIView *shotView = [self.view resizableSnapshotViewFromRect:CGRectMake(100, 100, 100, 300) afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    
    shotView.frame = CGRectMake(0, 300, 200, 200/shotView.frame.size.width * shotView.frame.size.height);
    shotView.layer.borderWidth = 0.5f;
    shotView.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:shotView];
}


#pragma mark - 屏幕快照事件
- (void)captureImage{
    NSLog(@"屏幕开始截图了");
    //人为截屏, 模拟用户截屏行为, 获取所截图片
    UIImage *image = [self imageWithScreenshot];
}

/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
- (UIImage *)imageWithScreenshot{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}
/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
- (NSData *)dataWithScreenshotInPNGFormat{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]){
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft){
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }else if (orientation == UIInterfaceOrientationLandscapeRight){
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }else{
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(image);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
