#include <iostream>
#include <fstream>
#include <sstream>
#include <unordered_map>
#include <vector>
#include <string>
#include <ctime>

using namespace std;

enum gate_type{AND, OR, NAND, NOR, NOT, BUFF, INPUT, OUTPUT, DFF, ERR};

int lookup_table[4][3][3] = {
        {{0, 0, 0},     //AND
        {0, 1, 2},
        {0, 2, 2}},

        {{0, 1, 2},     //OR
        {1, 1, 1},
        {2, 1, 2}},

        {{1, 1, 1},     //NAND
        {1, 0, 2},
        {1, 2, 2}},

        {{1, 0, 2},     //NOR
        {0, 0, 0},
        {2, 0, 2}},
};
int inv_table[3] = {1, 0, 4};       //NOT

// Table for input_scanning
int scan_table[4][2] = {
    {0, 0}, // AND table
    {1, 0}, // OR Table
    {0, 1}, // NAND Table
    {1, 1} // NOR Table
};

unordered_map<string, gate_type> str_to_enum = {{"and", AND}, {"or", OR}, {"nand", NAND}, {"nor", NOR}, {"not", NOT}, {"dff", DFF}, {"input", INPUT}, {"output", OUTPUT}, {"buff", BUFF}, {"err", ERR}};

struct Gate {
    gate_type type;         
    bool output;       
    int level;
    int fanInN;               
    int fanOutM;              
    Gate** fanIn;     
    Gate** fanOut;
    std::string name;
    bool sched = false;
    char state = 2;

    string gtype;
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
std::vector<Gate*> levels;
std::vector<Gate*> inputs;
std::vector<Gate*> dffs;
std::vector<Gate*> outputs; 
int max_level = -1;
bool lookup_mode = true;

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
    gates[name].gtype = type;
    gates[name].type = str_to_enum[type];
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
    }
    if(output)
        outputs.push_back(&gates[name]);
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
    getline(input, line);
    while (std::getline(input, line)) {
        parseLine(line);
    }
}

char evaluate(Gate* g){
    if(lookup_mode){   
        gate_type g_type = g->type;
        char state_fanin0 = g->fanIn[0]->state;

        if(g_type == NOT)
            return inv_table[state_fanin0];
        if (g_type == BUFF) 
            return state_fanin0;

        char state_fanin1 = g->fanIn[1]->state;
        char v = lookup_table[g_type][state_fanin0][state_fanin1];
        // cout << g->fanOut[0]->name << ": " << (int)state_fanin0 << " " << g->gtype << " " << (int)state_fanin1 << " = " << (int)v << endl;
        int N = g->fanInN;
        for(int i = 2; i < N ; i++) {
            state_fanin0 = g->fanIn[i]->state ;
            v = lookup_table[g_type][state_fanin0][v] ;
        }
        return v;
    } else{        
        gate_type type = g->type;
        if(type == NOT)
            return inv_table[g->fanIn[0]->state];
        if (type == BUFF) 
            return g->fanIn[0]->state;
            
        bool undef = false;
        for(int i=0; i < g->fanInN ;i++){
            char V = g->fanIn[i]->state;
            if(V == scan_table[type][0]){
                return(V ^ scan_table[type][1]);
            }
            if(V == 2) 
                undef = true;
        }
        if(undef)
            return 2;
        return !scan_table[type][0] ^ scan_table[type][1];
    }
}

void schedule_fanout(Gate* g){
    int M = g->fanOutM;
    Gate** fanout = g->fanOut;
    for(int i = 0; i < M; i++){
        if(fanout[i]->type == DFF){
            fanout[i]->state = g->state;
        }
        else if (!fanout[i]->sched){ // Add logic to filter out DFFs
            levels.push_back(fanout[i]);   // Add fanout to list
            fanout[i]->sched = true;
        }
    }
}

void simulate(string input_vec, ofstream* outfile){
    int i = 0;
    *outfile << "INPUT   :";
    for(char c : input_vec){
        inputs[i]->state = c - '0';
        *outfile << (int)inputs[i]->state;
        // schedule fanouts of changed inputs.
        schedule_fanout(inputs[i]);
        i = i + 1;
    }
    // Print output states
    *outfile << endl << "STATE   :";
    for(Gate* dff : dffs){
        *outfile << (int)dff->state;
    }

    *outfile << endl << "OUTPUT   :";
    for(Gate* out : outputs){
        *outfile << (int)out->state;
    }
    *outfile << endl << endl;

    for(Gate* dff : dffs){
        schedule_fanout(dff);
    }

    while(!levels.empty()){
        Gate* gate = levels.front();
        levels.erase(levels.begin());
        char new_state = evaluate(gate);
        if(new_state != gate->state) {
            gate->state = new_state;
            schedule_fanout(gate);
        }
        gate->sched = false;
    }
}

int main(){
    parseFile();
    string filename, mode;
    cout << "Type in the name of the vector file you want to use (w/ extension): ";
    cin >> filename;
    cout << "Type in the letter of the choice you want to use: " << endl << "1. Table Lookup" << endl << "2. Input Scanning" << endl;
    cin >> mode;
    lookup_mode = mode == "1";
    
    std::ifstream input(filename);
    std::string input_vec;
    std::ofstream outfile("sim.txt");
    clock_t start = clock();
    while(getline(input, input_vec)){
        simulate(input_vec, &outfile);
    }
    clock_t end = clock();
    cout << "Time taken to run the program: " << double(end - start) / CLOCKS_PER_SEC << " seconds" << endl;
    cout << "Output saved in sim.txt" << endl;
}