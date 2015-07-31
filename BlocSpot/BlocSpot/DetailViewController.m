//
//  DetailViewController.m
//  BlocSpot
//
//  Created by Ryan Summe on 7/28/15.
//  Copyright (c) 2015 Ryan Summe. All rights reserved.
//

#import "DetailViewController.h"
#import "DataSource.h"
@import GoogleMaps;

@interface DetailViewController ()

@property (nonatomic, strong) IBOutlet UITextView *nameTextView;
@property (nonatomic, strong) IBOutlet UITextView *snippetTextView;
@property (nonatomic, strong) IBOutlet UITextView *notesTextView;
@property (nonatomic, strong) IBOutlet GMSMapView *mapView;
@property (nonatomic, assign) BOOL doNotSave;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:self.placeOfInterest.position zoom:16];
    [self.mapView setCamera:camera];
    self.placeOfInterest.map = self.mapView;
    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(deletePOI)];
    [self.navigationItem setTitle:@"POI Detail"];
    [self.navigationItem setRightBarButtonItem:deleteButton];
    
    self.nameTextView.text = self.placeOfInterest.title;
    self.snippetTextView.text = self.placeOfInterest.snippet;
    self.notesTextView.text = self.placeOfInterest.notes;
}

- (void)viewDidDisappear:(BOOL)animated {
    if (!self.doNotSave) {
        [self savePOI];
    }
}

#pragma POI Functions

- (void)savePOI {
    self.placeOfInterest.title = self.nameTextView.text;
    self.placeOfInterest.snippet = self.snippetTextView.text;
    self.placeOfInterest.notes = self.notesTextView.text;
    
    [[DataSource sharedInstance] updatePOI:self.placeOfInterest];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)deletePOI {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure you want to delete this POI?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[DataSource sharedInstance] deletePOI:self.placeOfInterest];
        self.doNotSave = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:yesAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}

@end
