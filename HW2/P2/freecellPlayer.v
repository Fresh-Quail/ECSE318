module freecellPlayer (clock,source,dest,win);
input	[3:0] source, dest;
input	clock;
output	win;

//Cards need 6 bits - 4 bits for number - 2 bit for suit
reg [5:0] tableau [7:0][12:0]; // 8 columns, 13 cards in each column
reg [5:0] free [3:0]; // 4 columns
reg [3:0] home [3:0]; // 4 columns
reg slegal, dlegal; // Flags for legal moves for source and dest respectively

reg [3:0] headTableau [7:0]; //Indicates the first empty position in each column of the tableau
reg [5:0] card; // Represents the card that is to be moved to the destination

assign win = home[3] == 4'b1101 && home[2] == 4'b1101 && home[1] == 4'b1101 && home[0] == 4'b1101;  // Check if all home cells are full (have 13 as the card) for the win conditions

always @ (source or dest or negedge clock) begin
    case(source[3:2])
        2'b00, 2'b01: begin // Tableau logic
            // source[2:0] == column number
            // headTableau[i] == head location in column i
            // Check if column is empty
            if(headTableau[source[2:0]] == 4'b0)
                slegal = 1'b0;
            else begin
                slegal = 1'b1;
                card = tableau[source[2:0]][headTableau[source[2:0]] - 1'b1];  // card location (column)(row)
            end
        end

        2'b10: begin // Free cell logic
            // Check if freecell is empty
            slegal = ~(free[source[1:0]] == 6'b000000);
            card = free[source[1:0]];
        end
        
        default: begin
            slegal = 1'b0;
            card = 6'b000000;
        end
    endcase
end
    
always @ (source or dest or card) begin
    case(dest[3:2])
    2'b00, 2'b01: begin // Tableau logic
        // dest[2:0] == column number
        // tableau[dest[2:0]][headTableau[dest[2:0]]] == current head of destination column (empty)
        // headTableau[dest[2:0]] // location of the top of destination column
        // tableau[dest[2:0]][headTableau[dest[2:0]]] // Head of dest column

        // tableau[dest[2:0]][headTableau[dest[2:0]]][5] ^ card[6] = 1 if top column card different suit than 'card'
        // If the card is 1 less than the destination and the suits are different, or the destination column is empty, the move is legal
        if(headTableau[dest[2:0]] == 4'b0 || (tableau[dest[2:0]][headTableau[dest[2:0]] - 1'b1][3:0] == card[3:0] + 4'b0001 && tableau[dest[2:0]][headTableau[dest[2:0]] - 1'b1][5] ^ card[5]))
            dlegal = 1'b1;
        else
            dlegal = 1'b0;
    end

    2'b10: begin // Free cell logic
        // Check if freecell is empty
        if(free[dest[1:0]] == 6'b000000)
            dlegal = 1'b1; //legal if empty
        else
            dlegal = 1'b0;
    end

    2'b11: begin // Home cell logic
        // If the home cell card of same suit is one less that the card we want to move
        if((home[card[5:4]] + 4'b0001) == card[3:0]) // card[5:4] == suit - same suit always is in the same home cell
            dlegal = 1'b1;
        else
            dlegal = 1'b0;
    end
    endcase
end

always @ (posedge clock) begin
    if(slegal & dlegal) begin
        if(source[3] == 1'b0) begin // If the source was in the tableau
            tableau[source[2:0]][headTableau[source[2:0]] - 1'b1] = 6'b000000; // If legal, remove card
            headTableau[source[2:0]] = headTableau[source[2:0]] - 1'b1; // Decrease position by 1
        end else begin
            free[source[1:0]] = 6'b000000; // Remove card
        end

        
        if(dest[3] == 1'b0) begin           // If destination is tableau, not freecell or homecell
            tableau[dest[2:0]][headTableau[dest[2:0]]] = card; // Place the card
            headTableau[dest[2:0]] = headTableau[dest[2:0]] + 1'b1; // Increase head position by 1
        end else if (dest[3:2] == 2'b10)    // Destination is freecell
            free[dest[1:0]] = card;
        else                                // Destination is homecell
            home[card[5:4]] = card[5:0];
    end
end

// ---- local params
    localparam s=2'b00; //spade
    localparam c=2'b01; //club
    localparam h=2'b10; //heart
    localparam d=2'b11; //diomond

    localparam ace   = 4'b0001;
    localparam two   = 4'b0010;
    localparam three = 4'b0011;
    localparam four  = 4'b0100;
    localparam five  = 4'b0101;
    localparam six   = 4'b0110;
    localparam seven = 4'b0111;
    localparam eight = 4'b1000;
    localparam nine  = 4'b1001;
    localparam ten   = 4'b1010;
    localparam jack  = 4'b1011;
    localparam queen = 4'b1100;
    localparam king  = 4'b1101;

// Initialize the game state
integer i, j;
initial begin
    
    for (i = 0; i < 8; i = i + 1) begin
        for (j = 0; j < 13; j = j + 1) begin
            tableau[i][j] = 6'b0;
        end
    end
    free[0] = 6'b0;
    free[1] = 6'b0;
    free[2] = 6'b0;
    free[3] = 6'b0;

    home[0] = 4'b0;
    home[1] = 4'b0;
    home[2] = 4'b0;
    home[3] = 4'b0;

    // Col 1
    tableau[0][0] = {s, four};
    tableau[0][1] = {d, jack};
    tableau[0][2] = {d, ten};
    tableau[0][3] = {d, six};
    tableau[0][4] = {s, three};
    tableau[0][5] = {d, ace};
    tableau[0][6] = {h, ace};
    headTableau[0] = 4'b0111;

    // Col 2
    tableau[1][0] = {s, five};
    tableau[1][1] = {s, ten};
    tableau[1][2] = {h, eight};
    tableau[1][3] = {c, four};
    tableau[1][4] = {h, six};
    tableau[1][5] = {h, king};
    tableau[1][6] = {h, two};
    headTableau[1] = 4'b0111;

    // Col 3
    tableau[2][0] = {s, jack};
    tableau[2][1] = {c, seven};
    tableau[2][2] = {c, nine};
    tableau[2][3] = {c, six};
    tableau[2][4] = {c, two};
    tableau[2][5] = {s, king};
    tableau[2][6] = {c, ace};
    headTableau[2] = 4'b0111;

    // Col 4
    tableau[3][0] = {h, four};
    tableau[3][1] = {s, ace};
    tableau[3][2] = {c, queen};
    tableau[3][3] = {c, five};
    tableau[3][4] = {s, seven};
    tableau[3][5] = {h, nine};
    tableau[3][6] = {s, eight};
    headTableau[3] = 4'b0111;

    // Col 5
    tableau[4][0] = {d, queen};
    tableau[4][1] = {h, jack};
    tableau[4][2] = {s, queen};
    tableau[4][3] = {s, six};
    tableau[4][4] = {d, two};
    tableau[4][5] = {s, nine};
    //tableau[4][6] = {};
    headTableau[4] = 4'b0110;

    // Col 6
    tableau[5][0] = {d, five};
    tableau[5][1] = {d, king};
    tableau[5][2] = {c, three};
    tableau[5][3] = {d, nine};
    tableau[5][4] = {h, three};
    tableau[5][5] = {s, two};
    //tableau[4][6] = {}; 
    headTableau[5] = 4'b0110;

    // Col 7
    tableau[6][0] = {h, five};
    tableau[6][1] = {d, three};
    tableau[6][2] = {h, queen};
    tableau[6][3] = {d, seven};
    tableau[6][4] = {c, king};
    tableau[6][5] = {c, ten};
    //tableau[6][6] = {};
    headTableau[6] = 4'b0110;

    // Col 8
    tableau[7][0] = {c, jack};
    tableau[7][1] = {d, four};
    tableau[7][2] = {h, ten};
    tableau[7][3] = {c, eight};
    tableau[7][4] = {h, seven};
    tableau[7][5] = {d, eight};
    // tableau[7][6] = {};   
    headTableau[7] = 4'b0110;

end
endmodule