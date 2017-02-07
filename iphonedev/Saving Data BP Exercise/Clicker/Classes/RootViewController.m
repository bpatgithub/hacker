//
//  RootViewController.m
//  Clicker
//
//  Created by George Polak on 8/16/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "ClickerViewController.h"


@implementation RootViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Clickers";
    
    _clickers = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] 
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                     target:self
                                     action:@selector(createNewClicker)];
    self.navigationItem.rightBarButtonItem = addButton;

    
    UIBarButtonItem *editButton = [self editButtonItem];
    editButton.target = self;
    editButton.action = @selector(editTable);
    self.navigationItem.leftBarButtonItem = editButton;
}

- (void)editTable
{
    [self setEditing:!self.editing animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [_clickers removeObjectAtIndex:[indexPath row]];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];        
    }
}

- (void)createNewClicker
{
    AddClickerViewController *vc = [[AddClickerViewController alloc] initWithNibName:@"AddClickerView" bundle:nil];
    vc.delegate = self;
    [self presentModalViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)addClickerViewController:(AddClickerViewController *)vc didFinishWithClicker:(Clicker *)clicker
{
    [_clickers addObject:clicker];
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:[_clickers count] - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_clickers count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Clicker *clicker = [_clickers objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = clicker.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", [clicker clickCount]];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClickerViewController *vc = [[ClickerViewController alloc] initWithNibName:@"ClickerViewController" bundle:nil];
    Clicker *clicker = [_clickers objectAtIndex:[indexPath row]];
    vc.clicker = clicker;
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Memory management



@end

