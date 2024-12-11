#include <iostream>
#include <fstream>
#include <sstream>
#include <unordered_map>
#include <vector>
#include <string>

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

    Gate() : fanIn(nullptr), fanOut(nullptr) {}

    // Destructor to release allocated memory
    ~Gate() {
        delete[] fanIn;
        delete[] fanOut;
    }
};

void printGate(const Gate &g) {
    std::cout << " type: " << g.type 
              << " output: " << (g.output ? "true" : "false") 
              << " level: " << g.level 
              << " fanInN: " << g.fanInN 
              << " fanOutM: " << g.fanOutM 
              << " name: " << g.name << std::endl;
}

Gate dummy_gate;
std::unordered_map<std::string, Gate> gates;
std::vector<std::vector<Gate*>> levels;
int max_level = -1;

void parseLine(const std::string& line) {
    std::istringstream iss(line);

    std::string type, name, gname;
    int fanInN, fanOutM, level;
    bool output;

    iss >> type >> output >> level >> fanInN;

    cout << type << output << level << " hm " << fanInN << endl;
    Gate** fanIn = new Gate*[fanInN];
    for (int i = 0; i < fanInN; i++) {
        iss >> gname;
        fanIn[i] = &gates[gname];
    }

    iss >> fanOutM;
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
    gates[name].type = type;
    gates[name].fanOutM = fanOutM;
    gates[name].fanOut = fanOut;
    std::cout << "Hm" << std::endl;
    printGate(gates[name]);
}

void parseFile() {
    std::ifstream input("gates.txt");
    std::string line;

    // Parse each line in the file
    while (std::getline(input, line)) {
        std::cout << line << std::endl;
        parseLine(line);
    }
    input.close();
}

void schedule_fanout(Gate g){
    int M = g.fanOutM;
    Gate** fanout = g.fanOut;
    for(int i=0 ; i < M; i++){
        if (!fanout[i]->sched){ // Add logic to filter out DFFs
            levels[fanout[i]->level].push_back(fanout[i]);   // Add fanout to 
        }
    }
 }

// void simulate(){
//         // Print logic values at PI, PO, and States
//         std::cout << "PI" << std::endl;
//         std::cout << "PO" << std::endl;
//         // read inputs and schedule fanouts of changed inputs.

//         // load next state and schedule fanout.

//     int i = 0;
//     while( i < max_level) {
//         gaten = levels[i];
//             while( gaten != dummy_gate ) {
//             newstate = evaluate( gate);
//                 if( new_state != gate.state ) {
//                     gate[gaten].state = new_state ;
//                     schedule_fanout( gaten );
//                 }
//             tempn = gaten ;
//             gaten = gate[gaten].sched ;
//             gate[gaten].sched = 0 ;
//             gaten = tempn;
//             }
//         levels[i] = gaten ;
//         i = i + 1 ;
//     }
// }

// void evaluate(){
//     bool uvalue = false;
//     for(int i =0; i <)
// }
int main(){
    parseFile();


}