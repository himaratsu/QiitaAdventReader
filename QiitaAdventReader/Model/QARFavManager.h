//
//  QARFavManager.h
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/05.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QARFavManager : NSObject

+ (id)sharedManager;
- (BOOL)isFavEntry:(NSDictionary *)entry;
- (void)favEntry:(NSDictionary *)entry;
- (void)unFavEntry:(NSDictionary *)entry;
- (void)fetchEntry:(NSDictionary *)entry;

@end
