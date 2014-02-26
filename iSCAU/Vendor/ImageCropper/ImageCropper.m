//
//  ImageCropper.m
//  Created by http://github.com/iosdeveloper
//

#import "ImageCropper.h"
#import "AZSideMenuViewController.h"
#import "UIImage+Tint.h"

@implementation ImageCropper

@synthesize scrollView, imageView;
@synthesize delegate;

- (id)initWithImage:(UIImage *)image {
	self = [super init];
	
	if (self) {
        self.title = @"校历";
        
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg"]];
        self.view.backgroundColor = background;
        [background release];
        
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
                
        UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        if (IS_FLAT_UI) {
            btnClose.frame = CGRectMake(0, 0, 45, 44);
        } else {
            btnClose.frame = CGRectMake(0, 0, 55, 44);
            btnClose.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        }
        [btnClose setImage:[[UIImage imageNamed:@"BackButton.png"] imageWithTintColor:APP_DELEGATE.tintColor] forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(backToMenu) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *closeBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btnClose];
        self.navigationItem.leftBarButtonItem = closeBarBtn;
        
        CGFloat offsetY = IS_FLAT_UI ? 64 : 44;
		scrollView = [[UIScrollView alloc] initWithFrame:(CGRect) {
            CGPointZero,
            self.view.width,
            self.view.height - offsetY
        }];
		[scrollView setBackgroundColor:[UIColor clearColor]];
		[scrollView setDelegate:self];
		[scrollView setShowsHorizontalScrollIndicator:NO];
		[scrollView setShowsVerticalScrollIndicator:NO];
		[scrollView setMaximumZoomScale:1.5];
		
		imageView = [[UIImageView alloc] initWithImage:image];
		[imageView sizeToFit];
		
		[scrollView setContentSize:[imageView frame].size];
		[scrollView setMinimumZoomScale:[scrollView frame].size.width / [imageView frame].size.width];
		[scrollView setZoomScale:[scrollView minimumZoomScale]];
		[scrollView addSubview:imageView];
		
		[[self view] addSubview:scrollView];
	}
	
	return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return imageView;
}

- (void)backToMenu {
    [[AZSideMenuViewController shareMenu] openMenuAnimated];
}

- (void)dealloc {
	[imageView release];
	[scrollView release];
	
    [super dealloc];
}

@end