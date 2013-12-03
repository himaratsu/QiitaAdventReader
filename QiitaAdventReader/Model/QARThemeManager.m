//
//  QARThemeManager.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/04.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARThemeManager.h"

@interface QARThemeManager ()

@property (nonatomic) NSArray *themeList;

@end

@implementation QARThemeManager

+ (id)sharedManager {
    static QARThemeManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        // load plist data
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Theme" ofType:@"plist"];
        self.themeList = [NSArray arrayWithContentsOfFile:plistPath];
        
        // 一番上をcurrentにセット
        self.currentTheme = _themeList[0];
    }
    return self;
}

- (NSArray *)themeList {
    return [_themeList copy];
}

@end
