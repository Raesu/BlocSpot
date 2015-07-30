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
@property (nonatomic, strong) PlaceOfInterest *nextPOI;
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

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {

    if (self.nextPOI) {
        self.nextPOI.map = nil;
        self.nextPOI = nil;
    }
    
    [mapView_ animateWithCameraUpdate:[GMSCameraUpdate setTarget:coordinate]];
    
    self.nextPOI = [PlaceOfInterest new];
    self.nextPOI.position = coordinate;
    self.nextPOI.appearAnimation = kGMSMarkerAnimationPop;
    self.nextPOI.title = @"New POI Added";
    self.nextPOI.snippet = @"Add from detail on previous screen.";
    self.nextPOI.map = mapView_;
    mapView_.selectedMarker = self.nextPOI;
    
    [[DataSource sharedInstance] addPOI:self.nextPOI];
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
