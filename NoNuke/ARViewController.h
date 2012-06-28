//
//  ARViewController.h
//  NoNuke
//
//  Created by Paul Wu on 12/6/28.
//  Copyright (c) 2012年 Prodisky. All rights reserved.
//

enum {
	NukeStatusNone,
	NukeStatus1,
	NukeStatus2,
	NukeStatus3,
	NukeStatus4
};
typedef NSUInteger NukeStatus;

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NukeView.h"
@interface ARViewController : UIViewController <CLLocationManagerDelegate>
@property (nonatomic) NukeStatus nukeStatus;
@end
