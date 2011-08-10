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

@interface WordViewController (HelperMethods)

- (NSInteger)readCurrentID;
- (void)saveCurrentStatus;
- (void)initializeStatusStorage;
@end


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
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _defaults = [NSUserDefaults standardUserDefaults];
        NSArray *progressIDs = [_defaults objectForKey:@"kRememberStatus"];
        NSArray *progressIDsForWordBook = [_defaults objectForKey:@"kRememberStatusForWordBook"];
        if (progressIDs == nil || progressIDsForWordBook == nil) {
            [self initializeStatusStorage];
        }
        
        UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(next:)];
        [self.view addGestureRecognizer:gestureRecognizer];
        gestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [gestureRecognizer release];
        gestureRecognizer = nil;
        
        gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previous:)];
        [self.view addGestureRecognizer:gestureRecognizer];
        gestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [gestureRecognizer release];
        gestureRecognizer = nil;
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
    NSInteger level = 4 - self.levelID;
    
    if (self.sectionID == 0) {
        words = [Word wordsInLevel:level inWordBook:NO];
    }
    else {
        words = [Word wordsInLevel:level inWordBook:YES];
    }
    currentWord = [words objectAtIndex:[self readCurrentID]];
    [self refreshInterface];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveCurrentStatus];
    // Reload tableview data.
    [self.delegate wordViewControllerDidEndEditing];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if ([[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound) {
        return YES;
    }
    else {
        return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    }
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
    EditWordViewController *editControl;
    if ([[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound) {
        editControl = [[EditWordViewController alloc] initWithNibName:@"EditWordViewController-iPad" bundle:nil];
        editControl.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    else {
        editControl = [[EditWordViewController alloc] initWithNibName:@"EditWordViewController" bundle:nil];
        editControl.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    editControl.word = currentWord;
    editControl.delegate = self;
    
    [self presentModalViewController:editControl animated:YES];
}

- (void)editWordViewControllerDidEndEditing {
    [self refreshInterface];
}

#pragma mark - Helper Methods

- (void)saveCurrentStatus {
    NSInteger currentID = [words indexOfObject:currentWord];
    NSInteger wordsCount = [words count];
    if (currentID >= (wordsCount - 1)) {
        currentID %= (wordsCount - 1);
    }
    if (self.sectionID == 0) {
        NSMutableArray *progressIDs = [[_defaults objectForKey:@"kRememberStatus"] mutableCopy];
        [progressIDs replaceObjectAtIndex:self.levelID withObject:[NSNumber numberWithInt:currentID]];
        [_defaults setObject:progressIDs forKey:@"kRememberStatus"];
        [progressIDs release];
    }
    else {
        NSMutableArray *progressIDsForWordBook = [[_defaults objectForKey:@"kRememberStatusForWordBook"] mutableCopy];
        [progressIDsForWordBook replaceObjectAtIndex:self.levelID withObject:[NSNumber numberWithInt:currentID]];
        [_defaults setObject:progressIDsForWordBook forKey:@"kRememberStatusForWordBook"];
        [progressIDsForWordBook release];
    }
    [_defaults synchronize];
}

- (void)initializeStatusStorage {
    NSNumber *zeroNumber = [NSNumber numberWithInt:0];
    NSArray *progressIDs = [[NSArray alloc] initWithObjects:zeroNumber, zeroNumber, zeroNumber, zeroNumber, nil];
    
    [_defaults setObject:progressIDs forKey:@"kRememberStatus"];
    [_defaults setObject:progressIDs forKey:@"kRememberStatusForWordBook"];
    [_defaults synchronize];
}

- (NSInteger)readCurrentID {
    NSInteger currentID;
    if (self.sectionID == 0) {
        NSArray *progressIDs = [_defaults objectForKey:@"kRememberStatus"];
        currentID = [[progressIDs objectAtIndex:self.levelID] integerValue];
    }
    else {
        NSArray *progressIDsForWordBook = [_defaults objectForKey:@"kRememberStatusForWordBook"];
        currentID = [[progressIDsForWordBook objectAtIndex:self.levelID] integerValue];
    }
    return currentID;
}

@end
