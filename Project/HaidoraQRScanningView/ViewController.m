//
//  ViewController.m
//  HaidoraQRScanningView
//
//  Created by DaiLingChi on 14-12-1.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import "ViewController.h"
#import "HDQRScanningView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet HDQRScanningView *test;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _test.marginEdgeInsets = UIEdgeInsetsMake(100, 50, 100, 50);
    // Do any additional setup after loading the view, typically from a nib.
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [_test startScanning];
//    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_test startScanning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_test stopScanning];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
