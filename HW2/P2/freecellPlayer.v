module freecellPlayer (clock,source,dest,win);
input	[3:0] source, dest;
input	clock;
output	win;

//Cards need 6 bits - 4 bits for number - 2 bit for suit
reg [5:0] tableau [7:0][12:0]; // 8 columns, 13 cards in each column
reg [5:0] free [3:0]; // 4 columns
reg [5:0] home [3:0]; // 4 columns

reg [3:0] headTableau [7:0];
wire [5:0] card, sourceCard, destCard;
reg legal;
legal = 1'b1;

assign win = home[3][3:0] == home[2][3:0] == home[1][3:0] == home[0][3:0] == 4'b1101;



always @ (posedge clock) begin
    case(source[3:2])
        2'b00, 2'b01: begin // Tableau logic
            // source[2:0] == column number
            // headTableau[i] == head location in column i
            // Check if column is empty
            card = tableau[source[2:0]][headTableau[source[2:0]]];
            headTableau[source[2:0]] = headTableau[source[2:0]] - 1;
        end

        2'b10: begin // Free cell logic
            // Check if freecell is empty
            card = free[source[1:0]];
        end
        
        default: begin
            card = 6'bx;
            legal = 1'b0;
        end
    endcase
    case(dest[3:2])
    2'b00, 2'b01: begin // Tableau logic
        // dest[2:0] == column number
        // tableau[dest[2:0]][headTableau[dest[2:0]]] == current head of destination column
        // card == new head of 
        headTableau[dest[2:0]] // location of the top of destination column
        tableau[dest[2:0]][headTableau[dest[2:0]]] // Head of dest column

        legal = tableau[dest[2:0]][headTableau[dest[2:0]]][3:0] + 6'b000001 == card & tableau[dest[2:0]][headTableau[dest[2:0]]][5:4]  ? 
            headTableau[dest[2:0]] + 1: headTableau[dest[2:0]]

        tableau[dest[2:0]][headTableau[dest[2:0]==]] = card;
    end

    2'b10: begin // Free cell logic
        // Check if freecell is empty
        card = free[source[1:0]];
    end
        
    endcase
end
endmodule



