

#import <Foundation/Foundation.h>

@interface NSString (FormValidation)

/**
 Verifies a valid email was entered
 
 @return Returns YES if valid, NO if not valid.
 **/
- (BOOL)isValidEmail;

/**
 Verifies a valid password was entered
 
 @return Returns YES if valid, NO if not valid.
 **/

- (BOOL)isValidPassword;

/**
 Verifies a valid name was entered
 
 @return Returns YES if valid, NO if not valid.
 **/
- (BOOL)isValidName;

/**
 Verifies a minimum password was entered
 
 @return Returns YES if valid, NO if not valid.
 **/
- (BOOL)isMinimumPasswordLength;


@end
