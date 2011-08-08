//
//  WordViewController.m
//  JapaneseWordCard
//
//  Created by Venj Chu on 11/08/08.
//  Copyright 2011年 Home. All rights reserved.
//

#import "WordViewController.h"
#import "FMDatabase.h"
#import "Word.h"

@implementation WordViewController
@synthesize levelID = _levelID;
@synthesize sectionID = _sectionID;
@synthesize wordArray = _wordArray; 
@synthesize kanjiLabel = _kanjiLabel;
@synthesize kanaLabel = _kanaLabel;
@synthesize imiLabel = _imiLabel;
@synthesize previousButton = _previousButton;
@synthesize nextButton = _nextButton;
@synthesize isInwordBookSwitch = _isInwordBookSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Add an edit buttom
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editItem:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    // Fetch first word.
    // TODO: Load from user settings to show progress.
    NSInteger level = 4 - self.levelID;
    
    if (self.sectionID == 0) {
        words = [Word wordsInLevel:level inWordBook:NO];
    }
    else {
        words = [Word wordsInLevel:level inWordBook:YES];
    }
    currentWord = [words objectAtIndex:0];
    [self refreshInterface];
}

- (void)viewDidUnload
{
    [self setKanjiLabel:nil];
    [self setKanaLabel:nil];
    [self setImiLabel:nil];
    [self setPreviousButton:nil];
    [self setNextButton:nil];
    [self setIsInwordBookSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_kanjiLabel release];
    [_kanaLabel release];
    [_imiLabel release];
    [_previousButton release];
    [_nextButton release];
    [_isInwordBookSwitch release];
    [super dealloc];
}

- (IBAction)remindMe:(id)sender {
    if (self.isInwordBookSwitch.on) {
        [currentWord setIsInWordBook:YES];
        [currentWord addToWordBook:YES];
    }
    else {
        [currentWord setIsInWordBook:NO];
        [currentWord addToWordBook:NO];
    }
}

- (IBAction)previous:(id)sender {
    currentWord = [words objectAtIndex:[words indexOfObject:currentWord] - 1];
    [self refreshInterface];
}

- (IBAction)next:(id)sender {
    currentWord = [words objectAtIndex:[words indexOfObject:currentWord] + 1];
    [self refreshInterface];
}

- (void)refreshInterface {
    self.navigationItem.title = [NSString stringWithFormat:@"Level %d (%d/%d)", 4 - self.levelID, [words indexOfObject:currentWord] + 1, [words count]];
    self.kanjiLabel.text = currentWord.kanji;
    self.kanaLabel.text = currentWord.kana;
    self.imiLabel.text = currentWord.imi;
    self.isInwordBookSwitch.on = currentWord.isInWordBook;
    if ([words indexOfObject:currentWord] == 0) {
        self.previousButton.enabled = NO;
        self.previousButton.hidden = YES;
    }
    else {
        self.previousButton.enabled = YES;
        self.previousButton.hidden = NO;
    }
    if ([words indexOfObject:currentWord] == [words count] - 1) {
        self.nextButton.enabled = NO;
        self.nextButton.hidden = YES;
    }
    else {
        self.nextButton.enabled = YES;
        self.nextButton.hidden = NO;
    }
}

- (void)editItem:(id)sender {
    EditWordViewController *editControl = [[EditWordViewController alloc] initWithNibName:@"EditWordViewController" bundle:nil];
    editControl.word = currentWord;
    editControl.delegate = self;
    [self presentModalViewController:editControl animated:YES];
}

- (void)editWirdViewControllerDidEndEditing {
    [self refreshInterface];
}

@end
