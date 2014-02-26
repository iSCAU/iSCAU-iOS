//
//  AZArticleView.m
//  iSCAU
//
//  Created by Alvin on 1/13/14.
//
//

#import "AZArticleView.h"
#import "UIWebView+Addition.h"

#define kHeaderImageHeight      200

#define upInset            10.0f
#define bottomInset        10.0f
#define triggeredOffset    100.0f
#define haloImageWidth     12.0f
#define noticeLabelInset   25.f
#define noticeLabelHeight  16.0f
#define yOffsetRate  0.5

@interface AZArticleView () {
    BOOL    loadingMore;
    BOOL    animating;
    BOOL    headerRefreshPulling;
    BOOL    footerRefreshPulling;
    BOOL    transforming;

    UIImageView             *animationImageView;
}

@property (nonatomic, retain) UIImageView *headerImageView;
@property (nonatomic, retain) UIWebView   *articleWebView;
@property (nonatomic, retain) UIImageView *headerHaloImageView;
@property (nonatomic, retain) UILabel     *labHeaderNotice;
@property (nonatomic, retain) UIImageView *footerHaloImageView;
@property (nonatomic, retain) UILabel     *labFooterNotice;
@property (nonatomic, retain) UIWebView   *sharedWebView;

@end

@implementation AZArticleView

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"articleWebView.scrollView.contentSize"]) {
        [self resetContentSize];
    }
}

- (void)resetContentSize {
    CGFloat height = self.articleWebView.scrollView.contentSize.height;
    CGRect frame = self.articleWebView.frame;
    frame.size.height = height;
    self.articleWebView.frame = frame;
    
    [self.backgroundScrollView setContentSize:CGSizeMake(0, height + kHeaderImageHeight)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        headerRefreshPulling = NO;
        footerRefreshPulling = NO;
        
        // Header image
        UIImageView *headerImage = [[UIImageView alloc] initWithFrame:(CGRect) {
            CGPointZero,
            self.width,
            kHeaderImageHeight
        }]; 
        self.headerImageView = headerImage;
        self.headerImageView.backgroundColor = [UIColor clearColor];
        self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImageView.clipsToBounds = YES;
        [self addSubview:self.headerImageView];
        
        // Backgrond scrollview
        UIScrollView *backgroundScroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.backgroundScrollView = backgroundScroll;
        self.backgroundScrollView.delegate = self;
        self.backgroundScrollView.backgroundColor = [UIColor clearColor];
        self.backgroundScrollView.scrollsToTop = YES;
        self.backgroundScrollView.scrollEnabled = YES;
        [self addSubview:self.backgroundScrollView];
        
        // Article webview
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.bounds];
        self.articleWebView = webView;
        [self setupWebView];
        [self.backgroundScrollView addSubview:self.articleWebView];
        
        [self setupHeaderImageView];
        
        [self addObserver:self forKeyPath:@"articleWebView.scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

#pragma mark - Public methods

- (void)setupWithURL:(NSString *)url {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
//    // Header image
//    NSString *placeHolderImageName = IS_NIGHT_MODE ? @"blankpic_wenzhang_dark.png" : @"blankpic_wenzhang.png";
//    if (![article.firstImageLink isEqualToString:@"null"]) {
//        CGRect frame = self.headerImageView.frame;
//        frame.origin = CGPointZero;
//        self.headerImageView.frame = frame;
//        
//        [self.headerImageView setImageWithURL:[NSURL URLWithString:article.firstImageLink] placeholderImage:[UIImage imageNamed:placeHolderImageName]];
//    } else {
//        [self.headerImageView setImage:[UIImage imageNamed:placeHolderImageName]];
//    }
    self.headerImageView.image = [UIImage imageNamed:@""];
    
    // ArticleWebView
    self.backgroundScrollView.frame = self.bounds;
    CGRect frame = self.backgroundScrollView.frame;
    frame.origin.y = kHeaderImageHeight;
    frame.size.height -= kHeaderImageHeight;
    self.articleWebView.frame = frame;
    [self.articleWebView loadHTMLString:@"" baseURL:nil];
    
    // Background content size
    [self resetContentSize];
    self.backgroundScrollView.contentOffset = CGPointZero;
}

- (void)clearArticleWebView {
    [self.articleWebView loadHTMLString:@"" baseURL:[NSURL URLWithString:@"about:blank"]];
}

- (UIImage *)headImage {
    return self.headerImageView.image;
}

#pragma mark - Private methods

- (CGFloat)getImageScale {
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat expectWidth = 440.f;
    CGFloat scale = ((expectWidth * screenScale) / (screenWidth * screenScale));
    return scale;
}

- (void)setupWebView {
    CGRect frame = self.backgroundScrollView.frame;
    frame.origin.y = kHeaderImageHeight;
    frame.size.height -= kHeaderImageHeight;
    self.articleWebView.frame = frame;
    self.articleWebView.scrollView.scrollEnabled = NO;
    self.articleWebView.scrollView.scrollsToTop = NO;
    self.articleWebView.opaque = NO;
    self.articleWebView.delegate = self;
    ((UIScrollView *)[[self.articleWebView subviews] objectAtIndex:0]).delegate = self;
    
    // 清除webview背景阴影
    [self.articleWebView setTransparent:YES];
}


- (void)setupHeaderImageView {
    CGRect frame = self.headerImageView.frame;
    frame.size.height = kHeaderImageHeight;
    self.headerImageView.frame = frame;
}

- (void)clearHalo {
    if (self.labHeaderNotice != nil)
        [self.labHeaderNotice removeFromSuperview];
    if (self.headerHaloImageView != nil)
        [self.headerHaloImageView removeFromSuperview];
    if (self.labFooterNotice != nil)
        [self.labFooterNotice removeFromSuperview];
    if (self.footerHaloImageView != nil)
        [self.footerHaloImageView removeFromSuperview];
}

#pragma mark- uiwebview delegate Method

- (void)scrollToTop {
    self.backgroundScrollView.scrollsToTop = !self.backgroundScrollView.scrollsToTop;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self resetContentSize];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self resetContentSize];
}

