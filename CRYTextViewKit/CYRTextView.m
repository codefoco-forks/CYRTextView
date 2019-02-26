//
//  CYRTextView.m
//
//  Version 0.4.0
//
//  Created by Illya Busigin on 01/05/2014.
//  Copyright (c) 2014 Cyrillian, Inc.
//  Copyright (c) 2013 Dominik Hauser
//  Copyright (c) 2013 Sam Rijs
//
//  Distributed under MIT license.
//  Get the latest version from here:
//
//  https://github.com/illyabusigin/CYRTextView
//
// The MIT License (MIT)
//
// Copyright (c) 2014 Cyrillian, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "CYRTextView.h"
#import "CYRLayoutManager.h"
#import "CYRTextStorage.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]


@interface CYRTextView ()

@property (nonatomic, strong) CYRLayoutManager *lineNumberLayoutManager;


@end

@implementation CYRTextView
{
    NSRange startRange;
}

#pragma mark - Initialization & Setup

- (id)initWithFrame:(CGRect)frame
{
    CYRTextStorage *textStorage = [CYRTextStorage new];
    CYRLayoutManager *layoutManager = [CYRLayoutManager new];
    
    self.lineNumberLayoutManager = layoutManager;
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    
    //  Wrap text to the text view's frame
    textContainer.widthTracksTextView = YES;
    
    [layoutManager addTextContainer:textContainer];

    [textStorage removeLayoutManager:textStorage.layoutManagers.firstObject];
    [textStorage addLayoutManager:layoutManager];
    
    self.syntaxTextStorage = textStorage;
    
    if ((self = [super initWithFrame:frame textContainer:textContainer]))
    {
        self.contentMode = UIViewContentModeRedraw; // causes drawRect: to be called on frame resizing and device rotation
        
        [self _commonSetup];
    }
    
    return self;
}


- (void)_commonSetup
{
    // Setup defaults
    UIFont * font = [UIFont fontWithName:@"Menlo" size:14.0f];
    self.syntaxTextStorage.defaultFont = font;
    
    self.autocorrectionType     = UITextAutocorrectionTypeNo;
    if (@available(iOS 11.0, *)) {
        self.smartDashesType = UITextSmartDashesTypeNo;
        self.smartQuotesType = UITextSmartQuotesTypeNo;
    }
    self.dataDetectorTypes = 0;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.spellCheckingType = UITextSpellCheckingTypeNo;

    
    // Inset the content to make room for line numbers
    self.textContainerInset = UIEdgeInsetsMake(8, self.lineNumberLayoutManager.gutterWidth, 8, 0);
    
    self.lineCursorEnabled = NO;
    self.gutterBackgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.gutterLineColor       = [UIColor lightGrayColor];
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    [self setNeedsDisplay];
}

