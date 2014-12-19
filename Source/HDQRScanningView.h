//
//  HDQRScanningView.h
//  HaidoraQRScanningView
//
//  Created by DaiLingChi on 14-12-1.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HDQRScanningViewDelegate;

@interface HDQRScanningView : UIView

// edge
@property (nonatomic, assign) CGFloat edgeLineWidth;
@property (nonatomic, assign) CGFloat edgeLineLength;
@property (nonatomic, strong) UIColor *edgeLineColor;
@property (nonatomic, assign) UIEdgeInsets marginEdgeInsets;

// scanLine
@property (nonatomic, assign) CGFloat scanLineWidth;
@property (nonatomic, strong) UIColor *scanLineColor;

@property (nonatomic, weak) id<HDQRScanningViewDelegate> delegate;

- (void)startScanning;
- (void)stopScanning;

@end
