//
// Created by Lenovo on 2022/2/5.
//
#include <cstdlib>
#include <vector>
#include <iostream>
#include <fstream>

using namespace std;

#define Max_Generation 100000
#define Init_Num 400
#define Mutation_rate 0.001

int random_generator(int range)
{
    int random_int = rand()%range;
    return random_int;
}

void print_config(vector<int> a){
    for(vector<int>::size_type i = 0; i < a.size();i++){
        for(int j = 0; j < a.size(); j++){
            if(j != a[i]) cout<<"| ";
            else cout<<"|Q";
        }
        cout<<"|"<<endl;
    }
    cout<<endl;
}

class Gene{
    //This class is a data structure for individual.
public:
    int length;
    vector<int> config;
    int penalty;
    void build_penalty();
    Gene(int n);
    void Uni_Mutate();
};
int Comp_penalty(const vector<int>& config){
    //penalty = sum of conflicts
    //This algorithm should try to minimize this fitness.
    int penalty = 0;
    for(vector<int>::size_type i = 0; i < config.size(); i++){
        for(vector<int>::size_type j = i + 1; j < config.size(); j++){
            if(config[i] == config[j]) penalty++;
            if(abs(config[i]-config[j])==j-i) penalty++;
        }
    }
    return penalty;
}
void Gene::build_penalty() {
    penalty = 0;
    for(vector<int>::size_type i = 0; i < config.size(); i++){
        for(vector<int>::size_type j = i + 1; j < config.size(); j++){
            if(config[i] == config[j]) penalty++;
            if(abs(config[i]-config[j])==j-i) penalty++;
        }
    }
}
Gene::Gene(int n){
    //This function should generate a random array with length n, and insert them into the vector.
    int pos;
    for(int i = 0; i < n; i++){
        pos = random_generator(n);
        config.push_back(pos);
    }
    length = n;
    penalty = Comp_penalty(config);
}
void Gene::Uni_Mutate() {
    for(vector<int>::size_type i = 0; i < length; i++){
        double prob = rand()*1.0/(RAND_MAX+1);
        if(prob < Mutation_rate){config[i] = random_generator(length);}
    }
}

Gene uni_crossover(Gene a, Gene b, double part,int n){
    Gene child(n);
    for(vector<int>::size_type i = 0; i < n; i++){
        double prob = rand()*1.0/(RAND_MAX+1);
        if(prob < part) child.config[i] = a.config[i];
        else child.config[i]=b.config[i];
    }
    return child;
}
Gene executor(int n, bool &is_successful){
    //First step: Initialize groups and calculate penalty.
    //cout<<"Step1"<<endl;
    vector<Gene> groups;
    for (int i = 0; i < Init_Num; i++) {
        Gene individual(n);
        groups.push_back(individual);
    }
    for(int epoch = 0; epoch <= Max_Generation; epoch++){
        //Second step: Check penalty. If penalty == 0, find a solution. Otherwise, calculate fitness.
        //cout<<"Step2"<<endl;
        vector<double> fitness;
        double sum = 0;
        //cout<<"Step1"<<endl;
        for (vector<Gene>::size_type i = 0; i < groups.size(); i++) {
            if(groups[i].penalty == 0){
                is_successful = true;
                //cout<<groups[i].penalty<<endl;
                //print_config(groups[i].config);
                return groups[i];
            }
            //cout<<"Step1"<<endl;
            fitness.push_back(1.0/double(groups[i].penalty));
            sum = sum + 1.0/double(groups[i].penalty);
        }
        //cout<<sum<<endl;
        fitness[0] = fitness[0]/sum;
        for (vector<Gene>::size_type i = 1; i < groups.size(); i++) {
            fitness[i] = fitness[i-1]+fitness[i]/sum;
        }

        //Third step: Choose individuals according to fitness.
        //cout<<"Step3"<<endl;
        vector<Gene> pool;
        for(int i = 0; i < Init_Num; i++){
            double prob = rand()*1.0/(RAND_MAX+1);
            if(prob < fitness[0]){
                pool.push_back(groups[0]);
            }
            else{
                for(vector<Gene>::size_type j = 1; j < Init_Num; j++){
                    if(prob<fitness[j]&&prob>=fitness[j-1]){
                        pool.push_back(groups[j]);
                        break;
                    }
                }
            }
        }
        if(pool.size() != Init_Num) cout<<"Error found";
        //Forth step: Crossover.
        //cout<<"Step4"<<endl;
        vector<Gene> children;
        for(vector<Gene>::size_type i =0; i < Init_Num; i += 2){
            double part = rand()*1.0/(RAND_MAX+1);
            children.push_back(uni_crossover(pool[i],pool[i+1],part,n));
            children.push_back(uni_crossover(pool[i+1],pool[i],part,n));
        }
        //Fifth step: Mutation.
        //cout<<"Step5"<<endl;
        for(vector<Gene>::size_type i = 0; i < Init_Num;i++){
            children[i].Uni_Mutate();
            children[i].build_penalty();
        }
        //Sixth step: Generate new pop.
        //cout<<"Step6"<<endl;
        groups = children;
    }
    //Adjust this one.
    return NULL;
}

int main(){
    //Ask for number of queens
    int n = 100;
    cout<<"Please enter the number of queens: "<<endl;
    cin>>n;
    bool is_successful = false;
    Gene solution = executor(n,is_successful);
    if(!is_successful){
        cout<<"Can not find a solution with 100000 generations and group size 400. In my computer, these two parameters can at least solve 100-queens problem. Please try to increase max_generation according to README file."<<endl;
    }
    else{
        cout<<"Successfully find a solution. The configuration is:"<<endl;
        print_config(solution.config);
        //cout<<Comp_penalty(solution.config);
        ofstream outfile;
        outfile.open("solution.txt");
        for(vector<int>::size_type i = 0; i < solution.config.size();i++){
            for(int j = 0; j < solution.config.size(); j++){
                if(j != solution.config[i]) outfile<<"| ";
                else outfile<<"|Q";
            }
            outfile<<"|"<<endl;
        }
        outfile.close();
        cout<<"This configuration has been saved in 'solution.txt' file."<<endl;
    }

    /*
    Gene a(n);
    Gene b(n);
    print_config(a.config);
    print_config(b.config);
    print_config(crossover(a,b,0.3,n).config);
    */
    return 0;
}
