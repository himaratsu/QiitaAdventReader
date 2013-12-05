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
@property (nonatomic) NSMutableDictionary *cntThemeDict;    // title -> count

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
        
        // set popular calendar to current theme
        self.currentTheme = _themeList[0];
    }
    return self;
}

- (void)setCurrentTheme:(NSDictionary *)currentTheme {
    _currentTheme = currentTheme;
    
    // count
    [self addCount:currentTheme];
}

- (void)addCount:(NSDictionary *)theme {
    NSString *cnt = self.cntThemeDict[theme[@"title"]];
    _cntThemeDict[theme[@"title"]] = [NSString stringWithFormat:@"%d", [cnt intValue] + 1];
    
    // sort by select count
    self.themeList = [_themeList sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary* obj2) {
        NSInteger count1 = [_cntThemeDict[obj1[@"title"]] integerValue];
        NSInteger count2 = [_cntThemeDict[obj2[@"title"]] integerValue];
        
        if (count1 > count2) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        else if (count1 < count2) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    // save count theme dict
    [self saveCntThemeDict];

}



- (NSArray *)themeList {
    return [_themeList copy];
}


#pragma mark - Theme Count Storage

- (NSMutableDictionary *)cntThemeDict {
    if (_cntThemeDict == nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *loadData = [defaults objectForKey:@"CntThemeDict"];
        if (loadData != nil) {
            _cntThemeDict = [NSKeyedUnarchiver unarchiveObjectWithData:loadData];
        }
        else {
            // initialize
            _cntThemeDict = [NSMutableDictionary dictionary];
            [_themeList enumerateObjectsUsingBlock:^(NSDictionary *theme, NSUInteger idx, BOOL *stop) {
                [_cntThemeDict setObject:@"0" forKey:theme[@"title"]];
            }];
        }
    }
    
    return _cntThemeDict;
}

- (void)saveCntThemeDict {
    NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:_cntThemeDict];
    [[NSUserDefaults standardUserDefaults] setObject:saveData forKey:@"CntThemeDict"];
}

@end
