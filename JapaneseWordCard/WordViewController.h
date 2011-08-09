//
//  WordViewController.h
//  JapaneseWordCard
//
//  Created by Venj Chu on 11/08/08.
//  Copyright 2011年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditWordViewController.h"

@protocol WordViewControllerDelegate <NSObject>
- (void)wordViewControllerDidEndEditing;
@end

@class Word;
@interface WordViewController : UIViewController <EditWordViewControllerDelegate> {
    NSUserDefaults *_defaults;
    NSString *dbPath;
    UILabel *_kanjiLabel;
    UILabel *_kanaLabel;
    UILabel *_imiLabel;
    UIButton *_previousButton;
    UIButton *_nextButton;
    UISwitch *_isInwordBookSwitch;
    Word *currentWord;
    NSArray *words;
}
@property (assign, nonatomic) NSInteger levelID;
@property (assign, nonatomic) NSInteger sectionID;
@property (retain, nonatomic) NSArray *wordArray;
@property (nonatomic, retain) IBOutlet UILabel *kanjiLabel;
@property (nonatomic, retain) IBOutlet UILabel *kanaLabel;
@property (nonatomic, retain) IBOutlet UILabel *imiLabel;
@property (nonatomic, retain) IBOutlet UIButton *previousButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UISwitch *isInwordBookSwitch;
@property (assign) id<WordViewControllerDelegate> delegate;

- (IBAction)remindMe:(id)sender;
- (IBAction)previous:(id)sender;
- (IBAction)next:(id)sender;
- (void)editItem:(id)sender;
- (void)refreshInterface;

@end
