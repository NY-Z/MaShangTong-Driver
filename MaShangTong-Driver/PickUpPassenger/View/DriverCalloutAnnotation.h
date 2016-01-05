//
//  DriverCalloutAnnotation.h
//  MaShangTong-Driver
//
//  Created by NY on 15/11/20.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverCalloutAnnotation : NSObject <MAAnnotation>

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;


//@property(retain,nonatomic) NSDictionary *locationInfo;

@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *distance;

- (id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon;

@end
