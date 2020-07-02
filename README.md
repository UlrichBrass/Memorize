# Memorize
This is CS193P course Spring 2020 version of the Memorize game as specified in Assignments 1 and 2, with the animations developed in the course
and the additional enhancements of assignments 5 and 6.
There are some deviations from the assignments
* A JSON file is used as input of the initial set of themes. Any change to these themes, and any additional themes are stored in persistent storage
* How many cards are in a game depends on the number of emojis for the underlying theme, but can also be tweaked on the edit screen, if you want to play an easier version
* Color management has been added to the themes as described in assignment 5. An MIT licensed  color picker package (https://github.com/hendriku/ColorPicker) has been usedfor changing the colors. This can be replaced in iOS14 with the new ColorPicker, which has the same name and interface.
* In addition to the required features of assignment 6, a feature has been added to configure the grace period (Pie) for matching a card on the edit screen
