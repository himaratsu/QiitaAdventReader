//
//  QARWebViewController.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/04.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARWebViewController.h"
#import <NJKWebViewProgress.h>
#import <BlocksKit.h>
#import <PocketAPI.h>
#import <SVProgressHUD.h>

@interface QARWebViewController ()
<UIWebViewDelegate, NJKWebViewProgressDelegate>
{
    NJKWebViewProgress *_progressProxy;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

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
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"アクションを選択してください"];
//    
//    NSURL *currentPageURL = _webView.request.URL;
//    
//    [sheet addButtonWithTitle:@"Safariで開く" handler:^{
//        [[UIApplication sharedApplication] openURL:currentPageURL];
//    }];
//    [sheet addButtonWithTitle:@"Pocketに追加" handler:^{
//        [SVProgressHUD show];
//        [[PocketAPI sharedAPI] saveURL:currentPageURL
//                               handler: ^(PocketAPI *API, NSURL *URL, NSError *error){
//                                   if(error){
//                                       // there was an issue connecting to Pocket
//                                       // present some UI to notify if necessary
//                                       [SVProgressHUD showErrorWithStatus:@"Failed"];
//                                   }else{
//                                       // the URL was saved successfully
//                                       [SVProgressHUD showSuccessWithStatus:@"Success"];
//                                   }
//                               }];
//    }];
//    [sheet setCancelButtonIndex:[sheet addButtonWithTitle:@"Cancel"]];
//    [sheet showInView:self.view];
}

- (IBAction)refreshBtnTouched:(id)sender {
    [_webView reload];
}




@end
