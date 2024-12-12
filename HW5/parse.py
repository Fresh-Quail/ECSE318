import argparse
import re

class Gate():
    def __init__(self):
        self.type = None
        self.level = -1
        self.fanInN = 0
        self.fanin = []
        self.fanOutN = 0
        self.fanout = []
        self.name = ''
        self.output = 'false'

def make_buffer(fanin, name):
    buf = Gate()
    buf.type = 'buff'
    buf.level = -1
    buf.fanInN = 1
    buf.fanOutN = 1
    buf.fanin = [fanin]
    buf.fanout = [name]
    buf.name = f"BUF{gates[fanin].fanOutN}{fanin}"
    return buf

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('filename', help="Name of the input file")
    args = parser.parse_args()

    level_list = []
    max_level = -1
    with open(args.filename, 'r') as file:
        gates = dict()
        while (line:=file.readline().strip()) != 'endmodule':
            line = re.sub(r"\s+", " ", line)

            if line == '' or line.split()[0] == 'module' : # Waits until the first module line
                continue

            while not line.endswith(';'):   # force multiple lines into one
                x = (file.readline().strip())
                line = line.join(["", x])

            line = line.split()
            # # Case statements
            # line[0] -> gate type : line[1] -> gate name : line[2] -> gate args
            if line[0] == 'input' or line[0] == 'output':
                gate = Gate()
                gate.type = line[0]
                if line[0] == 'output':
                    gate.output = 'true'
                else:
                    level_list.append(gate)
                gate.fanInN = 0
                gate.fanin = []
                gate.fanOutN = 0
                gate.fanout = []# (line[1].replace(';', '')) if isinstance(line[1].replace(';', ''), list) else [line[1].replace(';', '')]
                gate.level = 0 if line[0] == 'input' else -1
                gate.name = line[1].replace(';', '')
                # Add gate to dictionary and do logic using its fanout as the name
                gates[gate.name] = gate
                # For each fan in on this gate, add this gate to the corresponding gate's fanout

            elif line[0] == 'wire':
                for wire in line[1].replace(';', '').split(','):
                    gate = Gate()
                    gate.type = line[0]
                    gate.fanInN = 0
                    gate.fanin = []
                    gate.fanOutN = 0
                    gate.fanout = []
                    gate.level = -1
                    gate.name = wire
                    # Add gate to dictionary and do logic using its fanout as the name
                    gates[gate.name] = gate

            elif line[0] != 'wire':
                line[2] = re.sub(r"[();]", "", line[2]).split(',') # Format the gate arguments
                gate = gates.get(line[2][0:1][0], Gate())
                gate.type = line[0]
                gate.fanin.extend(line[2][1:])
                gate.fanInN = len(gate.fanin)
                if line[0] == 'dff':
                    gate.level = 0
                    level_list.append(gates[gate.name]) 
                else:
                    gate.level = -1
                # Add gate to dictionary and do logic using its fanout as the name
                gates[gate.name] = gate
                # For each fan in on this gate, add this gate to the corresponding gate's fanout
                for idx, fanin in enumerate(gate.fanin):
                    if gates[fanin].fanOutN > 0:
                        if gates[fanin].fanOutN == 1:
                            buf = make_buffer(fanin, gates[fanin].fanout[0])
                            # Swap the first wire on the fanin gate, to the buffer
                            index = gates[gates[fanin].fanout[0]].fanin.index(fanin)
                            gates[gates[fanin].fanout[0]].fanin[index] = buf.name
                            gates[fanin].fanout[0] = buf.name
                            # Swap the fanin of that gate, to the buffer
                            gates[fanin].fanout[0] = buf.name
                            gates[buf.name] = buf
                        # Add the second buffer
                        gates[fanin].fanOutN = gates[fanin].fanOutN + 1
                        buf = make_buffer(fanin, gate.name)
                        gates[fanin].fanout.append(buf.name)
                        gate.fanin[idx] = buf.name
                        gates[buf.name] = buf
                        
                    else:
                        gates[fanin].fanout.append(gate.name)
                        gates[fanin].fanOutN = gates[fanin].fanOutN + 1
    
    for gate in level_list:
        for fanout in gate.fanout:
            if gates[fanout].type != 'dff':
                level_list.append(gates[fanout])
                gates[fanout].level = max(gates[fanout].level, gate.level + 1)
                max_level = max(max_level, gates[fanout].level)

    # print("\nType, Out, Lvl, fanInN")
    with open("gates.txt", 'w') as f:
        print("Max_level: ", max_level, file=f)
        print("Total_gates: ", len(gates.keys()), file=f)
        for gate in gates.values():
            print(gate.type, gate.output, gate.level, gate.fanInN, end=' ', file=f)
            for fanin in gate.fanin:
                print(fanin, end=' ', file=f)

            print(gate.fanOutN, end=' ', file=f)
            for fanout in gate.fanout:
                print(fanout, end=' ', file=f)
            print(gate.name, file=f)
                