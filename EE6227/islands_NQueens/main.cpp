//
// Created by Lenovo on 2022/2/5.
//
#include <cstdlib>
#include <vector>
#include <iostream>
#include <deque>
#include <fstream>

using namespace std;

#define Max_Generation 100000
#define Init_Num 200
#define Mutation_rate 0.001
#define exchange_size 4
#define exchange_period 10000

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
void string_config(vector<int>a){
    for(vector<int>::size_type i = 0; i < a.size();i++){
        cout<<a[i]<<" ";
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
    void swap_Mutate();
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
void Gene::swap_Mutate() {
    int p1 = random_generator(length);
    int p2 = random_generator(length);
    int temp = config[p1];
    config[p1] = config[p2];
    config[p2] = temp;
}

class Pop{
    //This is a class of Pop.
public:
    vector<Gene> groups;
    int n;
    bool is_successful;
    Gene solution = NULL;
    Pop(int n);
    void executor();
};
Pop::Pop(int length) {
    //First step: Initialize groups and calculate penalty.
    //cout<<"Step1"<<endl;
    n = length;
    is_successful = false;
    for (int i = 0; i < Init_Num; i++) {
        Gene individual(n);
        groups.push_back(individual);
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
//Gene O1_crossover(Gene a, Gene b, int n){
//    Gene child(n);
//    int pos1 = random_generator(n);
//    int pos2 = random_generator(n - pos1) + pos1;
//    deque<int> order;
//    for(int i = pos2 + 1; i < n; i++){
//        bool is_exist = false;
//        for(int j = pos1; j <= pos2; j++){
//            if(b.config[i] == a.config[j]) is_exist = true;
//        }
//        if(is_exist) order.push_back(b.config[i]);
//    }
//    for(int i = 0; i < pos1; i++){
//
//    }
//    for(int i = 0; i < n; i++){
//        if(i >= pos1 && i<=pos2) {
//            child.config[i] = a.config[i];
//        }
//        else{
//
//        }
//    }
//
//    return child;
//}
void Pop::executor(){
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
            solution = groups[i];
            return;
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
    //wheel selection
//    for(int i = 0; i < Init_Num; i++){
//        double prob = rand()*1.0/(RAND_MAX+1);
//        if(prob < fitness[0]){
//            pool.push_back(groups[0]);
//        }
//        else{
//            for(vector<Gene>::size_type j = 1; j < Init_Num; j++){
//                if(prob<fitness[j]&&prob>=fitness[j-1]){
//                    pool.push_back(groups[j]);
//                    break;
//                }
//            }
//        }
//    }
    //Tournament Selection
    for(int i = 0; i < Init_Num; i++){
        int min_penalty = 100000;
        Gene temp(n);
        for(int x = 0; x < 20; x ++) {
            int idx = random_generator(Init_Num);
            if (groups[idx].penalty < min_penalty) {
                temp = groups[idx];
                min_penalty = groups[idx].penalty;
            }
        }
        pool.push_back(temp);
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


int main(){
    //Ask for number of queens
    int n = 8;
    cout<<"Please enter the number of queens: "<<endl;
    cin>>n;
    Pop pop1(n);
    //string_config(pop1.groups[0].config);
    Pop pop2(n);
    //string_config(pop2.groups[0].config);
    Pop pop3(n);
    //string_config(pop3.groups[0].config);
    Pop pop4(n);
    //string_config(pop4.groups[0].config);
    Pop islands[4] = {pop1,pop2,pop3,pop4};
    //1-2-3-4-1. So exchange happens in (1,2),(2,3),(3,4),(4,1)
    int exchange[4][2] = {{0,1},{1,2},{2,3},{3,0}};
    bool is_successful = false;
    for(int epoch = 0; epoch <= Max_Generation; epoch++){
        bool all_successful = true;
        for(int i = 0; i < 4; i++){
            islands[i].executor();
            all_successful = all_successful && islands[i].is_successful;
        }
        if(all_successful){
            is_successful = true;
            break;
        }
        //For exchange
        if(epoch%exchange_period == 1){
            cout<<"Exchanging"<<endl;
            for(int i = 0; i < 4; i++){
                Pop &ex1 = islands[exchange[i][0]];
                Pop &ex2 = islands[exchange[i][1]];
                for(int j = 0; j < exchange_size; j++){
                    int idx = random_generator(Init_Num);
                    Gene temp = ex1.groups[idx];
                    ex1.groups[idx] = ex2.groups[idx];
                    ex2.groups[idx] = temp;
                }
            }
        }
    }
    if(!is_successful){
        cout<<"Can not find 4 solutions with 100000 generations and group size 100."<<endl;
        // In my computer, these two parameters can at least solve 100-queens problem. Please try to increase max_generation according to README file.
        int count =  0;
        for(int i = 0; i<4;i++){
            if(islands[i].is_successful) count += 1;
        }
        cout<<"Only find "<<count<<" solutions."<<endl;
    }
    else{
        cout<<"Successfully find 4 solutions. The configurations are:"<<endl;
//        //cout<<Comp_penalty(solution.config);
//        ofstream outfile;
//        outfile.open("solution.txt");
//        for(vector<int>::size_type i = 0; i < pop.solution.config.size();i++){
//            for(int j = 0; j < solution.config.size(); j++){
//                if(j != solution.config[i]) outfile<<"| ";
//                else outfile<<"|Q";
//            }
//            outfile<<"|"<<endl;
//        }
//        outfile.close();
//        cout<<"This configuration has been saved in 'solution.txt' file."<<endl;
    }
    for(int i = 0; i < 4; i ++) print_config(islands[i].solution.config);
    cout<<"string representations are:"<<endl;
    for(int i = 0; i < 4; i ++) string_config(islands[i].solution.config);
    return 0;
}
