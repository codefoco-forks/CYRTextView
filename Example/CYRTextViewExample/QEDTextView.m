//
//  QEDTextView.m
//  CYRTextViewExample
//
//  Created by Illya Busigin on 1/10/14.
//  Copyright (c) 2014 Cyrillian, Inc. All rights reserved.
//

#import "QEDTextView.h"

#import <CoreText/CoreText.h>

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

@implementation QEDTextView

#pragma mark - Initialization & Setup


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self commonSetup];
    }
    
    return self;
}

- (void)commonSetup
{
    _defaultFont = [UIFont systemFontOfSize:14.0f];
    _boldFont = [UIFont boldSystemFontOfSize:14.0f];
    _italicFont = [UIFont fontWithName:@"HelveticaNeue-Oblique" size:14.0f];
    
    self.font = _defaultFont;
    self.textColor = [UIColor blackColor];

    
    if (_italicFont == nil && ([UIFontDescriptor class] != nil))
    {
        // This works around a bug in 7.0.3 where HelveticaNeue-Italic is not present as a UIFont option
        _italicFont = (__bridge_transfer UIFont*)CTFontCreateWithName(CFSTR("HelveticaNeue-Italic"), 14.0f, NULL);
    }
    
    self.tokens = [self solverTokens];
}


-(id)awakeAfterUsingCoder: (NSCoder*)aDecoder
{
   return [[QEDTextView alloc]initWithFrame: self.frame];
}


- (NSArray *)solverTokens
{
    NSArray *solverTokens =  @[
                               [[CYRToken new] initWithName:@"special_numbers"
                                                expression:@"[ʝ]"
                                                foregroundColor:RGB(0, 0, 255)],
                               [[CYRToken new] initWithName:@"mod"
                                                expression:@"\bmod\b"
                                       foregroundColor: RGB(245,0, 110)
                                                             ],
                               [[CYRToken new] initWithName:@"string"
                                                expression:@"\".*?(\"|$)"
                                                foregroundColor:RGB(24, 110, 109)
                                                             ],
                               [[CYRToken new] initWithName:@"hex_1"
                                                expression:@"\\$[\\d a-f]+"
                                                foregroundColor:RGB(0, 0, 255)
                                                             ],
                               [[CYRToken new] initWithName:@"octal_1"
                                                expression:@"&[0-7]+"
                                                foregroundColor: RGB(0, 0, 255)
                                                             ],
                               [[CYRToken new] initWithName:@"binary_1"
                                                expression:@"%[01]+"
                                                foregroundColor:RGB(0, 0, 255)
                                                             ],
                               [[CYRToken new] initWithName:@"hex_2"
                                                expression:@"0x[0-9 a-f]+"
                                                foregroundColor:RGB(0, 0, 255)
                                                             ],
                               [[CYRToken new] initWithName:@"octal_2"
                                                expression:@"0o[0-7]+"
                                                foregroundColor: RGB(0, 0, 255)
                                                             ],
                               [[CYRToken new] initWithName:@"binary_2"
                                                expression:@"0b[01]+"
                                                foregroundColor: RGB(0, 0, 255)
                                                             ],
                               [[CYRToken new] initWithName:@"float"
                                                expression:@"\\d+\\.?\\d+e[\\+\\-]?\\d+|\\d+\\.\\d+|∞"
                                                foregroundColor:RGB(0, 0, 255)
                                                             ],
                               [[CYRToken new] initWithName:@"integer"
                                                expression:@"\\d+"
                                                foregroundColor:RGB(0, 0, 255)
                                                             ],
                               [[CYRToken new] initWithName:@"operator"
                                                expression:@"[/\\*,\\;:=<>\\+\\-\\^!·≤≥]"
                                                foregroundColor: RGB(245, 0, 110)
                                                             ],
                               [[CYRToken new] initWithName:@"round_brackets"
                                                expression:@"[\\(\\)]"
                                                foregroundColor: RGB(161, 75, 0)
                                                             ],
                               [[CYRToken new] initWithName:@"square_brackets"
                                                expression:@"[\\[\\]]"
                                                foregroundColor: RGB(105, 0, 0)
                                                             font : self.boldFont
                                                             ],
                               [[CYRToken new] initWithName:@"absolute_brackets"
                                                expression:@"[|]"
                                                foregroundColor:RGB(104, 0, 111)
                                                             ],
                               [[CYRToken new] initWithName:@"reserved_words"
                                                expression:@"(abs|acos|acosh|asin|asinh|atan|atanh|atomicweight|ceil|complex|cos|cosh|crandom|deriv|erf|erfc|exp|eye|floor|frac|gamma|gaussel|getconst|imag|inf|integ|integhq|inv|ln|log10|log2|machineprecision|max|maximize|min|minimize|molecularweight|ncum|ones|pi|plot|random|real|round|sgn|sin|sqr|sinh|sqrt|tan|tanh|transpose|trunc|var|zeros)"
                                                foregroundColor: RGB(104, 0, 111)
                                                             font : self.boldFont
                                                             ],
                               [[CYRToken new] initWithName:@"chart_parameters"
                                                expression:@"(chartheight|charttitle|chartwidth|color|seriesname|showlegend|showxmajorgrid|showxminorgrid|showymajorgrid|showyminorgrid|transparency|thickness|xautoscale|xaxisrange|xlabel|xlogscale|xrange|yautoscale|yaxisrange|ylabel|ylogscale|yrange)"
                                                foregroundColor:RGB(11, 81, 195)
                                                             ],
                               [[CYRToken new] initWithName:@"comment"
                                                expression:@"//.*"
                                                foregroundColor:RGB(31, 131, 0)
                                                             font : self.italicFont
                                                             ]
                               ];
    
    return solverTokens;
}


#pragma mark - Cleanup

- (void)dealloc
{

}




#pragma mark - Overrides

- (void)setDefaultFont:(UIFont *)defaultFont
{
    _defaultFont = defaultFont;
    self.font = defaultFont;
}

@end
