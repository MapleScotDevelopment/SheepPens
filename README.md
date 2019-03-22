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

The big question, how was it re-implementing in Godot after first implementing Unity and after using a framework like libGdx?

Well it was fairly easy and fairly quick. I had already made the game once so hadd all the assets and writing it fresh in a new language only threw up a few barriers.

The easy parts:

Producing binaries for windows, mac, linux, android all from my windows laptop (and on my macbook for the ios build). Very easy and very quick once you have done it a few times.

Consistency. The game works identically on all of the above systems with no os specific code.

No real difference between Godot and Unity here although the minimalist output of Godot is very imppressive.

Tweening is very similar in Godot to using DOTween or Actions in libgdx.

Particles was much easier in Godot. Once I read the doc page I had something I liked very quickly. The ability to save colour gradients as separate resource files meant I could create one for each colour of sheep and swap it at run time depending on which player had won the pen.

The differences to Unity:

Godot is similar to Unity in many ways but with some important differences.
Scenes can be both standalone and integrated into another scene meaning that scenes also act like prefabs in Unity.

2D is dedicated rather than 3d with a fixed view.

Godot has nicer UI support.

The hard:

Serialising/Deserialising data to/from json files still isn't great.
The libgdx json support is fantastic and simple and handles everything thrown at it.
The godot json support works great with dictionaries but you basically have to serialise/deserialise every object which you want to store by storing the values in a dictionary and then using json to store the dictionary.

I am a coder (this is obvious from the artwork), I am used to doing everything in code. With Godot it seemed like there was a lot more expectation of writing some code to go with every scene which suited me fine. So somewhere in-between libgdx and Unity.

Similar to unity I made all the buttons first and manually placed them but I had the "pressed" signals programmtically as that seemed much easier.

The learning curve was nowhere near as bad after learning the unity way of doing things. 

### Conclusion

I like Godot. Similar enough to Uniity that I can see how things are going to look quickly. I like attaching small pieces of code to objects for very specific things. But also with higher dependency on code which suits me.

In the future I can see me making more games with Godot, especially for 2D. I really like the particle system. I would like to do more, probably play with shaders a bit to get a feel for how that works.

I have an idea for a simple 2D twin stick shooter that godot would be perfect for.

