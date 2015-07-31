//
//  PlaceOfInterest.m
//  BlocSpot
//
//  Created by Ryan Summe on 7/24/15.
//  Copyright (c) 2015 Ryan Summe. All rights reserved.
//

#import "PlaceOfInterest.h"

@implementation PlaceOfInterest

- (id)initWithPlace:(GMSPlace *)place {
    
    if (self = [super init]) {
        self.title = place.name;
        self.snippet = @"New POI.";
        self.formattedAddress = [[place.formattedAddress componentsSeparatedByString:@", "] componentsJoinedByString:@"\n"];
        self.placeID = place.placeID;
        self.phoneNumber = place.phoneNumber;
        self.rating = place.rating;
        self.priceLevel = place.priceLevel;
        self.types = place.types;
        self.website = place.website;
        self.attributions = place.attributions;
        self.position = place.coordinate;
        
        if (self.placeID) {
            self.userDefined = YES;
        }
    }
    return self;
}



#pragma NSCoding Delegate

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(title))];
        self.snippet = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(snippet))];
        self.notes = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(notes))];
        self.position = CLLocationCoordinate2DMake([aDecoder decodeFloatForKey:@"position.latitude"],
                                                   [aDecoder decodeFloatForKey:@"position.longitude"]);
        self.formattedAddress = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(formattedAddress))];
        self.placeID = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(placeID))];
        self.phoneNumber = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(phoneNumber))];
        self.rating = [aDecoder decodeFloatForKey:NSStringFromSelector(@selector(rating))];
        self.priceLevel = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(priceLevel))];
        self.types = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(types))];
        self.website = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(website))];
        self.attributions = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(attributions))];
        self.userDefined = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(userDefined))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:NSStringFromSelector(@selector(title))];
    [aCoder encodeObject:self.snippet forKey:NSStringFromSelector(@selector(snippet))];
    [aCoder encodeObject:self.notes forKey:NSStringFromSelector(@selector(notes))];
    [aCoder encodeFloat:self.position.latitude forKey:@"position.latitude"];
    [aCoder encodeFloat:self.position.longitude forKey:@"position.longitude"];
    [aCoder encodeObject:self.formattedAddress forKey:NSStringFromSelector(@selector(formattedAddress))];
    [aCoder encodeObject:self.placeID forKey:NSStringFromSelector(@selector(placeID))];
    [aCoder encodeObject:self.phoneNumber forKey:NSStringFromSelector(@selector(phoneNumber))];
    [aCoder encodeFloat:self.rating forKey:NSStringFromSelector(@selector(rating))];
    [aCoder encodeInteger:self.priceLevel forKey:NSStringFromSelector(@selector(priceLevel))];
    [aCoder encodeObject:self.types forKey:NSStringFromSelector(@selector(types))];
    [aCoder encodeObject:self.website forKey:NSStringFromSelector(@selector(website))];
    [aCoder encodeObject:self.attributions forKey:NSStringFromSelector(@selector(attributions))];
    [aCoder encodeBool:self.userDefined forKey:NSStringFromSelector(@selector(userDefined))];
}

@end
