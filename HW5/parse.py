import argparse
import re

class Gate():
    def __init__(self):
        self.type = None
        self.output = False
        self.level = -1
        self.fanInN = 0
        self.fanin = []
        self.fanOutN = 0
        self.fanout = []
        self.name = ''
        self.output = False
        self.visited = False

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('filename', help="Name of the input file")
    args = parser.parse_args()

    level_list = []
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
                    gate.output = True
                    level_list.append([line[1].replace(';', ''), gate])
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
                gate.fanin = line[2][1:]
                gate.fanInN = len(gate.fanin)
                gate.fanout = line[2][0:1]
                gate.fanOutN = len(gate.fanout)
                gate.level = 0 if line[0] == 'dff' else -1
                gate.name = line[2][0:1][0]
                # Add gate to dictionary and do logic using its fanout as the name
                try:
                    gates[gate.fanout[0]]
                    # print(gate.type, gate.name, gate.fanout[0], "Exists")
                except KeyError:
                    print("Wasn't a wire?")
                gates[gate.fanout[0]] = gate
                # For each fan in on this gate, add this gate to the corresponding gate's fanout
                for fanin in gate.fanin:
                    gates[fanin].fanout.append(gate.fanout[0])
                    gates[fanin].fanOutN = gates[fanin].fanOutN + 1

    for idx, (gname, gate) in enumerate(level_list):
        if not gate.visited and gate.type != 'input': 
            # print(gname)
            # print("Children: ", end=' ')
            for fanin in gate.fanin:
                    # print(fanin, end=' ')
                    level_list.append([fanin, gates[fanin]])
        # print()
        gate.visited = True

    level_list.reverse()
    # print([x[0] for x in level_list])
    finished = False
    while not finished:
        finished = True
        for (gname, gate) in level_list:
            if gate.level != -1:
                # print(gname)
                # print("Gate levels:", end=' ')
                for fanout in gate.fanout:
                    if gate.type != 'dff' and fanout != gname:
                        gates[fanout].level = max(gates[fanout].level, gate.level + 1)
                        # print(fanout, ": ", gates[fanout].level, end=' -- ')
                # print()
            else: finished = False


    # print("\nType, Out, Lvl, fanInN")
    with open("gates.txt", 'w') as f:
        for gate in gates.values():
            print(gate.type, gate.output, gate.level, gate.fanInN, end=' ', file=f)
            for fanin in gate.fanin:
                print(fanin, end=' ', file=f)

            print(gate.fanOutN, end=' ', file=f)
            for fanout in gate.fanout:
                print(fanout, end=' ', file=f)
            print(gate.name, file=f)
                