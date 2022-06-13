# Minimal Fennel LÖVR Setup

Ported from this LOVE2D starter kit: https://gitlab.com/alexjgriffith/min-love2d-fennel

This repo serves as both a template LÖVR project and the home of the lovr-stdio-repl library in the lib folder. 

## Getting Started

To get started, just run `lovr` against this directory and a REPL will be opened over STDIO

For example:

```bash
cd min-lovr-fennel
./lovr-x86_64.AppImage ./
```

## Emacs

For a good interactive development experience with Emacs, look no further than `fennel-mode`

https://git.sr.ht/~technomancy/fennel-mode

To start LOVR with the repl, Use `C-u C-c C-z` from within a fennel-mode buffer and enter `lovr ./` for the command.

##  lovr-stdio-repl

If you make changes you will have to recompile the lovr-stdio-repl.fnl to lua using the following command:

```bash
cd lib
fennel -c lovr-stdio-repl.fnl > lovr-stdio-repl.lua
````

## Phil’s Modal Callbacks (PMC)

Phil Hegelberg’s exo-encounter-667 is structured using a modal callback system. Each game state has a mode and each mode has a series of specific callbacks.

If you design your game as a series of states in a very simple state machine, for example start-screen, play and end, with unidirectional progression, you can easily separate the logic for each state into state/mode specific callbacks. As an example, in order to have state dependant rendering that differs between start-screen,play and end you could provide a draw callback for each of those states. Similarly if we need state dependent logic and keyboard input we could provide update and keyboard callbacks. As you iterate you can add and remove callbacks and states/modes as needed with very little friction.
