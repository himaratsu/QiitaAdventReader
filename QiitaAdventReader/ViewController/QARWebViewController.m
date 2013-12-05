//
//  QARWebViewController.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/04.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARWebViewController.h"

#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"

#import <Social/Social.h>
#import <NJKWebViewProgress.h>
#import <PocketAPI.h>
#import <SVProgressHUD.h>

@interface QARWebViewController ()
<UIWebViewDelegate, NJKWebViewProgressDelegate>
{
    NJKWebViewProgress *_progressProxy;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;


@end

@implementation QARWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // initial
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    _toolBar.hidden = !_isShowToolBar;
    
    // start request
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]];
    [_webView loadRequest:req];
}

#pragma mark - UIWebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    _backButton.enabled = [_webView canGoBack];
    _nextButton.enabled = [_webView canGoForward];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

}


#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    if (progress == 0.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        _progressView.progress = 0;
        [UIView animateWithDuration:0.27 animations:^{
            _progressView.alpha = 1.0;
        }];
    }
    if (progress == 1.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [UIView animateWithDuration:0.27 delay:progress - _progressView.progress options:0 animations:^{
            _progressView.alpha = 0.0;
        } completion:nil];
    }
    
    [_progressView setProgress:progress animated:NO];
}


#pragma mark - IBAction

- (IBAction)backBtnTouched:(id)sender {
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}

- (IBAction)nextBtnTouched:(id)sender {
    if ([_webView canGoForward]) {
        [_webView goForward];
    }
}

- (IBAction)actionBtnTouched:(id)sender {
    NSURL *currentPageURL = _webView.request.URL;
    
    // copy url
    RIButtonItem *copyUrlItem = [RIButtonItem itemWithLabel:@"URLをコピー" action:^{
        UIPasteboard *pastebd = [UIPasteboard generalPasteboard];
        [pastebd setValue:currentPageURL.absoluteString forPasteboardType: @"public.utf8-plain-text"];
    }];
    
    // open in safari
    RIButtonItem *safariItem = [RIButtonItem itemWithLabel:@"Safariで開く" action:^{
        [[UIApplication sharedApplication] openURL:currentPageURL];
    }];
    
    // add to pocket
    RIButtonItem *pocketItem = [RIButtonItem itemWithLabel:@"Pocketに追加する" action:^{
        [SVProgressHUD show];
        [[PocketAPI sharedAPI] saveURL:currentPageURL
                               handler: ^(PocketAPI *API, NSURL *URL, NSError *error){
                                   if(error){
                                       // failed
                                       [SVProgressHUD showErrorWithStatus:@"Failed"];
                                   }
                                   else{
                                       // success
                                       [SVProgressHUD showSuccessWithStatus:@"Success"];
                                   }
                               }];
    }];
    
    // share with twitter
    RIButtonItem *twitterItem = [RIButtonItem itemWithLabel:@"Twitterでシェア" action:^{
        [self postToTwitter:currentPageURL];

    }];
    
    // share with facebook
    RIButtonItem *facebookItem = [RIButtonItem itemWithLabel:@"Facebookでシェア" action:^{
        [self postToFacebook:currentPageURL];
    }];
    
    // cancel
    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"キャンセル"];
    
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"アクションを選択してください"
                                               cancelButtonItem:cancelItem
                                          destructiveButtonItem:nil
                                               otherButtonItems:copyUrlItem,
                            safariItem,
                            pocketItem,
                            twitterItem,
                            facebookItem, nil];
    [sheet showInView:self.view];
}

- (IBAction)refreshBtnTouched:(id)sender {
    [_webView reload];
}


#pragma mark - Post SNS

- (void)postToTwitter:(NSURL *)URL {
    SLComposeViewController *vc = [SLComposeViewController
                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
    [vc setInitialText:[NSString stringWithFormat:@"%@ %@", self.title, @"via Q-Advent Calendar"]];
    [vc addURL:URL];
    [vc setCompletionHandler:^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultDone) {
            // post success
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Post Failed"
                                        message:@"エラーが発生しました。\nお手数ですが再度お試しください"
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil]
             show];
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)postToFacebook:(NSURL *)URL {
    SLComposeViewController *vc = [SLComposeViewController
                                   composeViewControllerForServiceType:SLServiceTypeFacebook];
    [vc setInitialText:[NSString stringWithFormat:@"%@ %@", self.title, @"via Q-Advent Calendar"]];
    [vc addURL:URL];
    [vc setCompletionHandler:^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultDone) {
            // post success
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Post Failed"
                                        message:@"エラーが発生しました。\nお手数ですが再度お試しください"
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@"OK", nil]
             show];
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - Getter / Setter

- (void)setIsShowToolBar:(BOOL)isShowToolBar {
    _isShowToolBar = isShowToolBar;
    _toolBar.hidden = !_isShowToolBar;
}

@end
