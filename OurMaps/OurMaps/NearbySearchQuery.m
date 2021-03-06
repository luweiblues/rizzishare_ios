//
//  NearbySearchQuery.m
//  OurMaps
//
//  Created by Jiangchuan Huang on 9/6/14.
//  Copyright (c) 2014 OurMaps. All rights reserved.
//

#import "NearbySearchQuery.h"
#import "Place.h"
#import <Parse/Parse.h>

@interface NearbySearchQuery()
@property (nonatomic, copy, readwrite) NearbySearchResultBlock resultBlock;
@property (nonatomic, copy, readwrite) NearbySearchResultBlock eventResultBlock;
@end


@implementation NearbySearchQuery

@synthesize sensor, key, location, radius, language, types, resultBlock;

+ (NearbySearchQuery *)query {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        // Setup default property values.
        self.sensor = YES;
        self.key = kGoogleAPIKey;
        self.location = CLLocationCoordinate2DMake(-1, -1);
        self.radius = NSNotFound;
        self.types = -1;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Nearby Search Query URL: %@", [self googleURLString]];
}


- (NSString *)googleURLString {
    NSMutableString *url = [NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?sensor=%@&key=%@", BooleanStringForBool(sensor), key];
    if (location.latitude != -1) {
        [url appendFormat:@"&location=%f,%f", location.latitude, location.longitude];
    }
    if (radius != NSNotFound) {
        [url appendFormat:@"&radius=%f", radius];
    }
    if (language) {
        [url appendFormat:@"&language=%@", language];
    }
    if (types != -1) {
        [url appendFormat:@"&types=%@", PlaceTypeStringForPlaceType(types)];
    }
    //NSLog(@"innnnn");
    return url;
}

- (void)cleanup {
    googleConnection = nil;
    responseData = nil;
    self.resultBlock = nil;
}

- (void)cancelOutstandingRequests {
    [googleConnection cancel];
    [self cleanup];
}

- (void)fetchNearbyPlaces:(NearbySearchResultBlock)block {
    //    if (!EnsureGoogleAPIKey()) {
    //        return;
    //    }
    
    [self cancelOutstandingRequests];
    self.resultBlock = block;
    
    NSLog(@"innn");
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self googleURLString]]];
    googleConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    responseData = [[NSMutableData alloc] init];
}

- (NSArray *)fetchNearbyPlacesSync {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self googleURLString]]];
    
    NSError *error = [[NSError alloc] init];
    NSURLResponse *response = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSArray *placeArray = [self processDataAfterLoading:urlData];
    
    return placeArray;
}

- (void)fetchNearbyPlacesForEvents:(NearbySearchResultBlock)block {
    //self.resultBlock = block;
    self.eventResultBlock = block;
    
    PFQuery *nearbyPlaceQuery = [PFQuery queryWithClassName:kPlaceClassKey];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:self.location.latitude longitude:self.location.longitude];
    
    [nearbyPlaceQuery whereKey:kPlaceGeoLocationKey nearGeoPoint:geoPoint withinKilometers:self.radius/1000];
    
    PFQuery *eventQuery = [PFQuery queryWithClassName:kEventClassKey];
    [eventQuery whereKey:kEventVenueKey matchesQuery:nearbyPlaceQuery];
    [eventQuery includeKey:kEventVenueKey];
    [eventQuery includeKey:kEventOwnerKey];
//    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error) {
//        if (!error) {
//            NSLog(@"successfully fetched %lu nearby events", events.count);
//            
//            if (self.eventResultBlock != nil) {
//                self.eventResultBlock(events, nil);
//            }
//            self.eventResultBlock = nil;
//            //[self cleanup];
//        }
//    }];
    
    NSError *localError = nil;
    
    NSArray *events = [eventQuery findObjects:&localError];
    NSLog(@"localError: %@", localError);
    if (self.eventResultBlock != nil) {
        self.eventResultBlock(events, nil);
    }
    self.eventResultBlock = nil;
    
    // Nearby places query
    
    // Event query - events in nearby places
    
    // for (e in eventQuery)
    //      for (v in venueQuery)
    //          if (e.v == v) [v.eventArray addobject]
}


#pragma mark -
#pragma mark NSURLConnectionDataDelegate

- (void)failWithError:(NSError *)error {
    //NSLog(@"innnnnE");
    if (self.resultBlock != nil) {
        self.resultBlock(nil, error);
    }
    [self cleanup];
}

