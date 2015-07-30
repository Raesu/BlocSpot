//
//  PlaceOfInterest.m
//  BlocSpot
//
//  Created by Ryan Summe on 7/24/15.
//  Copyright (c) 2015 Ryan Summe. All rights reserved.
//

#import "PlaceOfInterest.h"

@implementation PlaceOfInterest


#pragma NSCoding Delegate

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(title))];
        self.snippet = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(snippet))];
        self.notes = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(notes))];
        self.position = CLLocationCoordinate2DMake([aDecoder decodeFloatForKey:@"position.latitude"],
                                                   [aDecoder decodeFloatForKey:@"position.longitude"]);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:NSStringFromSelector(@selector(title))];
    [aCoder encodeObject:self.snippet forKey:NSStringFromSelector(@selector(snippet))];
    [aCoder encodeObject:self.notes forKey:NSStringFromSelector(@selector(notes))];
    
    [aCoder encodeFloat:self.position.latitude forKey:@"position.latitude"];
    [aCoder encodeFloat:self.position.longitude forKey:@"position.longitude"];
}

@end
