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