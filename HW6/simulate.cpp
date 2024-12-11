#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>

struct Gate {
    std::string type;         
    bool output;       
    int level;                
    int fanInN;               
    int fanOutM;              
    Gate* fanIn;               
    Gate* fanOut;              
    Gate* sched = nullptr;
    std::string name;

    Gate() : fanIn(nullptr), fanOut(nullptr) {}

    // Destructor to release allocated memory
    ~Gate() {
        delete[] fanIn;
        delete[] fanOut;
    }
};

Gate dummy_gate;
std::vector<Gate> gates;
std::vector<std::vector<Gate>> levels;

Gate parseLine(const std::string& line) {
    std::istringstream iss(line);
    Gate gate;

    iss >> gate.type >> gate.output >> gate.level;

    iss >> gate.fanInN;
    gate.fanIn = new int[gate.fanInN];
    for (int i = 0; i < gate.fanInN; ++i) {
        iss >> gate.fanIn[i];
    }

    iss >> gate.fanOutM;
    gate.fanOut = new int[gate.fanOutM];
    for (int i = 0; i < gate.fanOutM; ++i) {
        iss >> gate.fanOut[i];
    }

    iss >> gate.name;
    return gate;
}

void parseFile() {
    std::string filename;
    std::cout << "Input the name of the text file you want to simulate" << std::endl;
    std::cin >> filename;

    std::ifstream input("gates.txt");
    std::string line;

    // Parse each line in the file
    while (std::getline(input, line)) {
        Gate gate = parseLine(line);
        gates.push_back(gate);
    }
    input.close();
}

void schedule_fanout(int g){
    int M = gates[g].fanOutM;
    for(int i=0 ; i < M ;i++ ){
        Gate fanout = gates[g].fanOut[i];
        
        if (gates[fanout].sched !=dummy_gate){
            int level = gate[fanout].level;
            gate[fanout].next = level[level];
            level[level]=fanout;
        }
    }
 }

while() {
    // Print logic values at PI, PO, and States
    std::cout << "PI" << std::endl;
    std::cout << "PO" << std::endl;
    // read inputs and schedule fanouts of changed inputs.

    // load next state and schedule fanout.

    i = 0;
    while( i < max level) {
        gaten = levels[i];
            while( gaten != dummy_gate ) {
            newstate = evaluate( gate);
                if( new_state != gate.state ) {
                    gate[gaten].state = new_state ;
                    schedule_fanout( gaten );
                }
            tempn = gaten ;
            gaten = gate[gaten].sched ;
            gate[gaten].sched = 0 ;
            gaten = tempn;
            }
        levels[i] = gaten ;
        i = i + 1 ;
    }
}

int main(){
    parseFile();


}