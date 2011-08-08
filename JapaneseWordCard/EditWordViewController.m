//
//  EditWordViewController.m
//  JapaneseWordCard
//
//  Created by Venj Chu on 11/08/08.
//  Copyright 2011年 Home. All rights reserved.
//

#import "EditWordViewController.h"
#import "Word.h"

@implementation EditWordViewController
@synthesize kanjiField = _kanjiField;
@synthesize kanaField = _kanaField;
@synthesize imiField = _imiField;
@synthesize word = _word;
@synthesize navItem = _navItem;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.navItem.title = self.word.kanji;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissMe:)];
    self.navItem.rightBarButtonItem = rightItem;
    [rightItem release];
    [(UIScrollView *)self.view setContentSize:CGSizeMake(320, 416)];
    // Initialize text fields.
    self.kanjiField.text = self.word.kanji;
    self.kanaField.text = self.word.kana;
    self.imiField.text = self.word.imi;
}

- (void)viewDidUnload
{
    [self setKanjiField:nil];
    [self setKanaField:nil];
    [self setImiField:nil];
    [self setNavItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dismissMe:(id)sender {
    [self.word setKanji:self.kanjiField.text];
    [self.word setKana:self.kanaField.text];
    [self.word setImi:self.imiField.text];
    
    [self.word save];
    
    [self dismissModalViewControllerAnimated:YES];
    [self.delegate editWirdViewControllerDidEndEditing];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.kanaField resignFirstResponder];
    [self.imiField resignFirstResponder];
}

- (void)dealloc {
    [_kanjiField release];
    [_kanaField release];
    [_imiField release];
    [_navItem release];
    [super dealloc];
}
@end
