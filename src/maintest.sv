module blackJack_tb;

    reg clk;
    reg reset;
    reg stay;
    reg hit;
    wire win;
    wire lose;
    wire tie;
    wire [7:0] dealerScoreDisplay;
    wire [7:0] playerScoreDisplay;

    blackJack blackJack_inst(
        .clk(clk),
        .reset(reset),
        .stay(stay),
        .hit(hit),
        .win(win),
        .lose(lose),
        .tie(tie),
        .dealerScoreDisplay(dealerScoreDisplay),
        .playerScoreDisplay(playerScoreDisplay)
    );

    initial begin
        clk = 0;
        reset = 1;
        stay = 0;
        hit = 0;

        #10 reset = 0; // Desativa o reset
        #5 stay = 1; // O jogador escolhe ficar
        #5 clk = 1; // Ativa o clock
        #5 clk = 0; // Desativa o clock
        #5 clk = 1; // Ativa o clock
        #5 clk = 0; // Desativa o clock
        #5 clk = 1; // Ativa o clock
        #5 clk = 0; // Desativa o clock

        // Resultados esperados: win = 1, lose = 0, tie = 0
        $display("Win: %b, Lose: %b, Tie: %b", win, lose, tie);
        $display("Dealer Score: %d, Player Score: %d", dealerScoreDisplay, playerScoreDisplay);

        #5 stay = 0; // O jogador escolhe continuar
        #5 clk = 1; // Ativa o clock
        #5 clk = 0; // Desativa o clock
        #5 clk = 1; // Ativa o clock
        #5 clk = 0; // Desativa o clock

        // Resultados esperados: win = 0, lose = 1, tie = 0
        $display("Win: %b, Lose: %b, Tie: %b", win, lose, tie);
        $display("Dealer Score: %d, Player Score: %d", dealerScoreDisplay, playerScoreDisplay);

        #5 stay = 1; // O jogador escolhe ficar
        #5 clk = 1; // Ativa o clock
        #5 clk = 0; // Desativa o clock

        // Resultados esperados: win = 0, lose = 0, tie = 1
        $display("Win: %b, Lose: %b, Tie: %b", win, lose, tie);
        $display("Dealer Score: %d, Player Score: %d", dealerScoreDisplay, playerScoreDisplay);

        $finish;
    end

    always #5 clk = ~clk;

endmodule
