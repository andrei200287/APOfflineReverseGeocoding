//
//  APReverseGeocodingTests.m
//  APReverseGeocodingExample
//
//  Created by Sergii Kryvoblotskyi on 4/15/15.
//  Copyright (c) 2015 Sergii Kryvoblotskyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "APReverseGeocoding.h"
#import "APCountry.h"

@interface APReverseGeocodingTests : XCTestCase

@end

@implementation APReverseGeocodingTests

- (void)testURLImported {
    
    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"countries.geo" withExtension:@"json"];
    APReverseGeocoding *geocoding = [APReverseGeocoding geocodingWithGeoJSONURL:url];
    XCTAssertEqual(geocoding.url, url);
}

/* Multipolygon */
- (void)testNewYorkCoordinatesGeocodesUSA
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(40.61643493, -73.99224019);
    APReverseGeocoding *geocoding = [APReverseGeocoding defaultGeocoding];
    APCountry *country = [geocoding geocodeCountryWithCoordinate:coordinate];
    
    XCTAssertTrue([country.code isEqualToString:@"USA"]);
}

/* Polygon */
- (void)testKievCoordinatesGeocodesUkraine
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(50.4546600, 30.5238000);
    APReverseGeocoding *geocoding = [APReverseGeocoding defaultGeocoding];
    APCountry *country = [geocoding geocodeCountryWithCoordinate:coordinate];
    
    XCTAssertTrue([country.code isEqualToString:@"UKR"]);
}

/* Polygon */
- (void)testSingaporeCoordinatesGeocodesSingapore
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(1.352083, 103.819839);
    APReverseGeocoding *geocoding = [APReverseGeocoding defaultGeocoding];
    APCountry *country = [geocoding geocodeCountryWithCoordinate:coordinate];

    XCTAssertTrue([country.code isEqualToString:@"SGP"]);
}

/* Polygon */
- (void)testHongkongCoordinatesGeocodesHongkong
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(22.396427, 114.109497);
    APReverseGeocoding *geocoding = [APReverseGeocoding defaultGeocoding];
    APCountry *country = [geocoding geocodeCountryWithCoordinate:coordinate];
    
    XCTAssertTrue([country.code isEqualToString:@"HKG"]);
}

- (void)testPerformanceNewYorkGeocoding {

    [self measureBlock:^{
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(40.7142700, -74.0059700);
        APReverseGeocoding *geocoding = [APReverseGeocoding defaultGeocoding];
        [geocoding geocodeCountryWithCoordinate:coordinate];
    }];
}

@end
