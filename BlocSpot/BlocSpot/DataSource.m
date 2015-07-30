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
    self = [super init];
    if (self) {

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

- (void)addPOI:(PlaceOfInterest *)POI {
    NSMutableArray *itemsWithKVO = [self mutableArrayValueForKey:@"items"];
    [itemsWithKVO addObject:POI];
    [self saveItems];
}

@end
