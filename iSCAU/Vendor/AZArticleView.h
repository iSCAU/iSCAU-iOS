//
//  AZArticleView.h
//  iSCAU
//
//  Created by Alvin on 1/13/14.
//
//

#import <UIKit/UIKit.h>
#import "Notice.h"

@protocol ArticleViewDelegate <NSObject>
@optional
- (void)backgroundScrollViewBeginScroll:(UIScrollView *)scrollView;
- (void)backgroundScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)shouldPullToNextArticle;
- (void)shouldPullToLastArticle;
- (void)shouldBrowseImage:(NSString *)url;
- (void)shouldOpenWeb:(NSString *)url;
@end

@interface AZArticleView : UIView <UIScrollViewDelegate, UIWebViewDelegate>

@property (nonatomic, assign) id<ArticleViewDelegate> delegate;
@property (nonatomic, retain) UIScrollView *backgroundScrollView;

- (void)setupWithNotice:(Notice *)notice;
- (void)scrollToTop;

@end
