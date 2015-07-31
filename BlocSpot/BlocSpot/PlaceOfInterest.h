//
//  PlaceOfInterest.h
//  BlocSpot
//
//  Created by Ryan Summe on 7/24/15.
//  Copyright (c) 2015 Ryan Summe. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@interface PlaceOfInterest : GMSMarker <NSCoding>

@property (nonatomic, strong) NSString *userCategory;
@property (nonatomic, strong) NSDate *dateAdded;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *formattedAddress;
@property (nonatomic, strong) NSString *placeID;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, assign) float rating;
@property (nonatomic, assign) GMSPlacesPriceLevel priceLevel;
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) NSURL *website;
@property (nonatomic, strong) NSAttributedString *attributions;
@property (nonatomic, assign) BOOL userDefined;

- (id)initWithPlace:(GMSPlace *)place;

@end
