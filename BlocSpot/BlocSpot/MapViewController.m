//
//  MapViewController.m
//  BlocSpot
//
//  Created by Ryan Summe on 7/22/15.
//  Copyright (c) 2015 Ryan Summe. All rights reserved.
//

#import "MapViewController.h"
#import "DataSource.h"
#import "PlaceOfInterest.h"
@import GoogleMaps;

@interface MapViewController () <GMSMapViewDelegate> {
    GMSMapView *mapView_;
    BOOL firstLocationUpdate;
    CLLocationManager *locationManager;
}
@property (nonatomic, strong) PlaceOfInterest *placeOfInterest;
@property (nonatomic, strong) GMSPlacePicker *placePicker;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager = [CLLocationManager new];
    [locationManager requestWhenInUseAuthorization];
    
    CLLocationCoordinate2D loc;
    if (self.currentPOI) {
        loc = CLLocationCoordinate2DMake(self.currentPOI.position.latitude, self.currentPOI.position.longitude);
    } else {
        loc = CLLocationCoordinate2DMake(37.769031, -122.439488);
    }
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:loc zoom:12.5];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.tiltGestures = NO;
    mapView_.settings.rotateGestures = NO;
    mapView_.delegate = self;
    self.view = mapView_;

    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    
    [mapView_ addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)dealloc {
    [mapView_ removeObserver:self forKeyPath:@"myLocation" context:NULL];
}

#pragma mark GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    if (self.placeOfInterest) {
        self.placeOfInterest.map = nil;
    }
    
    float buffer = 0.004;
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(coordinate.latitude + buffer, coordinate.longitude + buffer);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(coordinate.latitude - buffer, coordinate.longitude - buffer);
    
    GMSCoordinateBounds *viewPort = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast coordinate:southWest];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewPort];
    self.placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    // what if the user doesn't choose a "place"?
    [self.placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error) {
            NSLog(@"Error picking place: %@", [error localizedDescription]);
            return;
        }
        if (place) {
            self.placeOfInterest = [[PlaceOfInterest alloc] initWithPlace:place];
            [mapView_ animateWithCameraUpdate:[GMSCameraUpdate setTarget:coordinate]];
            self.placeOfInterest.map = mapView_;
            [self addPOI];
        }
    }];
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    if (self.placeOfInterest) {
        self.placeOfInterest.map = nil;
        self.placeOfInterest = nil;
    } else {
        [mapView_ animateWithCameraUpdate:[GMSCameraUpdate setTarget:coordinate]];
    
        self.placeOfInterest = [PlaceOfInterest new];
        self.placeOfInterest.position = coordinate;
        self.placeOfInterest.appearAnimation = kGMSMarkerAnimationPop;
        self.placeOfInterest.title = @"New POI";
        self.placeOfInterest.snippet = @"Add to your collection?";
        self.placeOfInterest.map = mapView_;
        mapView_.selectedMarker = self.placeOfInterest;
    }
}

- (void)addPOI {
    [[DataSource sharedInstance] addPOI:self.placeOfInterest];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"POI added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if (!firstLocationUpdate) {
//        firstLocationUpdate = YES;
//        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
//        mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:12];
//    }
}

@end
