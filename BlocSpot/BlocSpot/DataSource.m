//
//  DataSource.m
//  BlocSpot
//
//  Created by Ryan Summe on 7/24/15.
//  Copyright (c) 2015 Ryan Summe. All rights reserved.
//

#import "DataSource.h"

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
    if (self = [super init]) {
        // unable to do the below on async, google maps SDK: method calls need to be on UI thread
        NSString *fullPath = [self pathForFilename:NSStringFromSelector(@selector(items))];
        NSArray *storedItems = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
            if (storedItems.count > 0) {
                NSMutableArray *mutableItems = [storedItems mutableCopy];
                [self willChangeValueForKey:@"items"];
                _items = mutableItems;
                [self didChangeValueForKey:@"items"];
            }
    }
    return self;
}

- (NSString *)pathForFilename:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    return dataPath;
}

- (void)saveItems {
    if (self.items.count > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *fullPath = [self pathForFilename:NSStringFromSelector(@selector(items))];
            NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:self.items];
            
            NSError *dataError;
            BOOL wroteSuccessfully = [itemData writeToFile:fullPath options:NSDataWritingAtomic | NSDataWritingFileProtectionCompleteUnlessOpen error:&dataError];
            
            if (!wroteSuccessfully) {
                NSLog(@"Could not save to disk:%@", dataError);
            }
        });
    }
}

#pragma mark KVO Methods

- (void)addPOI:(PlaceOfInterest *)POI {
    NSMutableArray *itemsWithKVO = [self mutableArrayValueForKey:@"items"];
    [itemsWithKVO addObject:POI];
    [self saveItems];
}

- (void)updatePOI:(PlaceOfInterest *)POI {
    NSMutableArray *itemsWithKVO = [self mutableArrayValueForKey:@"items"];
    
    // bad way to do this (when items array gets very large). pass in index or id.
    for (PlaceOfInterest *item in itemsWithKVO) {
        if (item.position.latitude == POI.position.latitude &&
            item.position.longitude == POI.position.longitude) {
            [itemsWithKVO replaceObjectAtIndex:[itemsWithKVO indexOfObject:item] withObject:POI];
            break;
        }
    }
    [self saveItems];
}

- (void)deletePOI:(PlaceOfInterest *)POI {
    NSMutableArray *itemsWithKVO = [self mutableArrayValueForKey:@"items"];
    [itemsWithKVO removeObject:POI];
    [self saveItems];
}


@end
