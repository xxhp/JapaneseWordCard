//
//  Word.m
//  JapaneseWordCard
//
//  Created by Venj Chu on 11/08/08.
//  Copyright 2011年 Home. All rights reserved.
//

#import "Word.h"
#import "FMDatabase.h"

@implementation Word

@synthesize wordId = _wordId;
@synthesize kanji = _kanji;
@synthesize kana = _kana;
@synthesize imi = _imi;
@synthesize level = _level;
@synthesize isInWordBook = _isInWordBook;

#pragma mark - Class Methods

+ (BOOL)isDatabaseReady {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *_dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"db.sqlite"];
    if ([manager fileExistsAtPath:_dbPath]) {
        return YES;
    }
    return NO;
}

+ (NSArray *)wordCountsForAllLevelsInWordBook:(BOOL)inOrNot {
    NSString *_dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"db.sqlite"];
    FMDatabase *_db = [[FMDatabase alloc] initWithPath:_dbPath];
    NSMutableArray *levelsCount = [NSMutableArray array];
    if (![_db open]) {
        [_db release];
        return nil;
    }
    
    NSString *query;
    if (inOrNot) {
        for (NSInteger i = 1; i <= 4; i++) {
            query = [NSString stringWithFormat:@"SELECT COUNT(*) FROM `jccard` WHERE bookmark=1 AND type=%d", i];
            FMResultSet *s = [_db executeQuery:query];
            if ([s next]) {
                [levelsCount addObject:[NSNumber numberWithInt:[s intForColumnIndex:0]]];
            }
        }
    }
    else {
        query = @"SELECT COUNT(*) FROM `jccard` GROUP BY(type)";
        FMResultSet *s = [_db executeQuery:query];
        while ([s next]) {
            [levelsCount addObject:[NSNumber numberWithInt:[s intForColumnIndex:0]]];
        }
    }
    
    [_db close];
    return levelsCount;
}

+ (NSInteger)wordCountForLevel:(NSInteger)theLevel inWordBook:(BOOL)inOrNot {
    return [[[self wordCountsForAllLevelsInWordBook:inOrNot] objectAtIndex:theLevel] integerValue];
}

+ (id)findByWordId:(NSInteger)wordID {
    NSString *_dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"db.sqlite"];
    FMDatabase *_db = [[FMDatabase alloc] initWithPath:_dbPath];
    
    if (![_db open]) {
        [_db release];
        return nil;
    }
    FMResultSet *s = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM `jccard` WHERE id=%d", wordID]];
    id word = nil;
    if ([s next]) {
        word = [[self alloc] initWithResultSet:s];
    }
    [_db close];
    
    return [word autorelease];
}

+ (NSArray *)wordsInLevel:(NSInteger)theLevel inWordBook:(BOOL)inOrNot {
    NSString *_dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"db.sqlite"];
    FMDatabase *_db = [[FMDatabase alloc] initWithPath:_dbPath];
    
    if (![_db open]) {
        [_db release];
        return nil;
    }
    
    NSString *query;
    if (inOrNot) {
        query = [NSString stringWithFormat:@"SELECT * FROM `jccard` WHERE type=%d %@", theLevel, @"AND bookmark=1"];
    }
    else {
        query = [NSString stringWithFormat:@"SELECT * FROM `jccard` WHERE type=%d", theLevel];
    }
    
    FMResultSet *s = [_db executeQuery:query];
    NSMutableArray *results = [[NSMutableArray alloc] init];
    while ([s next]) {
        id word = [[self alloc] initWithResultSet:s];
        [results addObject:word];
        [word release];
    }
    [_db close];
    
    return results;
}



#pragma mark - Initialization & Deallc

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (id)initWithResultSet:(FMResultSet *)s {
    self = [super init];
    if (self) {
        self.wordId = [s intForColumnIndex:0];
        self.kanji = [s stringForColumnIndex:1];
        self.kana = [s stringForColumnIndex:2];
        self.imi = [s stringForColumnIndex:3];
        self.level = [s intForColumnIndex:4];
        self.isInWordBook = [s boolForColumnIndex:6];
    }
    
    return self;
}

- (void)dealloc {
    [self.kanji release];
    [self.kana release];
    [self.imi release];
    
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%d. %@ | %@ | %@ | Level %d | %d", self.wordId, self.kanji, self.kana, self.imi, self.level, self.isInWordBook];
}

#pragma mark - Instance Methods

- (void)addToWordBook:(BOOL)addOrRemove {
    NSString *_dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"db.sqlite"];
    FMDatabase *_db = [[FMDatabase alloc] initWithPath:_dbPath];
    
    if (![_db open]) {
        [_db release];
        return;
    }
    BOOL result = [_db executeUpdate:[NSString stringWithFormat:@"UPDATE jccard SET bookmark='%d' WHERE id='%d'", addOrRemove ? 1 : 0, self.wordId]];
    if (!result) {
        NSLog(@"Error Update");
    }
    [_db close];
}

- (void)save {
    NSString *_dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"db.sqlite"];
    FMDatabase *_db = [[FMDatabase alloc] initWithPath:_dbPath];
    
    if (![_db open]) {
        [_db release];
        return;
    }
    BOOL result = [_db executeUpdate:[NSString stringWithFormat:@"UPDATE jccard SET data='%@', data2='%@', data3='%@' WHERE id=%d", self.kanji, self.kana, self.imi, self.wordId]];
    //BOOL result = [_db executeUpdate:@"UPDATE jccard SET data='?',data2='?',data3='?' WHERE id=?", self.kanji, self.kana, self.imi, self.wordId];
    if (!result) {
        NSLog(@"Error Update");
    }
    [_db close];
}

@end
