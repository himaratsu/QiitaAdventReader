//
//  QARSimpleWebViewController.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/05.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARSimpleWebViewController.h"

@interface QARSimpleWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation QARSimpleWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:_loadFilePath]];
    [_webView loadRequest:req];
}


@end
