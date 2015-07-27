//
//  DataSource.m
//  BlocSpot
//
//  Created by Ryan Summe on 7/24/15.
//  Copyright (c) 2015 Ryan Summe. All rights reserved.
//

#import "DataSource.h"
#import "PlaceOfInterest.h"

@interface DataSource () {
    NSMutableArray *_items;
}


@end

@implementation DataSource

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        
        _items = [self getTempPOIs];
    }
    return self;
}

- (NSMutableArray *)getTempPOIs {
    
    PlaceOfInterest *point1 = [PlaceOfInterest new];
    point1.position = CLLocationCoordinate2DMake(37.777931, -122.456009);
    point1.title = @"Point 1";
    point1.snippet = @"Temp snippet";
    point1.map = nil;
    
    PlaceOfInterest *point2 = [PlaceOfInterest new];
    point1.position = CLLocationCoordinate2DMake(37.793742, -122.435531);
    point1.title = @"Point 2";
    point1.snippet = @"Temp snippet";
    point1.map = nil;

    PlaceOfInterest *point3 = [PlaceOfInterest new];
    point1.position = CLLocationCoordinate2DMake(37.781428, -122.406358);
    point1.title = @"Point 3";
    point1.snippet = @"Temp snippet";
    point1.map = nil;
    
    PlaceOfInterest *point4 = [PlaceOfInterest new];
    point1.position = CLLocationCoordinate2DMake(37.781253, -122.425959);
    point1.title = @"Point 4";
    point1.snippet = @"Temp snippet";
    point1.map = nil;
    
    PlaceOfInterest *point5 = [PlaceOfInterest new];
    point1.position = CLLocationCoordinate2DMake(37.800263, -122.412316);
    point1.title = @"Point 5";
    point1.snippet = @"Temp snippet";
    point1.map = nil;
    
    return [NSMutableArray arrayWithObjects:point1, point2, point3, point4, point5, nil];
}

@end
