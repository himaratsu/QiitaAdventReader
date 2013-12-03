//
//  QARWebViewController.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/04.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARWebViewController.h"

@interface QARWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation QARWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]];
    [_webView loadRequest:req];
}


@end
