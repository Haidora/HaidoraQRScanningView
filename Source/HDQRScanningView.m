//
//  HDQRScanningView.m
//  HaidoraQRScanningView
//
//  Created by DaiLingChi on 14-12-1.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import "HDQRScanningView.h"
#import <ZXingObjC.h>

#pragma mark
#pragma mark HDQRScanView

@interface HDQRScanView : UIView

// edge
@property (nonatomic, assign) CGFloat edgeLineWidth;
@property (nonatomic, assign) CGFloat edgeLineLength;
@property (nonatomic, strong) UIColor *edgeLineColor;
@property (nonatomic, assign) UIEdgeInsets marginEdgeInsets;

// scanLine
@property (nonatomic, assign) CGFloat scanLineWidth;
@property (nonatomic, strong) UIColor *scanLineColor;

@property (nonatomic, weak) id<HDQRScanningViewDelegate> delegate;

@property (nonatomic, strong) UIView *scanningView;

@end

@implementation HDQRScanView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _edgeLineColor = [UIColor colorWithRed:0.192 green:0.796 blue:0.298 alpha:0.5];
    _edgeLineLength = 20;
    _edgeLineWidth = 4;
    _marginEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);

    _scanLineColor = _edgeLineColor;
    _scanLineWidth = _edgeLineWidth;

    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scanningView];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
//    CGContextFillRect(context, rect);

    CGFloat leftMargin = _marginEdgeInsets.left;
    CGFloat topMargin = _marginEdgeInsets.top;
    CGFloat rightMargin = _marginEdgeInsets.right;
    CGFloat bottomMargin = _marginEdgeInsets.bottom;
    // clearRect
    CGRect clearRect =
        CGRectMake(leftMargin + _edgeLineWidth, topMargin + _edgeLineWidth,
                   CGRectGetWidth(rect) - (leftMargin + rightMargin + _edgeLineWidth * 2),
                   CGRectGetHeight(rect) - (topMargin + bottomMargin + _edgeLineWidth * 2));
    CGContextClearRect(context, clearRect);

    CGContextSaveGState(context);

    CGContextSetStrokeColorWithColor(context, _edgeLineColor.CGColor);
    CGContextSetLineWidth(context, _edgeLineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);

    // topLeft
    CGContextMoveToPoint(context, leftMargin, topMargin + _edgeLineLength);
    CGContextAddLineToPoint(context, leftMargin, topMargin);
    CGContextAddLineToPoint(context, leftMargin + _edgeLineLength, topMargin);
    // topRight
    CGContextMoveToPoint(context, CGRectGetWidth(rect) - rightMargin - _edgeLineLength, topMargin);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect) - rightMargin, topMargin);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect) - rightMargin,
                            topMargin + _edgeLineLength);
    // bottomLeft
    CGContextMoveToPoint(context, leftMargin,
                         CGRectGetHeight(rect) - (bottomMargin + _edgeLineLength));
    CGContextAddLineToPoint(context, leftMargin, CGRectGetHeight(rect) - bottomMargin);
    CGContextAddLineToPoint(context, leftMargin + _edgeLineLength,
                            CGRectGetHeight(rect) - bottomMargin);
    // bottomRight
    CGContextMoveToPoint(context, CGRectGetWidth(rect) - rightMargin - _edgeLineLength,
                         CGRectGetHeight(rect) - bottomMargin);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect) - rightMargin,
                            CGRectGetHeight(rect) - bottomMargin);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect) - rightMargin,
                            CGRectGetHeight(rect) - (bottomMargin + _edgeLineLength));
    CGContextStrokePath(context);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.scanningView.frame;
    frame.size.width = CGRectGetWidth(self.bounds) - _marginEdgeInsets.left -
                       _marginEdgeInsets.right - _edgeLineLength * 2;
    self.scanningView.frame = frame;
    [self setNeedsDisplay];

    [self startScanningAnimation];
}

#pragma mark
#pragma mark Getter / Setter

- (UIView *)scanningView
{
    if (nil == _scanningView)
    {
        _scanningView = [[UIView alloc] init];
        _scanningView.backgroundColor = _scanLineColor;
    }
    return _scanningView;
}

- (void)setEdgeLineColor:(UIColor *)edgeLineColor
{
    _edgeLineColor = edgeLineColor;
    [self setNeedsDisplay];
}

- (void)setEdgeLineLength:(CGFloat)edgeLineLength
{
    _edgeLineLength = edgeLineLength;
    [self setNeedsLayout];
}

- (void)setEdgeLineWidth:(CGFloat)edgeLineWidth
{
    _edgeLineWidth = edgeLineWidth;
    [self setNeedsDisplay];
}

- (void)setMarginEdgeInsets:(UIEdgeInsets)marginEdgeInsets
{
    _marginEdgeInsets = marginEdgeInsets;
    [self setNeedsDisplay];
}

- (void)setScanLineColor:(UIColor *)scanLineColor
{
    _scanLineColor = scanLineColor;
    self.scanningView.backgroundColor = _scanLineColor;
}

- (void)setScanLineWidth:(CGFloat)scanLineWidth
{
    _scanLineWidth = scanLineWidth;
    CGRect frame = self.scanningView.frame;
    frame.size.height = _scanLineWidth;
    self.scanningView.frame = frame;
}

#pragma mark
#pragma mark Method

