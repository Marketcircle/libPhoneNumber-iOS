//
//  NSString+NBAdditions.h
//  libPhoneNumberiOS
//
//  Created by Fraser Kuyvenhoven on 2021-12-02.
//  Copyright © 2021 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (NBAdditions)

- (NSString *)stringByCollapsingWhitespace;

- (NSString *)stringByReplacingEverySeriesOfCharactersFromSet:(NSCharacterSet *)aSet
                                                   withString:(NSString *)replaceString;

@end

NS_ASSUME_NONNULL_END
