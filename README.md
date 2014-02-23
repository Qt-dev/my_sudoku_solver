# Sudoku Solution

This is my version of a ruby Sudoku solver, mainly to show some fellow of DBC some more info about how to do it.

### The principle
It is based on this solution : [results of a solver](http://norvig.com/sudoku.html) created by [Peter Norvig](http://en.wikipedia.org/wiki/Peter_Norvig)

Basically what it does is :

- Replace every cell that has only 1 possible value
_ Replace every cell that is the only possible location for a value (ex: 1 can only be in this cell for this row)
- If it gets stuck, it fixes a value among those whith the least possible values, and goes back to doing the first two things

All that until it is solved.

It is very not perfect, but it works ;)

Enjoy!