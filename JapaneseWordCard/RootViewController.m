//
//  RootViewController.m
//  JapaneseWordCard
//
//  Created by Venj Chu on 11/08/07.
//  Copyright 2011年 Home. All rights reserved.
//

#import "RootViewController.h"
#import "FMDatabase.h"
#import "WordViewController.h"
#import "Word.h"

@implementation RootViewController
@synthesize levelCountsBookmarked;
@synthesize levelCounts;
@synthesize isDatabaseReady;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Initialize
    self.isDatabaseReady = [Word isDatabaseReady];
    if (isDatabaseReady) {
        self.navigationItem.title = @"Levels";
        self.levelCounts = [Word wordCountsForAllLevelsInWordBook:NO];
        self.levelCountsBookmarked = [Word wordCountsForAllLevelsInWordBook:YES];
    }
    else {
        self.navigationItem.title = @"No DB File";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if ([[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound) {
        return YES;
    }
    else {
        return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isDatabaseReady) {
        return 4;
    }
    return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cells";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell.
    
    if (self.isDatabaseReady) {
        NSInteger rowID = indexPath.row;
        
        BOOL inWordBook;
        if (indexPath.section == 1) {
            inWordBook = YES;
        }
        else {
            inWordBook = NO;
        }
        
        NSInteger count = 0;
        if (indexPath.section == 0) {
            count = [[self.levelCounts objectAtIndex:(3 - rowID)] intValue];
        }
        else {
            count = [[self.levelCountsBookmarked objectAtIndex:(3 - rowID)] intValue];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"Level %d (%d)", 4 - rowID, count];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.isDatabaseReady) {
        NSString *message;
        switch (section) {
            case 0:
                message = @"Remember Words";
                break;
            case 1:
                message = @"Word Book";
                break;
            default:
                break;
        }
        return message;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && [[self.levelCountsBookmarked objectAtIndex:(3 - indexPath.row)] intValue] == 0) {
        return;
    }
    WordViewController *wordControl;
    if ([[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound) {
        wordControl = [[WordViewController alloc] initWithNibName:@"WordViewController-iPad" bundle:nil];
    }
    else {
        wordControl = [[WordViewController alloc] initWithNibName:@"WordViewController" bundle:nil];
    }
    wordControl.levelID = indexPath.row;
    wordControl.sectionID = indexPath.section;
    [self.navigationController pushViewController:wordControl animated:YES];
    [wordControl release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.levelCounts = nil;
    self.levelCountsBookmarked = nil;
}

- (void)dealloc
{
    [super dealloc];
}

@end
