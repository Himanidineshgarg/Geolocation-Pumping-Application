
#import "NSString+FormValidation.h"

@implementation NSString (FormValidation)

- (BOOL)isValidEmail {
	NSString *regex = @"[^@]+@[A-Za-z0-9.-]+\\.[A-Za-z]+";
	NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	return [emailPredicate evaluateWithObject:self];
}

- (BOOL)isValidName {
	return (self.length >= 1);
}

- (BOOL)isValidPassword {
    return (self.length >= 1);
}

- (BOOL)isMinimumPasswordLength {
    return (self.length >= 8);
}

@end
