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
}

- (void)createNewClicker
{
    Clicker *clicker = [[Clicker alloc] init];
  
    [_clickers addObject:clicker];
    

    NSIndexPath *ip = [NSIndexPath indexPathForRow:[_clickers count] - 1 inSection:0];
	
    NSArray *array = [NSArray arrayWithObject:ip];
    
    [self.tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationRight];
    
//    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"Clicker %i", [indexPath row]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", [clicker clickCount]];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClickerViewController *vc = [[ClickerViewController alloc] initWithNibName:nil bundle:nil];
    Clicker *clicker = [_clickers objectAtIndex:[indexPath row]];
    vc.clicker = clicker;
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Memory management



@end

