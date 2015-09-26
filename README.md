## Lambda Calculus Interpreter (Haskell)

Author: Hao Zhong

Date: September 2015

#### Features:
The goal of this assignment is to write a lambda calculus interpreter in a functional programming language to reduce lambda calculus expressions in a callbyvalue (applicative order) manner.

Your interpreter is expected to take each lambda calculus expression and repeatedly perform beta reduction until no longer possible (a value expression that can no longer be betareduced) and then eta reduction until no longer possible.

Detailed description of the assignment can be found here: [http://www.cs.rpi.edu/academics/courses/fall15/proglang/pa1/pa1.html]


#### To Run:
1. Change to the directory where PA1SampleUsage.hs, PAHelper.hs, and all input file locate;
2. In terminal, run "ghci PA1SampleUsage.hs"
3. If program loads successfully, it displays "Ok, modules loaded: PA1Helper, Main.";
4. Enter "main" to enter the Main function, then at the prompt of "Please enter a filename containing lambda expressions:", enter the input file name and a list of results will be displayed;
5. Repeat step 4) to interpret more Lambda calculus input files;
6. Enter ":q" to exit the program.

#### Bugs: 
[9/25/15] The eta reduction seems to have something wrong. I upload this version, but wishing to use another late day to get a perfect version tomorrow.
