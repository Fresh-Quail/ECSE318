#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>

// gate state: 0, 1, X
struct gate_state{
    static const int s0 = 0;
    static const int s1 = 1;
    static const int sX = 2;

    static char to_char(int i);
    static int to_state(char c);
};

//
int gate_state::to_state(char c)
{
    switch(c)
    {
        case '0':
            return gate_state::s0;
        case '1':
            return gate_state::s1;
        default:
            return gate_state::sX;
    }
}

char gate_state::to_char(int i)
{
    switch(i)
    {
        case s0:
            return '0';
        case s1:
            return '1';
        case sX:
            return 'X';
        default:
            return '?';
    }
}

enum Gate_type{
    DFF,
    NOT,
    AND,
    NOR,
    OR,
    NAND,
    XOR,
    XNOR,
    BUFF,
    INPUT,
    OUTPUT,
    INVALID,

};

std::string gate_name[] = {"DFF", "NOT", "AND", "NOR", "OR", "NAND", "XOR", "XNOR" "BUFF", "INPUT", "OUTPUT", "VALID"};
struct gate_lookup{
    static int AND[3][3];
    static int OR[3][3];
    static int NAND[3][3];
    static int NOR[3][3];
    static int NOT[3];
};

Gate_type gate_to_enum(std::string s) {
    if(s == gate_name[0])
    {
        return Gate_type::DFF;
    }
    if(s == gate_name[1])
    {
        return Gate_type::NOT;
    }
    if(s == gate_name[2])
    {
        return Gate_type::AND;
    }
    if(s == gate_name[3])
    {
        return Gate_type::NOR;
    }
    if(s == gate_name[4])
    {
        return Gate_type::OR;
    }
    if(s == gate_name[5])
    {
        return Gate_type::NAND;
    }
    if(s == gate_name[6])
    {
        return Gate_type::XOR;
    }
    if(s == gate_name[7])
    {
        return Gate_type::XNOR;
    }
    if(s == gate_name[8])
    {
        return Gate_type::BUFF;
    }

    return Gate_type::INVALID;
}

int gate_lookup::AND[3][3] = {
    {gate_state:: s0, gate_state:: s0, gate_state:: s0},
    { gate_state:: s0, gate_state:: s1, gate_state:: sX},
    { gate_state:: s0, gate_state:: sX, gate_state:: sX}
    };

int gate_lookup::OR[3][3] = {
    {gate_state:: s0, gate_state:: s1, gate_state:: sX},
    { gate_state:: s1, gate_state:: s1, gate_state:: s1},
    { gate_state:: sX, gate_state:: s1, gate_state:: sX}
    };

int gate_lookup::NOR[3][3] = {
    {gate_state:: s1, gate_state:: s1, gate_state:: s1},
    { gate_state:: s1, gate_state:: s0, gate_state:: sX},
    { gate_state:: s1, gate_state:: sX, gate_state:: sX}
};

int gate_lookup::NAND[3][3] = {
    {gate_state:: s1, gate_state:: s1, gate_state:: s1},
    { gate_state:: s1, gate_state:: s0, gate_state:: sX},
    { gate_state:: s1, gate_state:: sX, gate_state:: sX}
};

int gate_lookup::NOT[3] = {
    gate_state:: s1, gate_state:: s0, gate_state:: sX
    };


struct Gate {
    Gate_type type;
    bool output;       
    int level;                
    int fanInN;               
    int fanOutM;              
    Gate** fanIn;
    Gate** fanOut;
    //Gate* sched = nullptr;
    std::string name;

    Gate() : fanIn(nullptr), fanOut(nullptr) {}

    // Destructor to release allocated memory
    ~Gate() {
        delete[] fanIn;
        delete[] fanOut;
    }
};





}
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


gate_state eval_state(Gate* gate) {
    Gate* g = gate;
    g->fanIn

}

int main(){
    parseFile();
