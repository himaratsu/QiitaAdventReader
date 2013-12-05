//
//  QARFavManager.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/05.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARFavManager.h"

@interface QARFavManager ()

@property (nonatomic) NSMutableArray *favList;

@end

@implementation QARFavManager

+ (id)sharedManager {
    static QARFavManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.favList = [self loadFavList];
    }
    return self;
}

- (BOOL)isFavEntry:(NSDictionary *)entry {
    return [_favList containsObject:entry];
}

- (void)favEntry:(NSDictionary *)entry {
    [_favList addObject:entry];
    [self saveFavList];
}

- (void)unFavEntry:(NSDictionary *)entry {
    [_favList removeObject:entry];
    [self saveFavList];
}

- (void)fetchEntry:(NSDictionary *)entry {
    if ([self isFavEntry:entry]) {
        [self unFavEntry:entry];
    }
    else {
        [self favEntry:entry];
    }
}

- (NSMutableArray *)favList {
    return [_favList copy];
}



- (void)saveFavList {
    NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:_favList];
    [[NSUserDefaults standardUserDefaults] setObject:saveData forKey:@"favList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)loadFavList {
    NSData *loadData = [[NSUserDefaults standardUserDefaults] objectForKey:@"favList"];
    if (loadData != nil) {
        NSMutableArray *loadArray = [NSKeyedUnarchiver unarchiveObjectWithData:loadData];
        if (loadArray != nil) {
            return loadArray;
        }
    }
    
    return [NSMutableArray array];
}

@end
