module blackJackStateMachineModule(
    input wire clk,
    input wire reset,
    input wire stay,
    input wire hit,
    input wire [3:0] card ,
    output reg win,
    output reg lose,
    output reg tie,
    output reg [7:0] dealerScoreDisplay,
    output reg [7:0] playerScoreDisplay,
    output reg [5:0] addrCard
);

    parameter S0 = 2'b00; // Inicio de jogo
    parameter S1 = 2'b01; // Turno do jogador 
    parameter S2 = 2'b10; // Turno do dealer
    parameter S3 = 2'b11; // Fim de jogo

    reg [1:0] state, nextState;
    reg dealerStay, playerStay;
    reg [5:0] playerScore, dealerScore;

 
    reg isAce;
    reg  [3:0] cardValue;

    initial begin
        addrCard = 4'd0;
        state = S0;
        nextState = S0;
        playerScoreDisplay = 8'b0;
        dealerScoreDisplay = 8'b0;
        playerScore = 6'd0;
        dealerScore = 6'd0;
        playerStay = 1'b0;
        dealerStay = 1'b0;
        win = 0; lose = 0; tie = 0;
    end

    always@(posedge clk or posedge reset) begin
        if (reset)  state = S0;
        else        state = nextState;
    end

    always@(state or hit or stay or reset) begin
        win = 0; lose = 0; tie = 0;
        dealerScoreDisplay = 8'b0;
        playerScoreDisplay = 8'b0;
        nextState = state;

        case(state)
            S0: begin
                addrCard = 4'd0;
                dealerScoreDisplay = 8'b0;
                playerScoreDisplay = 8'b0;
                playerScore = 6'd0;
                dealerScore = 6'd0;
                nextState = S1;
                playerStay = 1'b0;
                dealerStay = 1'b0;
                $display("Iniciando jogo");
            end

            S1: begin
                if (playerStay && dealerStay) begin
                    nextState = S3;
                    $display("Fim de jogo");
                end else begin
                    if (hit) begin
                        cardValue = card;
                        isAce =( card == 4'b0001);
                        cardValue = isAce ? (playerScore + 11 <= 6'd21 ? 6'd11 : 6'd1) : card;
                        playerScore = playerScore + cardValue;
                        playerScoreDisplay = playerScore;
                        addrCard = addrCard + 4'd1;
                        $display("Player score: %d", playerScore);
                        if (playerScore > 6'd21) begin
                            nextState = S3;
                        end else begin
                            nextState = S2;
                        end
                    end
                    if (stay) begin
                        nextState = S2;
                        playerStay = 1'b1;
                    end
                end
            end

            S2: begin
                if (playerStay && dealerStay) begin
                    nextState = S3;
                end else begin
                    if (dealerScore < 6'd17) begin
                        cardValue = card;

                        isAce =( card == 4'b0001);
                        cardValue = isAce ? (dealerScore + 11 <= 6'd21 ? 6'd11 : 6'd1) : card;
                        dealerScore = dealerScore + cardValue;
                        dealerScoreDisplay = dealerScore;
                        addrCard = addrCard + 4'd1;
                        if (dealerScore > 6'd21) begin
                            nextState = S3;
                        end else begin
                            nextState = S1;
                        end
                    end else begin
                        nextState = S2;
                        dealerStay = 1'b1;
                    end
                end
            end

            S3 : begin
                if (dealerScore > 6'd21) begin
                    win = 1;
                end else if (playerScore > 6'd21) begin
                    lose = 1;
                end else if (playerScore > dealerScore) begin
                    win = 1;
                end else if (playerScore < dealerScore) begin
                    lose = 1;
                end else begin
                    tie = 1;
                end
            end
        endcase
    end

endmodule