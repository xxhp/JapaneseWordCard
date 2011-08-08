//
//  Word.h
//  JapaneseWordCard
//
//  Created by Venj Chu on 11/08/08.
//  Copyright 2011年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;
@interface Word : NSObject {
}

@property (assign, nonatomic) NSInteger wordId;
@property (copy, nonatomic) NSString *kanji;
@property (copy, nonatomic) NSString *kana;
@property (copy, nonatomic) NSString *imi;
@property (assign, nonatomic) NSInteger level;
@property (assign, nonatomic) BOOL isInWordBook;

+ (BOOL)isDatabaseReady;
+ (NSArray *)wordCountsForAllLevelsInWordBook:(BOOL)inOrNot;
+ (NSInteger)wordCountForLevel:(NSInteger)theLevel inWordBook:(BOOL)inOrNot;
+ (id)findByWordId:(NSInteger)wordID;
+ (NSArray *)wordsInLevel:(NSInteger)theLevel inWordBook:(BOOL)inOrNot;

- (id)initWithResultSet:(FMResultSet *)s;
- (void)addToWordBook:(BOOL)addOrRemove;
- (void)save;
@end