- (void)startScanningAnimation
{
    CGFloat leftMargin = _marginEdgeInsets.left;
    CGFloat topMargin = _marginEdgeInsets.top;
    CGFloat rightMargin = _marginEdgeInsets.right;
    CGFloat bottomMargin = _marginEdgeInsets.bottom;

    self.scanningView.frame = CGRectMake(
        leftMargin + _edgeLineLength, topMargin,
        CGRectGetWidth(self.bounds) - (rightMargin + _edgeLineLength) * 2, _scanLineWidth);
    CGRect animationRect = self.scanningView.frame;
    animationRect.origin.y = CGRectGetHeight(self.bounds) - bottomMargin - _scanLineWidth;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDuration:1.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatCount:FLT_MAX];
    [UIView setAnimationRepeatAutoreverses:YES];
    self.scanningView.hidden = NO;
    self.scanningView.frame = animationRect;
    [UIView commitAnimations];
}

- (void)stopScanningAnimation
{
}

@end

#pragma mark
#pragma mark HDQRScanningView

@interface HDQRScanningView () <ZXCaptureDelegate>

@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, strong) HDQRScanView *scanningView;

@end

@implementation HDQRScanningView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _edgeLineColor = [UIColor colorWithRed:0.192 green:0.796 blue:0.298 alpha:0.5];
    _edgeLineLength = 20;
    _edgeLineWidth = 3;
    _marginEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);

    _scanLineColor = _edgeLineColor;
    _scanLineWidth = _edgeLineWidth + 1;

    // capture
    _capture = [[ZXCapture alloc] init];
    _capture.camera = _capture.back;
    _capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    _capture.rotation = 90.0f;
    [self.layer addSublayer:self.capture.layer];

    // scanView
    _scanningView = [[HDQRScanView alloc] init];
    _scanningView.edgeLineColor = _edgeLineColor;
    _scanningView.edgeLineLength = _edgeLineLength;
    _scanningView.edgeLineWidth = _edgeLineWidth;
    _scanningView.scanLineColor = _scanLineColor;
    _scanningView.scanLineWidth = _scanLineWidth;
    [self addSubview:_scanningView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _scanningView.frame = self.bounds;

    _capture.layer.frame = self.bounds;
    _capture.scanRect =
        CGRectMake(_marginEdgeInsets.left, _marginEdgeInsets.top,
                   CGRectGetWidth(self.bounds) - _marginEdgeInsets.left - _marginEdgeInsets.right,
                   CGRectGetHeight(self.bounds) - _marginEdgeInsets.top - _marginEdgeInsets.bottom);
}
#pragma mark
#pragma mark Getter / Setter

- (void)setEdgeLineColor:(UIColor *)edgeLineColor
{
    _edgeLineColor = edgeLineColor;
    _scanningView.edgeLineColor = edgeLineColor;
}

- (void)setEdgeLineLength:(CGFloat)edgeLineLength
{
    _edgeLineLength = edgeLineLength;
    _scanningView.edgeLineLength = edgeLineLength;
}

- (void)setEdgeLineWidth:(CGFloat)edgeLineWidth
{
    _edgeLineWidth = edgeLineWidth;
    _scanningView.edgeLineWidth = edgeLineWidth;
}

- (void)setMarginEdgeInsets:(UIEdgeInsets)marginEdgeInsets
{
    _marginEdgeInsets = marginEdgeInsets;
    _scanningView.marginEdgeInsets = marginEdgeInsets;
    [self setNeedsLayout];
}

- (void)setScanLineColor:(UIColor *)scanLineColor
{
    _scanLineColor = scanLineColor;
    _scanningView.scanLineColor = scanLineColor;
}

- (void)setScanLineWidth:(CGFloat)scanLineWidth
{
    _scanLineWidth = scanLineWidth;
    _scanningView.scanLineWidth = scanLineWidth;
}

#pragma mark
#pragma mark Method

- (void)startScanning
{
    self.capture.delegate = self;
    //    [self.capture start];
    [self.scanningView startScanningAnimation];
}

- (void)stopScanning
{
    [self.capture stop];
    self.capture.delegate = nil;
}

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format
{
    switch (format)
    {
    case kBarcodeFormatAztec:
        return @"Aztec";

    case kBarcodeFormatCodabar:
        return @"CODABAR";

    case kBarcodeFormatCode39:
        return @"Code 39";

    case kBarcodeFormatCode93:
        return @"Code 93";

    case kBarcodeFormatCode128:
        return @"Code 128";

    case kBarcodeFormatDataMatrix:
        return @"Data Matrix";

    case kBarcodeFormatEan8:
        return @"EAN-8";

    case kBarcodeFormatEan13:
        return @"EAN-13";

    case kBarcodeFormatITF:
        return @"ITF";

    case kBarcodeFormatPDF417:
        return @"PDF417";

    case kBarcodeFormatQRCode:
        return @"QR Code";

    case kBarcodeFormatRSS14:
        return @"RSS 14";

    case kBarcodeFormatRSSExpanded:
        return @"RSS Expanded";

    case kBarcodeFormatUPCA:
        return @"UPCA";

    case kBarcodeFormatUPCE:
        return @"UPCE";

    case kBarcodeFormatUPCEANExtension:
        return @"UPC/EAN extension";

    default:
        return @"Unknown";
    }
}

#pragma mark
#pragma mark ZXCaptureDelegate

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result
{
    if (!result)
    {
        return;
    }
    AudioServicesPlaySystemSound(1109);
    NSString *formatString = [self barcodeFormatToString:result.barcodeFormat];
    NSString *display = [NSString
        stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@", formatString, result.text];
    NSLog(@"%@", display);
}

- (void)captureSize:(ZXCapture *)capture width:(NSNumber *)width height:(NSNumber *)height
{
}

- (void)captureCameraIsReady:(ZXCapture *)capture
{
}

@end
