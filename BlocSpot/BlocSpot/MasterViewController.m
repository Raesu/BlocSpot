//
//  MasterViewController.m
//  BlocSpot
//
//  Created by Ryan Summe on 7/21/15.
//  Copyright (c) 2015 Ryan Summe. All rights reserved.
//

#import "MasterViewController.h"
#import "DataSource.h"
#import "PlaceOfInterest.h"
#import "MapViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()
@property (nonatomic, strong) PlaceOfInterest *selectedPOI;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[DataSource sharedInstance] addObserver:self forKeyPath:@"items" options:0 context:nil];
    
}

- (void)dealloc {
    [[DataSource sharedInstance] removeObserver:self forKeyPath:@"items"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == [DataSource sharedInstance] && [keyPath isEqualToString:@"items"]) {
        [self.tableView reloadData];
    }
}

- (NSArray *)items {
    return [[DataSource sharedInstance] items];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        DetailViewController *detailVC = (DetailViewController *)[segue destinationViewController];
        detailVC.placeOfInterest = self.selectedPOI;
    }
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self items].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    PlaceOfInterest *poi = [[self items] objectAtIndex:indexPath.row];
    cell.textLabel.text = poi.title;
    cell.detailTextLabel.text = poi.snippet;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedPOI = [[self items] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle {
    
}


@end
