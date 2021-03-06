//
//  DataSource.h
//  BlocSpot
//
//  Created by Ryan Summe on 7/24/15.
//  Copyright (c) 2015 Ryan Summe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceOfInterest.h"

@interface DataSource : NSObject

@property (nonatomic, strong, readonly) NSArray *items;
+ (instancetype)sharedInstance;
- (void)saveItems;

- (void)addPOI:(PlaceOfInterest *)POI;
- (void)updatePOI:(PlaceOfInterest *)POI;
- (void)deletePOI:(PlaceOfInterest *)POI;

@end
