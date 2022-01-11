//
//  NSString+NBAdditions.m
//  libPhoneNumberiOS
//
//  Created by Fraser Kuyvenhoven on 2021-12-02.
//  Copyright © 2021 Google. All rights reserved.
//

#import "NSString+NBAdditions.h"

@implementation NSString (NBAdditions)

- (NSString *)stringByCollapsingWhitespace {
  return [self stringByReplacingEverySeriesOfCharactersFromSet:NSCharacterSet.whitespaceAndNewlineCharacterSet
                                                    withString:@" "];
}

- (NSString *)stringByReplacingEverySeriesOfCharactersFromSet:(NSCharacterSet *)aSet
                                                   withString:(NSString *)replaceString {
  NSScanner    *scanner = [NSScanner scannerWithString:self];
  NSMutableString  *newString = [NSMutableString stringWithCapacity:[self length]];
  NSString    *betweenString;
  
  [scanner setCharactersToBeSkipped:nil];
  
  while (![scanner isAtEnd])
  {
    if ([scanner scanUpToCharactersFromSet:aSet intoString:&betweenString])
      [newString appendString:betweenString];
    
    if ([scanner scanCharactersFromSet:aSet intoString:NULL])
      [newString appendString:replaceString];
  }
  
  return newString;
}

@end
