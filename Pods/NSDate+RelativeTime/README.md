NSDate+RelativeTime
===================

NSDate+RelativeTime is an `NSDate` category to generate relative time (or fuzzy
time) strings from dates. NSDate's are parsed to strings like for example
'Now', 'A day ago' or '3 months from now'. NSDate+RelativeTime seperates
itself from other alike categories in the fact that it handles not only past
dates but future dates as well.

## Usage
* Add the files to your project manually or via
(Cocoapods)[http://cocoapods.org] (`pod 'NSDate+RelativeTime', '~> 1.0'`)
* Import `NSDate+RelativeTime.h` into the class.
* Call the `relativeTime` method on an NSDate to get the relative time.

## Tests
The tests are in `NSDate+RelativeTimeTests.m` and require Kiwi to run.

There's a couple of things missing in the tests and I'd love a pullrequest if
you know how to fix one of them: 
* A (Travis)[https://travis-ci.org] config file for continuous integration.
* Proper tests for the localization.
* A way to run the tests in a cleaner way (not an entire generated project for
just one file of tests).


## Contributions
There are plenty of possibilities for contributions to this category, there's
a lot of optimalizations to be done about the readability of the code and/or
the performance. Also the tests are a bit meager and there's only a few
localizations. If you're not sure about a new feature just create an issue and
lets discuss it!

## License
AFNetworking is available under the MIT license. See the LICENSE file for more
info.
