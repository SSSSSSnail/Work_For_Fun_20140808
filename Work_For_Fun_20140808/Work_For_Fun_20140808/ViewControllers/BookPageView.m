//
//  BookPageView.m
//  Work_For_Fun_20140808
//
//  Created by Snail on 31/8/14.
//  Copyright (c) 2014 Snail. All rights reserved.
//

#import "BookPageView.h"

@interface BookContentView() {
    CGPDFPageRef pdfPage;
}

@end

@implementation BookContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];

		CATiledLayer *tiledLayer = (CATiledLayer *) [self layer];
		tiledLayer.frame = CGRectMake(0, 0, 100, 100);
		[tiledLayer setTileSize:CGSizeMake(1024, 1024)];
		[tiledLayer setLevelsOfDetail:4];
		[tiledLayer setLevelsOfDetailBias:4];
    }

    return self;
}

+ (Class)layerClass
{
	return [CATiledLayer class];
}

- (void)setKeyword:(NSString *)str
{
    _keyword = str;
	self.selections = nil;
}

- (NSArray *)selections
{
	@synchronized (self) {
		if (!_selections) {
			self.selections = [self.scanner select:self.keyword];
		}
		return _selections;
	}
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
	CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
	CGContextFillRect(ctx, layer.bounds);

	CGContextTranslateCTM(ctx, 0.0, layer.bounds.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);

	int rotationAngle = CGPDFPageGetRotationAngle(pdfPage);
	CGAffineTransform transform = CGPDFPageGetDrawingTransform(pdfPage, kCGPDFCropBox, layer.bounds, -rotationAngle, YES);
	CGContextConcatCTM(ctx, transform);

	CGContextDrawPDFPage(ctx, pdfPage);

	if (self.keyword)
    {
        CGContextSetFillColorWithColor(ctx, [[UIColor yellowColor] CGColor]);
        CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
        for (Selection *s in self.selections)
        {
            CGContextSaveGState(ctx);
            CGContextConcatCTM(ctx, s.transform);
            CGContextFillRect(ctx, s.frame);
            CGContextRestoreGState(ctx);
        }
    }
}

/* Draw the PDFPage to the content view */
- (void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();

	CGContextSetFillColorWithColor(ctx, [[UIColor redColor] CGColor]);
	CGContextFillRect(ctx, rect);
}

/* Sets the current PDFPage object */
- (void)setPage:(CGPDFPageRef)page
{
    CGPDFPageRelease(pdfPage);
	pdfPage = CGPDFPageRetain(page);
	self.scanner = [Scanner scannerWithPage:pdfPage];
}

@end

@interface BookPageView()<UIScrollViewDelegate>

@property (strong, nonatomic) BookContentView *contentView;

@end

@implementation BookPageView

- (void)awakeFromNib
{
    self.contentSize = CGSizeMake(ScreenBoundsWidth(), ScreenBoundsHeight() - 20);
    
    self.contentView = [BookContentView new];
    _contentView.frame = CGRectMake(0, 0, ScreenBoundsWidth(), ScreenBoundsHeight() - 20);
    [self addSubview:_contentView];

    self.delegate = self;

    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
    _doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:_doubleTap];
}

/* Double tap zooms the content to fill the container view */
- (void)didDoubleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.zoomScale == 1.0) {
        [self setZoomScale:2.0 animated:YES];
    } else {
        [self setZoomScale:1.0 animated:YES];
    }

}
//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//	// Set minimum zoom scale to where the content fits the screen
//	CGFloat hScale = CGRectGetWidth(self.frame) / CGRectGetWidth(_contentView.bounds);
//	CGFloat vScale = CGRectGetHeight(self.frame) / CGRectGetHeight(_contentView.bounds);
//	[self setMinimumZoomScale:MIN(hScale, vScale)];
//}

#pragma mark - UIScrollView delegate

/* Zoom the content view when user pinches the scroll view */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _contentView;
}

/* Make the content view center on screen when zoomed out */
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView
//{
//    NSLog(@"%s", __FUNCTION__);
//	CGRect frame = self.contentView.frame;
//    frame.origin = CGPointZero;
//	// Calculate how much of the content view is outside the screen
//	CGSize totalInset = CGSizeMake(CGRectGetWidth(_contentView.frame) - CGRectGetWidth(self.bounds),
//								   CGRectGetHeight(_contentView.frame) - CGRectGetHeight(self.bounds));
//	if (totalInset.width < 0)
//	{
//		frame.origin.x = - totalInset.width / 2;
//	}
//	if (totalInset.height < 0)
//	{
//		frame.origin.y = - totalInset.height / 2;
//	}
//	self.contentView.frame = frame;
//    [_contentView setNeedsDisplay];
//}

- (void)setPage:(CGPDFPageRef)page
{
    [_contentView setPage:page];
    [_contentView setNeedsDisplay];
}

- (void)setKeyword:(NSString *)string
{
    _contentView.keyword = string;
}

- (NSString *)keyword
{
    return _contentView.keyword;
}

@end
