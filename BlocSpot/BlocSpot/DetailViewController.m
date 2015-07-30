//
//  DetailViewController.m
//  BlocSpot
//
//  Created by Ryan Summe on 7/28/15.
//  Copyright (c) 2015 Ryan Summe. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UITextView *nameTextView;
@property (strong, nonatomic) IBOutlet UITextView *snippetTextView;
@property (strong, nonatomic) IBOutlet UITextView *notesTextView;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationItem.title = @"POI Detail";
    self.nameTextView.text = self.placeOfInterest.title;
    self.snippetTextView.text = self.placeOfInterest.snippet;
    self.notesTextView.text = self.placeOfInterest.notes;
}


@end
