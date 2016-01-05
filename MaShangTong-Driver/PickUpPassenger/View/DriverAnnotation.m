//
//  DriverAnnotation.m
//  MaShangTong-Driver
//
//  Created by NY on 15/11/20.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "DriverAnnotation.h"

@implementation DriverAnnotation

- (id)initWithLatitude:(CLLocationDegrees)lat
          andLongitude:(CLLocationDegrees)lon {
    if (self = [super init]) {
        self.latitude = lat;
        self.longitude = lon;
    }
    return self;
}

-(CLLocationCoordinate2D)coordinate{
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
    
    
}

@end
