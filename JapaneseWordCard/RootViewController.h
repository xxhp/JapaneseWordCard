//
//  RootViewController.h
//  JapaneseWordCard
//
//  Created by Venj Chu on 11/08/07.
//  Copyright 2011年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordViewController.h"

@interface RootViewController : UITableViewController <WordViewControllerDelegate> {
    NSArray *levelCounts;
    NSArray *levelCountsBookmarked;
    BOOL isDatabaseReady;
}

@property (nonatomic, retain) NSArray *levelCounts;
@property (nonatomic, retain) NSArray *levelCountsBookmarked;
@property (nonatomic, assign) BOOL isDatabaseReady;

@end