#pragma mark- UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self hiddenShareView];
    if ([self.delegate respondsToSelector:@selector(backgroundScrollViewBeginScroll:)]) {
        [self.delegate backgroundScrollViewBeginScroll:scrollView];
    }
    
    CGSize webViewContentSize = CGSizeMake(0, self.articleWebView.scrollView.contentSize.height + kHeaderImageHeight);
    if (!CGSizeEqualToSize(scrollView.contentSize, webViewContentSize)) {
        scrollView.contentSize = webViewContentSize;
    }
    self.footerHaloImageView.hidden = NO;
    self.labFooterNotice.hidden = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.backgroundScrollView]) {
        // 动态调整滚动条位置
        if (scrollView.contentOffset.y < kHeaderImageHeight) {
            CGFloat temp = kHeaderImageHeight - scrollView.contentOffset.y;
            UIEdgeInsets insets = UIEdgeInsetsMake(temp, 0, 0, 0);
            scrollView.scrollIndicatorInsets = insets;
        }
        if (scrollView.contentOffset.y < kHeaderImageHeight * 2 && scrollView.contentOffset.y > 0) {
            CGRect frame = self.headerImageView.frame;
            frame.origin.y = -scrollView.contentOffset.y * yOffsetRate;
            self.headerImageView.frame = frame;
        }
        if (scrollView.contentOffset.y <= 0) {
            CGRect frame = self.headerImageView.frame;
            frame.origin.y = -scrollView.contentOffset.y;
            self.headerImageView.frame = frame;
        }

        // 下拉
        if (scrollView.contentOffset.y < 0) {
            if (scrollView.contentOffset.y < - noticeLabelInset - noticeLabelHeight - haloImageWidth) {
                CGRect frame = self.headerHaloImageView.frame;
                frame.origin.y = (scrollView.contentOffset.y + noticeLabelInset + noticeLabelHeight + haloImageWidth) / 2 + (- noticeLabelInset - haloImageWidth - upInset);
                self.headerHaloImageView.frame = frame;
                
                frame = self.labHeaderNotice.frame;
                frame.origin.y = (scrollView.contentOffset.y  + noticeLabelHeight + noticeLabelInset + haloImageWidth) / 2 + (- noticeLabelHeight - upInset);
                self.labHeaderNotice.frame = frame;
                
            } else if (scrollView.contentOffset.y < -upInset) {
                CGRect frame = self.headerHaloImageView.frame;
                frame.origin.y = -upInset - haloImageWidth - noticeLabelInset;
                self.headerHaloImageView.frame = frame;
                
                frame = self.labHeaderNotice.frame;
                frame.origin.y = - upInset - noticeLabelHeight;
                self.labHeaderNotice.frame = frame;
            }
            if (NO) {
                return;
            } else {
                if (scrollView.isDragging) {
                    if (scrollView.contentOffset.y < -triggeredOffset - upInset) {
                        if (headerRefreshPulling == NO) {
                            headerRefreshPulling = YES;
                            CGAffineTransform transform = CGAffineTransformRotate(self.headerHaloImageView.transform,  M_PI);
                            [UIView animateWithDuration:0.2f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 [self.headerHaloImageView setTransform:transform];
                                             }
                             ];
                        }
                    } else {
                        if (headerRefreshPulling == YES) {
                            headerRefreshPulling = NO;
                            CGAffineTransform transform = CGAffineTransformRotate(self.headerHaloImageView.transform,  M_PI);
                            [UIView animateWithDuration:0.2
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 [self.headerHaloImageView setTransform:transform];
                                             }
                             ];
                        }
                    }
                }
            }
            // 上拉
        } else if (!transforming) {
            if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.height + noticeLabelInset + noticeLabelHeight + haloImageWidth) {
                CGRect frame = self.footerHaloImageView.frame;
                frame.origin.y = (scrollView.contentOffset.y - scrollView.contentSize.height + scrollView.height - noticeLabelInset - haloImageWidth - noticeLabelHeight) / 2 + bottomInset + noticeLabelInset + scrollView.contentSize.height;
                self.footerHaloImageView.frame = frame;
                
                frame = self.labFooterNotice.frame;
                frame.origin.y = (scrollView.contentOffset.y - scrollView.contentSize.height + scrollView.height - noticeLabelInset - haloImageWidth - noticeLabelHeight) / 2 + bottomInset + scrollView.contentSize.height;
                self.labFooterNotice.frame = frame;
            } else if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.height + bottomInset) {
                CGRect frame = self.footerHaloImageView.frame;
                frame.origin.y = scrollView.contentSize.height + bottomInset + noticeLabelInset;
                self.footerHaloImageView.frame = frame;
                
                frame = self.labFooterNotice.frame;
                frame.origin.y = scrollView.contentSize.height + bottomInset;
                self.labFooterNotice.frame = frame;
            }
            
            if (animating == YES) {
                return;
            } else {
                if (scrollView.isDragging) {
                    if (scrollView.contentOffset.y > scrollView.contentSize.height + triggeredOffset + bottomInset - scrollView.height) {
                        if (footerRefreshPulling == NO) {
                            footerRefreshPulling = YES;
                            CGAffineTransform transform = CGAffineTransformRotate(self.footerHaloImageView.transform,  M_PI);
                            [UIView animateWithDuration:0.2f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 [self.footerHaloImageView setTransform:transform];
                                             }
                             ];
                        }
                    } else {
                        if (footerRefreshPulling == YES) {
                            footerRefreshPulling = NO;
                            CGAffineTransform transform = CGAffineTransformRotate(self.footerHaloImageView.transform,  M_PI);
                            [UIView animateWithDuration:0.2
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 [self.footerHaloImageView setTransform:transform];
                                             }
                             ];
                        }
                    }
                }
            }
        }
    }
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (scrollView.contentOffset.y < -triggeredOffset - upInset && APP_DELEGATE.selectedIndex != 0) {
//        [scrollView setContentOffset:scrollView.contentOffset];
//        [UIView animateWithDuration:1 animations:^{
//            [scrollView setContentOffset:CGPointZero];
//            CGRect frame = self.headerImageView.frame;
//            frame.origin = CGPointZero;
//            self.headerImageView.frame = frame;
//        }];
//        if ([self.delegate respondsToSelector:@selector(shouldPullToLastArticle)]) {
//            [self.delegate shouldPullToLastArticle];
//        }
//    } else if (scrollView.contentOffset.y > scrollView.contentSize.height + triggeredOffset + bottomInset - scrollView.height && APP_DELEGATE.selectedIndex < APP_DELEGATE.articles.count - 1) {
//        [UIView animateWithDuration:1 animations:^{
//            [scrollView setContentOffset:CGPointZero];
//        }];
//        [UIView animateWithDuration:0.1f animations:^{
//            self.footerHaloImageView.alpha = 0.f;
//            self.labFooterNotice.alpha = 0.f;
//        }];
//        if ([self.delegate respondsToSelector:@selector(shouldPullToNextArticle)]) {
//            [self.delegate shouldPullToNextArticle];
//        }
//    }
//}

#pragma mark- UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ([touch.view isKindOfClass:[UIButton class]]) ? NO : YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
