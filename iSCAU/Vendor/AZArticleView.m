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
@property (nonatomic, retain) UIWebView   *sharedWebView;

@end

@implementation AZArticleView

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
    }
    return self;
}

#pragma mark - Public methods

- (void)setupWithNotice:(Notice *)notice
{
    self.headerImageView.image = [UIImage imageNamed:@"notice_header_img.png"];
    
    // ArticleWebView
    self.backgroundScrollView.frame = self.bounds;
    CGRect frame = self.backgroundScrollView.frame;
    frame.origin.y = kHeaderImageHeight;
    frame.size.height -= kHeaderImageHeight;
    self.articleWebView.frame = frame;

    [self.articleWebView loadHTMLString:[self contentStr:notice] baseURL:nil];
    
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

- (NSString *)contentStr:(Notice *)notice
{
    NSString *content = [notice.content stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp;"];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    NSString *html = [NSString stringWithFormat:HTML_WRAPPER ,notice.title, notice.time, content];

    html = [NSString stringWithFormat:@"<html>%@<body>%@</body></html>", HTML_CSS, html];
    NSLog(@"html %@", html);
    
    return html;
}

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
    if ([self.delegate respondsToSelector:@selector(backgroundScrollViewBeginScroll:)]) {
        [self.delegate backgroundScrollViewBeginScroll:scrollView];
    }
    
    CGSize webViewContentSize = CGSizeMake(0, self.articleWebView.scrollView.contentSize.height + kHeaderImageHeight);
    if (!CGSizeEqualToSize(scrollView.contentSize, webViewContentSize)) {
        scrollView.contentSize = webViewContentSize;
    }

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
    }
}

#pragma mark- UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ([touch.view isKindOfClass:[UIButton class]]) ? NO : YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
