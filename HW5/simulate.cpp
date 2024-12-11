#include <iostream>
#include <fstream>
#include <sstream>
#include <unordered_map>
#include <vector>
#include <string>
#include <stdlib.h>

using namespace std;
struct Gate {
    std::string type;         
    bool output;       
    int level;
    int fanInN;               
    int fanOutM;              
    Gate** fanIn;     
    Gate** fanOut;
    // Gate* sched = nullptr;
    std::string name;
    bool sched = false;
    int state = 2;

    Gate() : fanIn(nullptr), fanOut(nullptr) {}

    // Destructor to release allocated memory
    ~Gate() {
        delete[] fanIn;
        delete[] fanOut;
    }
};

void printGate(const Gate &g) {
    std::cout << " type: " << g.type 
              << " output: " << g.output
              << " level: " << g.level 
              << " fanInN: " << g.fanInN 
              << " fanOutM: " << g.fanOutM 
              << " fanIn: " << g.fanIn 
              << " fanOut: " << g.fanOut
              << " name: " << g.name << std::endl;
}

Gate dummy_gate;
std::unordered_map<std::string, Gate> gates;
std::vector<std::vector<Gate*>> levels(1);
std::vector<Gate*> inputs;
std::vector<Gate*> dffs;
std::vector<Gate*> outputs; 

int max_level = 6;

void parseLine(const std::string& line) {
    std::istringstream iss(line);

    std::string type, name, gname, outputStr, fanInNStr, fanOutStr, levelStr;
    int fanInN, fanOutM, level;
    bool output;

    iss >> type >> outputStr >> levelStr >> fanInNStr;
    output = outputStr == "true";
    level = stoi(levelStr);
    fanInN = stoi(fanInNStr);
    Gate** fanIn;
    if(fanInN != 0){
        fanIn = new Gate*[fanInN];
        for (int i = 0; i < fanInN; i++) {
            iss >> gname;
            fanIn[i] = &gates[gname];
        }
    }

    iss >> fanOutStr;
    fanOutM = stoi(fanOutStr);
    Gate** fanOut = new Gate*[fanOutM];
    fanOut[0] = (iss >> name, &gates[name]);
    for (int i = 1; i < fanOutM; i++) {
        iss >> gname;
        fanOut[i] = &gates[gname];
    }

    iss >> name;
    gates[name].type = type;
    gates[name].output = output;
    gates[name].level = level;
    gates[name].fanIn = fanIn;
    gates[name].fanOut = fanOut;
    gates[name].fanInN = fanInN;
    gates[name].fanOutM = fanOutM;
    gates[name].name = name;
    if(type == "input"){
        inputs.push_back(&gates[name]);
        // cout << inputs.back() << endl;
    }
    else if(type == "dff"){
        dffs.push_back(&gates[name]);
        gates[name].state = 2;
    }
    if(output)
        outputs.push_back(&gates[name]);
    if(type == "input" || type == "dff")
        levels[0].push_back(&gates[name]);
    // printGate(gates[name]);
}

void parseFile() {
    std::ifstream input("gates.txt");
    std::string line;

    // Parse each line in the file
    std::getline(input, line);
    std::istringstream iss(line);
    std::string str;
    iss >> str;
    cout << str;
    iss >> str;
    cout << str << endl;
    max_level = stoi(str);
    getline(input, line);
    cout << line << endl;
    while (std::getline(input, line)) {
        parseLine(line);
    }
    input.close();
}

void schedule_fanout(Gate* g){
    int M = g->fanOutM;
    Gate** fanout = g->fanOut;
    for(int i=0 ; i < M; i++){
        if (!fanout[i]->sched){ // Add logic to filter out DFFs
            levels[fanout[i]->level].push_back(fanout[i]);   // Add fanout to 
            fanout[i]->sched = true;
        }
    }
}

char evaluate(Gate* g){
    return 2;
}

void simulate(){
    std::ifstream input("S27.vec");
    std::string input_vec;
    // Print logic values at PI, PO, and States
    getline(input, input_vec);
    int i = 0;
    cout << "INPUT   :";
    for(char c : input_vec){
        inputs[i]->state = c - '0';
        cout << inputs[i]->state;
        // schedule fanouts of changed inputs.
        schedule_fanout(inputs[i]);
        i = i + 1;
    }

    i = 1;
    while(i < max_level) {
        while(!levels[i].empty()){
            Gate* gate = levels[i].back();
            char new_state = evaluate(gate);
            if(new_state != gate->state) {
                gate->state = new_state;
                schedule_fanout(gate);
            }
            gate->sched = false;
            levels[i].pop_back();
        }
        i = i + 1 ;
    }
    
    // Print output states
    cout << endl << "STATE   :";
    for(Gate* dff : dffs){
        cout << dff->state;
    }

    cout << endl << "OUTPUT   :";
    for(Gate* out : outputs){
        cout << out->state;
    }
}

// void evaluate(){
//     bool uvalue = false;
//     for(int i =0; i <)
// }
int main(){
    parseFile();
    levels.resize(max_level + 1);
    // cout << "Levels" << endl;
    // for(int i = 0; i < levels[0].size(); i++)
    //     cout << levels[0][i]->name << endl;
        
    // cout << "Inputs" << endl;
    // for(int i = 0; i < inputs.size(); i++)
    //     cout << inputs[i]->name << endl;
    simulate();
}