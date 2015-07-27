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
    GMSMapView *mapView;
    BOOL firstLocationUpdate;
    CLLocationManager *locationManager;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager = [CLLocationManager new];
    [locationManager requestWhenInUseAuthorization];
    
    CLLocationCoordinate2D temp = CLLocationCoordinate2DMake(37.769031, -122.439488);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:temp zoom:12.5];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    mapView.settings.myLocationButton = YES;
    mapView.settings.tiltGestures = NO;
    mapView.settings.rotateGestures = NO;
    
    [mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    
    self.view = mapView;

    dispatch_async(dispatch_get_main_queue(), ^{
        mapView.myLocationEnabled = YES;
    });
    
}

- (void)dealloc {
    [mapView removeObserver:self forKeyPath:@"myLocation" context:NULL];
}

- (void)loadPOIs {
    
}

#pragma mark GMSMapViewDelegate
//-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
//    
//}


#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if (!firstLocationUpdate) {
//        firstLocationUpdate = YES;
//        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
//        mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:12];
//    }
}

@end