- (void)succeedWithPlaces:(NSArray *)places {
    NSMutableArray *nearbyPlaces = [NSMutableArray array];
    
    NSMutableArray *placesToUpload = [NSMutableArray array];
    
    for (NSDictionary *place in places) {
        Place *aPlace = [Place placeFromNearbySearchDictionary:place];
        [nearbyPlaces addObject: aPlace];
        
        //PFObject *parsePlace = [PFObject objectWithClassName:kPlaceClassKey dictionary:place];
        PFObject *parsePlace = [self parsePlaceFromPlace:aPlace];
        
        [placesToUpload addObject:parsePlace];
        
    }
    
    //[PFObject saveAllInBackground:placesToUpload];

    
    if (self.resultBlock != nil) {
        self.resultBlock(nearbyPlaces, nil);
    }
    [self cleanup];
}

- (NSArray *)buildPlacesWithDics:(NSArray *)places {
    NSMutableArray *nearbyPlaces = [NSMutableArray array];
    
    NSMutableArray *placesToUpload = [NSMutableArray array];
    
    for (NSDictionary *place in places) {
        Place *aPlace = [Place placeFromNearbySearchDictionary:place];
        [nearbyPlaces addObject: aPlace];
        
        //PFObject *parsePlace = [PFObject objectWithClassName:kPlaceClassKey dictionary:place];
        PFObject *parsePlace = [self parsePlaceFromPlace:aPlace];
        
        [placesToUpload addObject:parsePlace];
        
    }
    
    //[PFObject saveAllInBackground:placesToUpload];
    
    return nearbyPlaces;
}

- (PFObject *)parsePlaceFromPlace:(Place *)aPlace {
    PFObject *parsePlace = [PFObject objectWithClassName:kPlaceClassKey];
    PFGeoPoint *geoPoint = [[PFGeoPoint alloc] init];
    geoPoint.latitude = aPlace.coordinate.latitude;
    geoPoint.longitude = aPlace.coordinate.longitude;

    parsePlace[kPlaceGeoLocationKey] = geoPoint;
    parsePlace[kPlaceNameKey] = aPlace.name;
    parsePlace[kPlaceIdKey] = aPlace.place_id;
    parsePlace[kPlaceOverallRatingKey] = [NSNumber numberWithFloat:aPlace.rating];
    
    
    return parsePlace;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"innnnn1");
    if (connection == googleConnection) {
        [responseData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connnection didReceiveData:(NSData *)data {
    NSLog(@"innnnn2");
    if (connnection == googleConnection) {
        [responseData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"innnnn3");
    if (connection == googleConnection) {
        [self failWithError:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"innnnn4");
    if (connection == googleConnection) {
        NSError *error = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        
        
        if (error) {
            [self failWithError:error];
            return;
        }
        if ([[response objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]) {
            [self succeedWithPlaces:[NSArray array]];
            return;
        }
        if ([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
            [self succeedWithPlaces:[response objectForKey:@"results"]];
            return;
        }
        
        // Must have received a status of OVER_QUERY_LIMIT, REQUEST_DENIED or INVALID_REQUEST.
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[response objectForKey:@"status"] forKey:NSLocalizedDescriptionKey];
        [self failWithError:[NSError errorWithDomain:@"ourmaps.ourmaps" code:kGoogleAPINSErrorCode userInfo:userInfo]];
    
    }
}

- (NSArray *)processDataAfterLoading:(NSData *)data {
    NSError *error = nil;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSArray *placesArray = [[NSArray alloc] init];
    
    if (error) {
        //[self failWithError:error];
        return placesArray;
    }
    if ([[response objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]) {
        //placesArray = [self succeedWithPlaces:[NSArray array]];
        return placesArray;
    }
    if ([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
        //[self succeedWithPlaces:[response objectForKey:@"results"]];
        placesArray = [self buildPlacesWithDics:[response objectForKey:@"results"]];
        return placesArray;
    }
    
    // Must have received a status of OVER_QUERY_LIMIT, REQUEST_DENIED or INVALID_REQUEST.
    //NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[response objectForKey:@"status"] forKey:NSLocalizedDescriptionKey];
    //[self failWithError:[NSError errorWithDomain:@"ourmaps.ourmaps" code:kGoogleAPINSErrorCode userInfo:userInfo]];
    return placesArray;
}

@end
