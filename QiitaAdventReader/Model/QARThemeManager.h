//
//  QARThemeManager.h
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/04.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QARThemeManager : NSObject

+ (id)sharedManager;
- (NSArray *)themeList;

@property (nonatomic, strong) NSDictionary *currentTheme;

@end
