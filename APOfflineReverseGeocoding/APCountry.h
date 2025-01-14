//
//  APCountry.h
//  APReverseGeocodingExample
//
//  Created by Sergii Kryvoblotskyi on 4/15/15.
//  Copyright (c) 2015 Sergii Kryvoblotskyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APCountry : NSObject

/**
 *  Convenience initializer
 *
 *  @param dictionary NSDictionary with json data. See more here:
 *  https://github.com/johan/world.geo.json
 *
 *  @return APCountry
 */
+ (instancetype _Nonnull)countryWithGEODictionary:(NSDictionary * _Nonnull)dictionary;

/**
 *  Designated initializer.
 *
 *  @param dictionary NSDictionary See +countryWithGEODictionary:(NSDictionary *)
 *
 *  @return APCountry
 */
- (instancetype _Nullable)initWithGeoDictionary:(NSDictionary * _Nonnull)dictionary NS_DESIGNATED_INITIALIZER;

/* Represents country 3 digits code ISO 3166-1 Alpha 3 */
@property (nonatomic, copy, readonly, nullable) NSString *code;

/* Represents country 2 digits code ISO 3166-1 Alpha 2 */
@property (nonatomic, copy, readonly, nullable) NSString *shortCode;

/* Represents country name */
@property (nonatomic, copy, readonly, nullable) NSString *name;

/* Represents country name in current locale */
@property (nonatomic, copy, readonly, nullable) NSString *localizedName;

/* Represents country currency code */
@property (nonatomic, copy, readonly, nullable) NSString *currencyCode;

/* Represents country currency symbol */
@property (nonatomic, copy, readonly, nullable) NSString *currencySymbol;

/* Represents country calendar */
@property (nonatomic, strong, readonly, nullable) NSCalendar *calendar;

@end

@interface APCountry (Unavailable)

- (instancetype _Nullable)init NS_UNAVAILABLE;
+ (instancetype _Nullable)new NS_UNAVAILABLE;

@end
