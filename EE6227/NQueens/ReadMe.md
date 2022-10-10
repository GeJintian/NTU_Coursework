### Description
This project aims at solving N-Queens problem using genetic algorithm. This ReadMe file gives you an instruction on how to run and modify the parameters of my code.
###Implementation Details
In implementation, I use Uniform Crossover and Uniform Mutation. The mutation rate is set to be 0.001 and crossover always happens. The default initial group size is 400 and default max generation is 100000. You can modify these parameters according to the following instruction.
###How to run
This project is implemented by C++. Therefore, I have provided both the source code and a runnable file.<br>
- For source code, you should have seen one file: ```NQueensGA.cpp```. To compile my source code, run in the command line:<br>
```g++ -o NQueensGA NQueensGA.cpp```<br>If you are under **Windows** environment, you should get ```NQueensGA.exe```. You can run it by simply double click on this file.<br>
If you are under **Linux (WSL)** environment, you should get ```NQueensGA```. You can run it by a command line:```./NQueensGA```
- For the runnable file, I provide a ```NQueensGA.exe``` file. If you are under **Windows** environment, double click to run it. If you are under **Linux (WSL)** environment, use command line ```./NQueensGA.exe``` to run it.
- For **Mac** user, I don't have a mac environment to try it, but I think the whole process should be similar to **Linux**.

After starting my program, it will ask for the number of Queens. Enter the problem size and wait for several minutes (it depends on the problem size and your computer performance). Don't worry, it will stop after 100000 generations automatically if it doesn't find a solution.

### Modify and output
If you want to change my default parameters, open ```NQueensGA.cpp```. In the beginning of this file, you should see three ```#define```. You can modify the number at the end of these lines to what you want.<br>
If this project finds a solution, it will print it on the screen and output it into a "solution.txt" file, according to the requirement.
