### Description
This project aims at solving N-Queens problem using 4-island GA. This ReadMe file gives you an instruction on how to run and modify the parameters of my code.
### Implementation Details
In implementation, I use Uniform Crossover and Uniform Mutation. I have tried to use Order1 crossover and single swap mutation, but they perform worser than uniform operation. The mutation rate is set to be 0.001 and crossover always happens. The default initial group size is 200 and default max generation is 100000. You can modify these parameters according to the following instructions.
### How to run
This project is implemented by C++. Therefore, I have provided both the source code and a runnable file.<br>
- For source code, you should have seen one file: ```main.cpp```. To compile my source code, run in the command line:<br>
```g++ -o main main.cpp```<br>If you are under **Windows** environment, you should get ```main.exe```. You can run it by simply double click on this file.<br>
If you are under **Linux (WSL)** environment, you should get ```main```. You can run it by a command line:```./main```
- For the runnable file, I provide a ```main.exe``` file. If you are under **Windows** environment, double click to run it. If you are under **Linux (WSL)** environment, use command line ```./main.exe``` to run it.
- For **Mac** user, I don't have a mac environment to try it, but I think the whole process should be similar to **Linux**.

After starting my program, it will ask for the number of Queens. Enter the problem size and wait for several minutes (it depends on the problem size and your computer performance). Don't worry, it will stop after 100000 generations automatically if it doesn't find enough solution.<br>
Note that sometimes it will give duplicated solutions. It is mainly because of the exchange generation is too small. You could increase this parameter.

### Modify and output
If you want to change my default parameters, open ```main.cpp```. In the beginning of this file, you should see three ```#define```. You can modify the number at the end of these lines to what you want.<br>
