# MiniKeepSafe

This is a small sample project that highlights how The Composable Architecture (TCA) allows to create nicely decoupled features, allowing the application to scale and providing guard rails to properly test features.

The hard coded PIN is `123`

## Requirements

* Xcode 14.2
* To run snapshot tests (unit tests), please use the iPhone 14 Pro simulator. If the tests run on another simulator device they may fail. Snapshot tests do not work on device.

## Used 3rd party libraries

* KingFisher for quick async image loading in caching (see Gotchas for details)
* The Composable Architecture
* Snapshot Testing

## Gotchas

This project is limited in scope due to the nature of the time limit set for this project (~2h). The main shortcomings to mention are:

* PIN is hard coded to `123`
* Image loading does not perform prefetching, we kick off an API request when we reach the end of the list
* We're using KingFisher to perform the image loading and caching. Using the native `AsyncImage` resulted in performance and rendering issues. It's currently not cohesive that we're using KingFisher in the grid feature, but not in the full screen feature. This is something to tackle in the next round. Ideally, we would want some prefetching that gets the list of images ahead of time while we're scrolling and we might want to maintain our own caching layer eventually to have more control over it.
* The full screen viewer does not load additional images if the end of the list is reached
* The full screen viewer also does not allow for pinch and zoom gestures
