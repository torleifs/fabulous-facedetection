//
//  ViewController.m
//  FindFaces
//
//  Created by Torleif Sandnes on 14/12/2017.
//  Copyright © 2017 Telenor Capture AS. All rights reserved.
//

#import "ViewController.h"
#include <stdlib.h>

using namespace std;
using namespace cv;
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import <opencv2/highgui/ios.h>
#endif

const Scalar RED = Scalar(0, 0, 255);

@interface ViewController () {
    UIImageView *liveView;
    CvVideoCamera *videoCamera;
    CascadeClassifier face_cascade, eye_cascade;
    vector<cv::Rect> faces, eyes;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int viewWidth = self.view.frame.size.width;
    int viewHeight = (352*viewWidth)/288;
    int viewOffset = (self.view.frame.size.height - viewHeight) /2;
    liveView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, viewOffset, viewWidth, viewHeight)];
    [self.view addSubview:liveView];
    videoCamera = [[CvVideoCamera alloc] initWithParentView:liveView];
    videoCamera.delegate = self;
    
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self->videoCamera.rotateVideo = YES;
    
    NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt" ofType:@"xml"];
    const CFIndex CASCADE_NAME_LEN = 2048;
    char *CASCADE_NAME= (char *)malloc(CASCADE_NAME_LEN);
    CFStringGetFileSystemRepresentation((CFStringRef)faceCascadePath, CASCADE_NAME, CASCADE_NAME_LEN);
    if (!face_cascade.load(CASCADE_NAME)) {
        cout << "Unable to load cascade path" << endl;
        exit(-1);
    }
    [videoCamera start];
}

- (void)processImage:(cv::Mat &)image {
    Mat gray; cvtColor(image, gray,CV_RGBA2GRAY);
    face_cascade.detectMultiScale(gray, faces, 1.1, 2, 0 | CV_HAAR_SCALE_IMAGE, cv::Size(50, 50));
    if (faces.size() > 0) {
        for(int i = 0; i < faces.size(); i++) {
            //rectangle(image, faces[i], RED);
            GaussianBlur(image(faces[i]), image(faces[i]), cv::Size(0,0), 8);
            cv::putText(image,
                        "Inappropriate",
                        cv::Point(faces[i].x,faces[i].y), // Coordinates
                        cv::FONT_HERSHEY_SIMPLEX, // Font
                        0.25, // Scale. 2.0 = 2x bigger
                        cv::Scalar(255,0,0), // Color
                        0.5, // Thickness
                        CV_AA); // Anti-alias
//            cv::GaussianBlur(image(region), image(region), Size(0, 0), 4);
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
