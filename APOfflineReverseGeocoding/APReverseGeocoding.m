//
//  APReverseGeocoding.m
//  APReverseGeocodingExample
//
//  Created by Sergii Kryvoblotskyi on 4/15/15.
//  Copyright (c) 2015 Sergii Kryvoblotskyi. All rights reserved.
//

#import "APReverseGeocoding.h"
#import "APPolygon.h"

static NSString *const APReverseGeocodingDefaultDBName = @"countries.geo";
static NSString *const APReverseGeocodingCountriesKey  = @"features";

@interface APReverseGeocoding ()

@property (nonatomic, strong, readwrite) NSArray *countries;
@property (nonatomic, strong, readwrite) NSDictionary *geoJSON;

@end

@implementation APReverseGeocoding

+ (instancetype)defaultGeocoding
{
    NSURL *url = nil;
    NSBundle *bundle = nil;
    
#if SWIFT_PACKAGE
    // Swift Package Manager: try to find the resource bundle by name
    // SPM creates a bundle with the pattern: {PackageName}_{TargetName}.bundle
    NSString *bundleName = @"APOfflineReverseGeocoding_APOfflineReverseGeocoding";
    
    // Try main bundle first
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
    if (bundleURL == nil) {
        // Try class bundle
        bundleURL = [[NSBundle bundleForClass:[self class]] URLForResource:bundleName withExtension:@"bundle"];
    }
    if (bundleURL != nil) {
        bundle = [NSBundle bundleWithURL:bundleURL];
        url = [bundle URLForResource:APReverseGeocodingDefaultDBName withExtension:@"json"];
    }
    
    // Also try main bundle and class bundle directly (SPM sometimes puts resources there)
    if (url == nil) {
        url = [[NSBundle mainBundle] URLForResource:APReverseGeocodingDefaultDBName withExtension:@"json"];
    }
    if (url == nil) {
        NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
        url = [classBundle URLForResource:APReverseGeocodingDefaultDBName withExtension:@"json"];
    }
#endif
    
    // Fallback to class bundle (for CocoaPods or manual integration)
    if (url == nil) {
        bundle = [NSBundle bundleForClass:[self class]];
        url = [bundle URLForResource:APReverseGeocodingDefaultDBName withExtension:@"json"];
    }
    
    return [self geocodingWithGeoJSONURL:url];
}

- (instancetype)init
{
    return nil;
}

+ (instancetype)geocodingWithGeoJSONURL:(NSURL *)url
{
    return [[self alloc] initWithGeoJSONURL:url];
}

- (instancetype)initWithGeoJSONURL:(NSURL *)url
{
    NSParameterAssert(url);
    self = [super init];
    if (self) {
        _url = url;
    }
    return self;
}

#pragma mark - Public

- (APCountry *)geocodeCountryWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    return [self _geocodeCountryWithCoordinate:coordinate];
}

#pragma mark - Private

- (APCountry *)_geocodeCountryWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSArray *countryData = self.countries;

    for (int i = 0; i < [countryData count]; i++){
        
        NSDictionary *countryDict = [countryData objectAtIndex:i];
        NSDictionary *geometry = [countryDict objectForKey:@"geometry"];
        NSString *geometryType = [geometry valueForKey:@"type"];
        NSArray *coordinates = [geometry objectForKey:@"coordinates"];
        
        /* Check the polygon type */
        if ([geometryType isEqualToString:@"Polygon"]) {
            
            /* Create the polygon */
            NSArray *polygonPoints  = [coordinates objectAtIndex:0];
            APPolygon *polygon = [APPolygon polygonWithPoints:polygonPoints];
            
            /* Cehck containment */
            if ([polygon containsLocation:coordinate]) {
                return [APCountry countryWithGEODictionary:countryDict];
            }

        /* Loop through all sub-polygons and make the checks */
        } else if([geometryType isEqualToString:@"MultiPolygon"]){
            for (int j = 0; j < [coordinates count]; j++){
                
                NSArray *polygonPoints = [[coordinates objectAtIndex:j] objectAtIndex:0];
                APPolygon *polygon = [APPolygon polygonWithPoints:polygonPoints];
                
                if([polygon containsLocation:coordinate]) {
                    return [APCountry countryWithGEODictionary:countryDict];
                }
            }
        }
    }
    return nil;
}

#pragma mark - Lazy Accessors

- (NSArray *)countries
{
    if (!_countries) {
        _countries = self.geoJSON[APReverseGeocodingCountriesKey];
    }
    return _countries;
}

- (NSDictionary *)geoJSON
{
    if (!_geoJSON) {
        
        NSError *error = nil;
        NSData *jsonData = [[NSData alloc] initWithContentsOfURL:self.url];
        NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        if (!error) {
            _geoJSON = [parsedJSON copy];
        } else {
            [NSException raise:@"Cannot parse JSON." format:@"JSON URL - %@\nError:%@", self.url, error];
        }
    }
    return _geoJSON;
}

@end
