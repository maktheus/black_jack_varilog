module blackJack(
    input wire clk,
    input wire reset,
    input wire stay,
    input wire hit,
    output wire win,
    output wire lose,
    output wire tie,
    output wire [7:0] dealerScoreDisplay,
    output wire [7:0] playerScoreDisplay
);

    wire [3:0] card;
    wire  [5:0] addrCard;

    romModule romModule_inst(
        .clk(clk),
        .addr(addrCard),
        .data(card)
    );

    blackJackStateMachineModule blackJackStateMachineModule_inst(
        .clk(clk),
        .reset(reset),
        .stay(stay),
        .hit(hit),
        .card(card),
        .win(win),
        .lose(lose),
        .tie(tie),
        .addrCard(addrCard),
        .dealerScoreDisplay(dealerScoreDisplay),
        .playerScoreDisplay(playerScoreDisplay)
    );

endmodule
