//
//  EditWordViewController.h
//  JapaneseWordCard
//
//  Created by Venj Chu on 11/08/08.
//  Copyright 2011年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditWordViewControllerDelegate <NSObject>
- (void)editWordViewControllerDidEndEditing;
@end

@class Word;
@interface EditWordViewController : UIViewController<UITextFieldDelegate> {
    UITextField *_kanjiField;
    UITextField *_kanaField;
    UITextField *_imiField;
    UINavigationItem *_navItem;
}


@property (nonatomic, retain) IBOutlet UITextField *kanjiField;
@property (nonatomic, retain) IBOutlet UITextField *kanaField;
@property (nonatomic, retain) IBOutlet UITextField *imiField;
@property (nonatomic, retain) Word *word;
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;
@property (assign) id<EditWordViewControllerDelegate> delegate;

- (void)dismissMe:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

@end

