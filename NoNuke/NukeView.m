//
//  NukeView.m
//  NoNuke
//
//  Created by Paul Wu on 12/6/28.
//  Copyright (c) 2012年 Prodisky. All rights reserved.
//

#import "NukeView.h"
#import <QuartzCore/QuartzCore.h>
@interface NukeView () {
	UIImageView *icon;
	UILabel *nameLabel;
	UILabel *infoLabel;
}
@end

@implementation NukeView
@synthesize name;
@synthesize location;
@synthesize offsetY;
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		name = @"";
		offsetY = 0;
		self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
		self.frame = CGRectMake(0, -100, 168, 52);
		self.layer.cornerRadius = 26;

		icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Nuke.png"]];
		icon.frame = CGRectMake(0, 0, 52, 52);
		
		nameLabel = [UILabel new];
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.textColor = [UIColor whiteColor];
		nameLabel.textAlignment = UITextAlignmentCenter;
		nameLabel.adjustsFontSizeToFitWidth = YES;
		nameLabel.font = [UIFont boldSystemFontOfSize:14];
		nameLabel.frame = CGRectMake(55, 6, 100, 20);
		
		infoLabel = [UILabel new];
		infoLabel.backgroundColor = [UIColor clearColor];
		infoLabel.textColor = [UIColor whiteColor];
		infoLabel.textAlignment = UITextAlignmentCenter;
		infoLabel.adjustsFontSizeToFitWidth = YES;
		infoLabel.font = [UIFont boldSystemFontOfSize:14];
		infoLabel.frame = CGRectMake(55, 26, 100, 20);
		
		[self addSubview:icon];
		[self addSubview:nameLabel];
		[self addSubview:infoLabel];
    }
    return self;
}
- (void)setName:(NSString *)newName {
	name = newName;
	nameLabel.text = name;
}
#pragma mark
- (void)renewByRotationAngle:(CGFloat)rotationAngle
			 magneticHeading:(CGFloat)magneticHeading
			 currentLocation:(CLLocation *)currentLocation {
	CGFloat angle = atan2(self.location.coordinate.latitude - currentLocation.coordinate.latitude, self.location.coordinate.longitude - currentLocation.coordinate.longitude);
	
	CGFloat heading = - magneticHeading * M_PI / 180 - angle;
	heading += M_PI / 2;
	
	while (heading > 2 * M_PI) heading -= 2 * M_PI;
	while (heading < 0) heading += 2 * M_PI;
	
	CGFloat pointX = 160;
	if (cos(heading) < 0) pointX = 480;
	else pointX += sin(heading) * 320;

	self.center = CGPointMake(pointX, offsetY + ([[UIScreen mainScreen] bounds].size.height / 2) - sin(rotationAngle) * 480);
	
	infoLabel.text = [NSString stringWithFormat:@"距離：%0.2f公里", [currentLocation distanceFromLocation:self.location]/1000];
}
@end
