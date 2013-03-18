//
//  ARViewController.m
//  NoNuke
//
//  Created by Paul Wu on 12/6/28.
//  Copyright (c) 2012年 Prodisky. All rights reserved.
//

#import "ARViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <QuartzCore/QuartzCore.h>
@interface ARViewController () {
	UILabel *messageLabel;
	UILabel *runawayLabel;
	CLLocationManager *locationManager;
	UIImagePickerController *imagePicker;
	NukeView *n1, *n2, *n3, *n4;
	CLLocation *currentLocation;
	CGFloat magneticHeading;
	
	CMMotionManager *motionManager;
	CGFloat rotationAngle;
}
@end

@implementation ARViewController
@synthesize nukeStatus;
- (void)showAlert:(NSString*)title
		  message:(NSString*)message {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
	[alertView show];
}
- (void)updateInfo {
	if (currentLocation == nil) return;
	[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
		[n1 renewByRotationAngle:rotationAngle
				 magneticHeading:magneticHeading
				 currentLocation:currentLocation];
		[n2 renewByRotationAngle:rotationAngle
				 magneticHeading:magneticHeading
				 currentLocation:currentLocation];
		[n3 renewByRotationAngle:rotationAngle
				 magneticHeading:magneticHeading
				 currentLocation:currentLocation];
		[n4 renewByRotationAngle:rotationAngle
				 magneticHeading:magneticHeading
				 currentLocation:currentLocation];
		
		if (nukeStatus != NukeStatusNone) {
			CLLocation *location;
			switch (nukeStatus) {
				case NukeStatus1:
					location = n1.location;
					break;
				case NukeStatus2:
					location = n2.location;
					break;
				case NukeStatus3:
					location = n3.location;
					break;
				case NukeStatus4:
					location = n4.location;
					break;
			}
			
			CGFloat angle = atan2(location.coordinate.latitude - currentLocation.coordinate.latitude, location.coordinate.longitude - currentLocation.coordinate.longitude);
			
			//*
			CGFloat heading = - magneticHeading * M_PI / 180 - angle;
			heading += M_PI / 2;
			heading += M_PI;
			
			while (heading > 2 * M_PI) heading -= 2 * M_PI;
			while (heading < 0) heading += 2 * M_PI;
			
			CGFloat pointX = 160;
			if (cos(heading) < 0) pointX = 480;
			else pointX += sin(heading) * 320;
			//*/
			//CGFloat heading = -(magneticHeading * M_PI / 180) + angle;
			//CGFloat pointX = -160 + atan(heading) * 320;
			//while (pointX > 480) pointX -= 640;
			
			runawayLabel.center = CGPointMake(pointX, 240 - sin(rotationAngle) * 480);
		}
	} completion:nil];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.view.backgroundColor = [UIColor clearColor];
		
		nukeStatus = NukeStatusNone;
		messageLabel = [UILabel new];
		messageLabel.alpha = 0;
		messageLabel.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.6];
		messageLabel.textColor = [UIColor whiteColor];
		messageLabel.textAlignment = UITextAlignmentCenter;
		messageLabel.adjustsFontSizeToFitWidth = YES;
		messageLabel.font = [UIFont boldSystemFontOfSize:28];
		messageLabel.frame = CGRectMake(0, 0, 320, 32);
		[self.view addSubview:messageLabel];
		
		
		runawayLabel = [UILabel new];
		runawayLabel.alpha = 0;
		runawayLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
		runawayLabel.textColor = [UIColor whiteColor];
		runawayLabel.textAlignment = UITextAlignmentCenter;
		runawayLabel.adjustsFontSizeToFitWidth = YES;
		runawayLabel.font = [UIFont boldSystemFontOfSize:32];
		runawayLabel.frame = CGRectMake(0, 0, 160, 50);
		runawayLabel.layer.cornerRadius = 25;
		runawayLabel.text = NSLocalizedString(@"避難方向",nil);
		[self.view addSubview:runawayLabel];
		
		
		//破	24.169681 120.658773
		
		//核一廠
		n1 = [NukeView new];
		n1.name = NSLocalizedString(@"核一廠",nil);
		n1.location = [[CLLocation alloc] initWithLatitude:25.286320 longitude:121.588211];
		
		//核二廠
		n2 = [NukeView new];
		n2.name = NSLocalizedString(@"核二廠",nil);
		n2.location = [[CLLocation alloc] initWithLatitude:25.179970 longitude:121.689476];
		
		//核三廠
		n3 = [NukeView new];
		n3.name = NSLocalizedString(@"核三廠",nil);
		n3.location = [[CLLocation alloc] initWithLatitude:21.947792 longitude:120.744102];
		
		//核四廠(興建中)
		n4 = [NukeView new];
		n4.name = NSLocalizedString(@"核四廠",nil);
		n4.location = [[CLLocation alloc] initWithLatitude:25.126156 longitude:121.817619];
		
		n1.offsetY = -52;
		n2.offsetY = 0;
		n3.offsetY = 0;
		n4.offsetY = 52;
		
		[self.view addSubview:n1];
		[self.view addSubview:n2];
		[self.view addSubview:n3];
		[self.view addSubview:n4];
		
		
		currentLocation = nil;
		
		locationManager = [CLLocationManager new]; 
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
		locationManager.distanceFilter = defaultDistanceFilter;
		locationManager.headingFilter = defaultHeadingFilter;
		
		[locationManager startUpdatingLocation];
		[locationManager startUpdatingHeading];
		magneticHeading = 0;
		
		rotationAngle = 0;
		
		motionManager = [CMMotionManager new];
		if (motionManager.accelerometerAvailable) {
			motionManager.accelerometerUpdateInterval = 0.5;
			[motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *data, NSError *error) {
				rotationAngle = atan2(data.acceleration.z, data.acceleration.y) - M_PI;
				while (rotationAngle > M_PI) rotationAngle -= 2 * M_PI;
				while (rotationAngle < -M_PI) rotationAngle += 2 * M_PI;
				[self updateInfo];
			}];
		}
	}
	return self;
}
- (void)viewDidAppear:(BOOL)animated {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		imagePicker = [UIImagePickerController new];
		imagePicker.navigationBarHidden = YES;
        imagePicker.toolbarHidden = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.showsCameraControls = NO;
        imagePicker.cameraOverlayView = self.view;
		CGFloat scal = [[UIScreen mainScreen] bounds].size.height / 384;
		imagePicker.cameraViewTransform = CGAffineTransformMakeScale(scal, scal);
		[self presentModalViewController:imagePicker animated:NO];
	}
}
- (void)setNukeStatus:(NukeStatus)status {
	nukeStatus = status;
	[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
		switch (nukeStatus) {
			case NukeStatusNone:
				messageLabel.alpha = 0;
				runawayLabel.alpha = 0;
				break;
			case NukeStatus1:
			case NukeStatus2:
			case NukeStatus3:
			case NukeStatus4:
				messageLabel.alpha = 1;
				runawayLabel.alpha = 1;
				break;
		}
		switch (nukeStatus) {
			case NukeStatusNone:
				messageLabel.text = @"";
				break;
			case NukeStatus1:
				messageLabel.text = [NSString stringWithFormat:@"%@發生事故",n1.name];
				break;
			case NukeStatus2:
				messageLabel.text = [NSString stringWithFormat:@"%@發生事故",n2.name];
				break;
			case NukeStatus3:
				messageLabel.text = [NSString stringWithFormat:@"%@發生事故",n3.name];
				break;
			case NukeStatus4:
				messageLabel.text = [NSString stringWithFormat:@"%@發生事故",n4.name];
				break;
		}
	} completion:nil];
	[self updateInfo];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
	magneticHeading = newHeading.magneticHeading;
	[self updateInfo];
}
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    return YES;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	currentLocation = newLocation;
	[self updateInfo];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if ([CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorized) {
		[self showAlert:NSLocalizedString(@"Can't get current location",nil)
				message:NSLocalizedString(@"Please check your settings for location services",nil)];
		[manager stopUpdatingLocation];
	}
}
@end
