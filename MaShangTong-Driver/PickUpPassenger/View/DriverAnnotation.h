//
//  DriverAnnotation.h
//  MaShangTong-Driver
//
//  Created by NY on 15/11/20.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapNaviKit/AMapNaviKit.h>

@interface DriverAnnotation : NSObject <MAAnnotation>

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;


@property(retain,nonatomic) NSDictionary *locationInfo;

- (id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon;

@end
