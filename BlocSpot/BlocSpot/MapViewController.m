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
    BOOL firstLocationUpdate;
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
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
    [self.mapView setCamera:camera];
    
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.tiltGestures = NO;
    self.mapView.settings.rotateGestures = NO;
    self.mapView.delegate = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        self.mapView.myLocationEnabled = YES;
    });
    
    [self.mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)dealloc {
    [self.mapView removeObserver:self forKeyPath:@"myLocation" context:NULL];
}

#pragma mark GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    if (self.placeOfInterest) {
        self.placeOfInterest.map = nil;
    }
    
    float buffer = 0.003;
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(coordinate.latitude + buffer, coordinate.longitude + buffer);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(coordinate.latitude - buffer, coordinate.longitude - buffer);
    
    GMSCoordinateBounds *viewPort = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast coordinate:southWest];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewPort];
    self.placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    [self.placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error) {
            NSLog(@"Error picking place: %@", [error localizedDescription]);
            return;
        }
        if (place) {
            self.placeOfInterest = [[PlaceOfInterest alloc] initWithPlace:place];
            [self.mapView animateWithCameraUpdate:[GMSCameraUpdate setTarget:coordinate]];
            self.placeOfInterest.map = mapView;
            [self addPOI];
        }
    }];
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    if (self.placeOfInterest) {
        self.placeOfInterest.map = nil;
        self.placeOfInterest = nil;
    } else {
        [mapView animateWithCameraUpdate:[GMSCameraUpdate setTarget:coordinate]];
    
        GMSGeocoder *geocoder = [GMSGeocoder geocoder];
        [geocoder reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
            self.placeOfInterest = [PlaceOfInterest new];
            self.placeOfInterest.position = coordinate;
            self.placeOfInterest.appearAnimation = kGMSMarkerAnimationPop;
            self.placeOfInterest.title = [response firstResult].thoroughfare;
            self.placeOfInterest.snippet = [response firstResult].locality;
            self.placeOfInterest.map = mapView;
            mapView.selectedMarker = self.placeOfInterest;
        }];
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