-(void)copyTextViewProperties:(UITextView*)textView
{
    // UITextView
    self.text = textView.text;
    self.font = textView.font;
    self.textColor = textView.textColor;
    self.textAlignment = textView.textAlignment;
    self.selectedRange = textView.selectedRange;
    self.editable = textView.editable;
    self.selectable = textView.selectable;
    self.dataDetectorTypes = textView.dataDetectorTypes;
    self.allowsEditingTextAttributes = textView.allowsEditingTextAttributes;
    
    // UITextViewTraits
    self.autocapitalizationType = textView.autocapitalizationType;
    self.autocorrectionType = textView.autocorrectionType;
    self.spellCheckingType = textView.spellCheckingType;
    
    if (@available(iOS 11.0, *)) {
        self.smartDashesType = textView.smartDashesType;
        self.smartQuotesType = textView.smartQuotesType;
        self.smartInsertDeleteType = textView.smartInsertDeleteType;
    }
    
    self.keyboardType = textView.keyboardType;
    self.keyboardAppearance = textView.keyboardAppearance;
    self.returnKeyType = textView.returnKeyType;
    self.enablesReturnKeyAutomatically = textView.enablesReturnKeyAutomatically;
    self.secureTextEntry = textView.secureTextEntry;
    
    // UIScrollView
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = textView.contentInsetAdjustmentBehavior;
    }
    self.bounces = textView.bounces;
    self.alwaysBounceVertical = textView.alwaysBounceVertical;
    self.alwaysBounceHorizontal = textView.alwaysBounceHorizontal;
    self.pagingEnabled = textView.pagingEnabled;
    self.scrollEnabled = textView.scrollEnabled;
    self.showsVerticalScrollIndicator = textView.showsVerticalScrollIndicator;
    self.showsHorizontalScrollIndicator = textView.showsHorizontalScrollIndicator;
    self.scrollIndicatorInsets = textView.scrollIndicatorInsets;
    self.indicatorStyle = textView.indicatorStyle;
    self.decelerationRate = textView.decelerationRate;
    self.indexDisplayMode = textView.indexDisplayMode;
    self.delaysContentTouches = textView.delaysContentTouches;
    self.canCancelContentTouches = textView.canCancelContentTouches;
    self.minimumZoomScale = textView.minimumZoomScale;
    self.maximumZoomScale = textView.maximumZoomScale;
    self.bouncesZoom = textView.bouncesZoom;
    self.keyboardDismissMode = textView.keyboardDismissMode;
    
    // UIView
    self.contentMode = textView.contentMode;
    self.semanticContentAttribute = textView.semanticContentAttribute;
    self.tag = textView.tag;
    self.userInteractionEnabled = textView.userInteractionEnabled;
    self.multipleTouchEnabled = textView.multipleTouchEnabled;
    self.alpha = textView.alpha;
    self.backgroundColor = textView.backgroundColor;
    self.tintColor = textView.tintColor;
    self.opaque = textView.opaque;
    self.hidden = textView.hidden;
    self.clearsContextBeforeDrawing = textView.clearsContextBeforeDrawing;
    self.clipsToBounds = textView.clipsToBounds;
    self.autoresizesSubviews = textView.autoresizesSubviews;
    
    self.translatesAutoresizingMaskIntoConstraints = textView.translatesAutoresizingMaskIntoConstraints;
    self.autoresizingMask = textView.autoresizingMask;
    }

#pragma mark - Cleanup

- (void)dealloc
{

}

#pragma mark - Overrides

- (void)setTokens:(NSMutableArray *)tokens
{
    [self.syntaxTextStorage setTokens:tokens];
}

- (NSArray *)tokens
{
    CYRTextStorage *syntaxTextStorage = (CYRTextStorage *)self.textStorage;
    
    return syntaxTextStorage.tokens;
}

- (void)setText:(NSString *)text
{
    UITextRange *textRange = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self replaceRange:textRange withText:text];
}

#pragma mark - Line Drawing

// Original implementation sourced from: https://github.com/alldritt/TextKit_LineNumbers
- (void)drawRect:(CGRect)rect
{
    //  Drag the line number gutter background.  The line numbers them selves are drawn by LineNumberLayoutManager.
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect bounds = self.bounds;
    
    CGFloat height = MAX(CGRectGetHeight(bounds), self.contentSize.height) + 200;
    
    // Set the regular fill
    CGContextSetFillColorWithColor(context, self.gutterBackgroundColor.CGColor);
    CGContextFillRect(context, CGRectMake(bounds.origin.x, bounds.origin.y, self.lineNumberLayoutManager.gutterWidth, height));
    
    // Draw line
    CGContextSetFillColorWithColor(context, self.gutterLineColor.CGColor);
    CGContextFillRect(context, CGRectMake(self.lineNumberLayoutManager.gutterWidth, bounds.origin.y, 0.5, height));
    
    if (_lineCursorEnabled)
    {
        self.lineNumberLayoutManager.selectedRange = self.selectedRange;
        
        NSRange glyphRange = [self.lineNumberLayoutManager.textStorage.string paragraphRangeForRange:self.selectedRange];
        glyphRange = [self.lineNumberLayoutManager glyphRangeForCharacterRange:glyphRange actualCharacterRange:NULL];
        self.lineNumberLayoutManager.selectedRange = glyphRange;
        [self.lineNumberLayoutManager invalidateDisplayForGlyphRange:glyphRange];
    }
    
    [super drawRect:rect];
}


@end
