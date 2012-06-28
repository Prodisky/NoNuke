//
//  NukeView.h
//  NoNuke
//
//  Created by Paul Wu on 12/6/28.
//  Copyright (c) 2012年 Prodisky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface NukeView : UIView
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic) CGFloat offsetY;
- (void)renew:(CGFloat)rotationAngle:(CGFloat)magneticHeading:(CLLocation *)currentLocation;
@end
