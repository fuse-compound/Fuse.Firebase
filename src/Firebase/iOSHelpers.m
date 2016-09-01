#import <Foundation/Foundation.h>
@import Firebase;

// This is an odd file. It exists because if you use `@import` in .mm files
// then XCode will complain that module support is not enabled, even if you
// explicitly enable it (and other surrounding options) in you 'Build Settings'
//
// To work around this we have this one objc file that simply exists to make sure
// that the module is linked properly. The other .mm files can then stick to using
// #include without any extra complications
