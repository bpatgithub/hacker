//
//  ViewController.m
//  BPReadXML
//
//  Created by Patel, Bhavesh on 1/27/13.
//  Copyright (c) 2013 Patel, Bhavesh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Plants";  //assign a custom title to table
    
    _plants = [[NSMutableArray alloc]init];
    
    // try out to make sure it works
    Plant *samplePlant = [[Plant alloc] init];
    SamplePlant.common = @"Bloodroot";
    samplePlant.botanical = @"Sanguinaria canadensis";
    samplePlant.light = @"Mostly Shady";
    samplePlant.price = @"$2.44";
    samplePlant.avail = @"031599";
    
    [_plants addObject:samplePlant];
    
    
#pragma XML Read
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL URLWithString:@"http://www.w3schools.com/XML/plant_catalog.xml"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

#pragma table details -
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_plants count];
}

//Customer appearnce of table view cells.
- (UITableViewCell *)tableview:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Plant *plant = [_plants objectAtIndex:[indexPath row]];
    cell.textLabel.text = plant.common;
    cell.detailTextLabel.text = plant.botanical;
    
    return cell;
}

#pragma mark Table view delegage -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Plant *plant = [_plants objectAtIndex:[indexPath row]];
    
    PlantDetailViewController *vc = [[PlantDetailViewController alloc] intiWithStyle:UITableViewStyleGrouped];
    vc.plant = plant;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
