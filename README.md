# SheepPens - A Simple Strategy Game for Young Kids

Sheep Pens is a board game based on Pen the Pigs (AKA dots and lines, AKA squares)

See <a href="http://maple.scot/index.php/our-games/18-pig-pens">here</a> for how to make your own Pig Pens physical board game to play at home.

It is a simple game aimed at children from 4 years and up.

### Background

I've been a hobbiest game developer for a number of years.
Most of the games I have developed have been in Java using the libGdx framework in collaberation with my friend Troy Peterson.

As most of Troy's time for the last 18 months has been spent developing a trading system and turning that into a software company I have mostly been developing games on my own but still in libGdx.

Recently I decided to try making a game in Unity. And I decided to do a version of the Pig Pens board game.
That game is available here: https://github.com/MapleScotDevelopment/PigPens

After making Pig Pens I decided to make another version of it named Sheep Pens primarily for people who don't like pigs.
I then decided that it would be fun to learn a bit more about the Godot Engine so have re-implemented Pig Pens in Godot and named it Sheep Pens.

I have made the game open source because I don't really consider the game idea to be mine and because I would very much like some constructive criticism on the game and how I have made it work in Godot.

### Licence

The source code that I have written is CC0.

The graphic assets are CC3-BY. They are used in other games so I need to protect them in some small way.

The sound assets are CC0.

### Dependencies

In the full game there are two wav files that came from a purchased licensed unity asset. Obviously I have not included them here.
These are the click sound when pressing buttons and the audience cheering sound. All other sounds were freely available and I have modified them to fit the game.


### How to Play

It is a simple game aimed at children from 4 years and up.

See the maple.scot website for how to make your own Pig Pens physical board game to play at home.

The video game is mostly the same as the physical game.

#### Rules
Each Player picks a colour of Sheep and is given

* 6 sheep for a 2 player game
* 5 sheep for a 3 player game
* 4 sheep for a 4 player game

Play starts with the Pink sheep and moves clockwise

Each player takes a turn going to the barn to get a fence piece. Spin the spinner to find out what you get from the barn.

* 1 Fence piece - Take a fence piece and place it on the board at the edge of a square
* 2 Fence pieces - Take 2 fence pieces and place them on the board at the edges of squares
* Naughty Sheep - The naughty sheep runs away - miss this turn

Closing a pen - If you can place a fence piece to finish a square then you win that square - 1 of your sheep will jump in that square and BAA with glee!

The winner is the first player to pen all of their sheep.
 

#### Strategy
It's a good idea not to give pens away. Try to place your fences so that the next player can't steal a pen from you.

It's a good lesson for young children to learn


### Reimplementing in Godot

The big question, how was it moving to Unity after usig a framework like libGdx?

Well it was both easy and hard.
The easy parts:

Producing binaries for windows, mac, linux, android and iOS all from my windows laptop (with some help from my macbook for the ios build). Very easy and very quick once you have done it a few times.

Consistency. The game works identically on all of the above systems with no os specific code.

The hard:

Serialising/Deserialising data to/from json files. Why is this so bad?
The libgdx json support is fantastic and simple and handles everything thrown at it.
The unity json support is sorely lacking and can't handle 2d arrays or dictionaries.
I didn't want to add a dependency just to save game data to file so I worked around the issue but I was tearing my hair out for a while over this.

Not doing everything in code. I am a coder (this is obvious from the artwork), I am used to doing everything in code. For example when it came to making the fence buttons my firt reaction was to write a piece of code that knew where to put the first button and the horizontal and vertical distances between the buttons and generate them all in code. Then I stopped and thought no, the unity way would be to copy and paste the button each time and move it to the correct location. Then later I realised I should have made it a prefab first and had to add that retro-actively.

The learning curve. There is a lot to learn and you have to learn the unity way of doing things. This is hard. The animation system stumped me quite a bit which is why I use DOTween in code for quite a few things. DOTween is very similar to the <a href="https://libgdx.badlogicgames.com/ci/nightlies/docs/api/com/badlogic/gdx/scenes/scene2d/actions/Actions.html">Actions</a> part of libGdx.

Particle systems. I still don't get it. It still doesn't work how I wanted it to. Not sure it ever will. I need to spend a lot more time on this.

2D is still 3D. Rotating things around the Y axis to get them to face the opposite way? Yup ok I get it but its still a bit weird.

UI. libGdx has better support for UI than Unity. Way to much work for simple stuff.

### Conclusion

I like it. I like the ability to see how things are going to look so quickly. I like attaching small pieces of code to objects for very specific things.

In the future I can see me making more games with Unity. Hopefully Troy will have more time to work on stuff as there is quite a big project we have in mind. In the short term I would like to do a version of Pig Pens in Godot to see how it compares as an engine to develop in. I expect its quite similar in many ways.
