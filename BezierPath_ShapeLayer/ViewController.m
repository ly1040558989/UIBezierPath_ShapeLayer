//
//  ViewController.m
//  BezierPath_ShapeLayer
//
//  Created by 汤来友 on 2017/10/24.
//  Copyright © 2017年 Teonardo. All rights reserved.
//

#import "ViewController.h"

/** 圆弧的半径 */
#define kArcRadius 10

#define kNodeWidth 50

#define kNodeHorizontalSpacing 40

typedef NS_ENUM(NSInteger, LineType) {
    LineTypeCircular,
    LineTypeRectangular
};

@interface ViewController ()

@property (nonatomic, strong) NSArray *pointArray1;
@property (nonatomic, strong) NSArray *pointArray2;

@property (nonatomic, assign) CGPoint mainPoint;

@end

@implementation ViewController

- (NSArray *)pointArray1 {
    if (!_pointArray1) {
        NSMutableArray *tempArr = [NSMutableArray array];
        CGFloat x = self.mainPoint.x + kNodeHorizontalSpacing;
        [tempArr addObject:[NSValue valueWithCGPoint:CGPointMake(x, 100)]];
        [tempArr addObject:[NSValue valueWithCGPoint:CGPointMake(x, 200)]];
        [tempArr addObject:[NSValue valueWithCGPoint:CGPointMake(x, 300)]];
        [tempArr addObject:[NSValue valueWithCGPoint:CGPointMake(x, 400)]];
        [tempArr addObject:[NSValue valueWithCGPoint:CGPointMake(x, 500)]];
        _pointArray1 = [NSArray arrayWithArray:tempArr];
    }
    return _pointArray1;
}

- (NSArray *)pointArray2 {
    if (!_pointArray2) {
        NSMutableArray *tempArr = [NSMutableArray array];
        CGFloat x = self.mainPoint.x + kNodeHorizontalSpacing + kNodeWidth + kNodeHorizontalSpacing;
        [tempArr addObject:[NSValue valueWithCGPoint:CGPointMake(x, 140)]];
        [tempArr addObject:[NSValue valueWithCGPoint:CGPointMake(x, 200)]];
        [tempArr addObject:[NSValue valueWithCGPoint:CGPointMake(x, 260)]];
        _pointArray2 = [NSArray arrayWithArray:tempArr];
    }
    return _pointArray2;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mainPoint = CGPointMake(100, 300);
    [self drawLine];
    
    [self _addView];
    
}

- (void)drawLine {
    for (NSValue *value in self.pointArray1) {
        [self _addLineFromPoint:self.mainPoint toPoint:value.CGPointValue lineType:LineTypeCircular];
    }
    for (NSValue *value in self.pointArray2) {
        [self _addLineFromPoint:CGPointMake(self.mainPoint.x + kNodeHorizontalSpacing + kNodeWidth, 200) toPoint:value.CGPointValue lineType:LineTypeRectangular];
    }
}

- (void)_addView {
    
    UIView *view = [[UIView alloc] init];
    view.bounds = CGRectMake(0, 0, kNodeWidth, 40);
    view.center = CGPointMake(self.mainPoint.x - 25, self.mainPoint.y);
    view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view];
    
    for (NSValue *value in self.pointArray1) {
        [self _addViewWithPoint:value.CGPointValue];
    }
    
    for (NSValue *value in self.pointArray2) {
        [self _addViewWithPoint:value.CGPointValue];
    }
    
}

- (void)_addViewWithPoint:(CGPoint)point {
    UIView *tempView = [[UIView alloc] init];
    tempView.bounds = CGRectMake(0, 0, 50, 40);
    tempView.center = CGPointMake(point.x + 25, point.y);
    tempView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:tempView];
}


- (void)_addLineFromPoint:(CGPoint)origin toPoint:(CGPoint)destination lineType:(LineType)type{
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.lineWidth = 2;
    shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path;
    switch (type) {
        case LineTypeCircular:
        {
            path = [self circularPathFromPoint:origin toPoint:destination];
            break;
        }
        case LineTypeRectangular:
        {
            path = [self rectangularPathFromPoint:origin toPoint:destination];
            break;
        }
            
        default:
            break;
    }
    
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
}


- (UIBezierPath *)circularPathFromPoint:(CGPoint)origin toPoint:(CGPoint)destination {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:origin];
    
    if (destination.y != origin.y) {
        CGFloat xOffset = destination.x - origin.x;
        CGPoint rightAngledPoint = CGPointMake(origin.x + xOffset / 2, origin.y);
        CGPoint circularLeftPoint,controlPoint, circularRightPoint;
        if (destination.y > origin.y) {
            circularLeftPoint = CGPointMake(origin.x + xOffset / 2, destination.y - kArcRadius);
        } else {
            circularLeftPoint = CGPointMake(origin.x + xOffset / 2, destination.y + kArcRadius);
        }
        circularRightPoint = CGPointMake(origin.x + xOffset / 2 + kArcRadius, destination.y);
        controlPoint = CGPointMake(origin.x + xOffset / 2, destination.y);
        
        [path addLineToPoint:rightAngledPoint];
        [path addLineToPoint:circularLeftPoint];
        [path addQuadCurveToPoint:circularRightPoint controlPoint:controlPoint];
       
    }
    [path addLineToPoint:destination];
    return path;
}

- (UIBezierPath *)rectangularPathFromPoint:(CGPoint)origin toPoint:(CGPoint)destination {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:origin];
    
    if (destination.y != origin.y) {
        CGFloat xOffset = destination.x - origin.x;
        CGPoint inflectionPoint1, inflectionpoint2;
        inflectionPoint1 = CGPointMake(origin.x + xOffset / 2, origin.y);
        inflectionpoint2 = CGPointMake(origin.x + xOffset / 2, destination.y);
        
        [path addLineToPoint:inflectionPoint1];
        [path addLineToPoint:inflectionpoint2];
    }
     [path addLineToPoint:destination];
    
    return path;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
