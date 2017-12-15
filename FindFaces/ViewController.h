//
//  ViewController.h
//  FindFaces
//
//  Created by Torleif Sandnes on 14/12/2017.
//  Copyright © 2017 Telenor Capture AS. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import <opencv2/highgui/ios.h>
#endif

@interface ViewController : UIViewController<CvVideoCameraDelegate>
@end

