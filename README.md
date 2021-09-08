# VLC SubDics

### :x: Not Working
### :warning: Historical Project
Due to changes in VLC API, this plugin no longer works.

## Functionality
- The intention behind this idea is to help non-native English speakers lookup meanings of difficult words in the movie. This uses subtitle information to do so.
- When user pauses a video, the plugin filters out trivial words from the current subtitle-line and displays the meanings of remaining non-trivial words.
- Once user plays the video again, the plugin hides the popup.

## Implementation 
- The plugin listens to pause/play events.
- The loaded subtitle file is used to find out the relevant words. Then the words will be searched in an in-memory dictionary and results are displayed.
- This plugin makes use of a XML-based lightweight word-dictionary and a third-party xml-parsing library.

## Dependencies
- Works with VLC players running on Windows and Linux environments.
- Lacks autoconfig to detect Operating System. Need to update a OS-name flag manually in the source-code. 
