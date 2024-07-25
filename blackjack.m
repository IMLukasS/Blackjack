function blackjack()
    initialFunds = 100;  % Starting funds for the player
    playerFunds = initialFunds;
    
    while playerFunds > 0
        fprintf('You have $%d\n', playerFunds);
        bet = input('Place your bet: $');
        
        if bet > playerFunds || bet <= 0
            fprintf('Invalid bet amount. Try again.\n');
            continue;
        end
        
        % Initialize card deck
        deck = initDeck();
        deck = shuffleDeck(deck);
        
        % Deal initial cards
        playerHand = deck(1:2);
        dealerHand = deck(3:4);
        deck(1:4) = []; % Remove dealt cards from the deck
        
        % Display hands
        fprintf('Your hand: %s\n', displayHand(playerHand));
        fprintf('Dealer shows: %s\n', displayCard(dealerHand{1}));
        
        % Check for Blackjack on the initial deal
        if calculateHandValue(playerHand) == 21
            fprintf('Blackjack! You win 3x your bet!\n');
            playerFunds = playerFunds + 3 * bet;
            fprintf('New funds: $%d\n', playerFunds);
            
            if playerFunds > 0
                keepPlaying = input('Do you want to play another round? (y/n): ', 's');
                if keepPlaying == 'n'
                    fprintf('Thanks for playing! You leave with $%d\n', playerFunds);
                    break;
                else
                    continue;
                end
            else
                fprintf('You are out of funds. Game over!\n');
                break;
            end
        end
        
        % Player's turn
        while true
            playerScore = calculateHandValue(playerHand);
            if playerScore == 21
                fprintf('You have 21! Your turn ends.\n');
                break;
            elseif playerScore > 21
                fprintf('Bust! Your hand: %s\n', displayHand(playerHand));
                fprintf('Your score: %d\n', playerScore);
                playerFunds = playerFunds - bet;
                fprintf('You lose! Remaining funds: $%d\n', playerFunds);
                break;
            end
            
            choice = input('Do you want to hit or stand? (h/s): ', 's');
            if choice == 's'
                break;
            elseif choice == 'h'
                playerHand = [playerHand, deck(1)];
                deck(1) = [];
                fprintf('Your hand: %s\n', displayHand(playerHand));
            else
                fprintf('Invalid choice. Please press ''h'' to hit or ''s'' to stand.\n');
            end
        end
        
        if playerScore <= 21
            % Dealer's turn
            fprintf('Dealer''s turn\n');
            while calculateHandValue(dealerHand) < 17
                dealerHand = [dealerHand, deck(1)];
                deck(1) = [];
            end
            
            % Display final hands and scores
            playerScore = calculateHandValue(playerHand);
            dealerScore = calculateHandValue(dealerHand);
            
            fprintf('Your hand: %s\n', displayHand(playerHand));
            fprintf('Dealer''s hand: %s\n', displayHand(dealerHand));
            
            fprintf('Your score: %d\n', playerScore);
            fprintf('Dealer''s score: %d\n', dealerScore);
            
            if dealerScore > 21 || (playerScore <= 21 && playerScore > dealerScore)
                playerFunds = playerFunds + bet;
                fprintf('You win! New funds: $%d\n', playerFunds);
            elseif playerScore < dealerScore && dealerScore <= 21
                playerFunds = playerFunds - bet;
                fprintf('You lose! Remaining funds: $%d\n', playerFunds);
            else
                fprintf('It''s a tie! Funds remain: $%d\n', playerFunds);
            end
        end
        
        if playerFunds > 0
            keepPlaying = input('Do you want to play another round? (y/n): ', 's');
            if keepPlaying == 'n'
                fprintf('Thanks for playing! You leave with $%d\n', playerFunds);
                break;
            end
        else
            fprintf('You are out of funds. Game over!\n');
        end
    end
end

function deck = initDeck()
    % Initialize a standard 52-card deck
    suits = {'H', 'D', 'C', 'S'}; % Hearts, Diamonds, Clubs, Spades
    values = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'};
    deck = cell(1, 52);
    index = 1;
    
    for i = 1:length(suits)
        for j = 1:length(values)
            deck{index} = [values{j} suits{i}];
            index = index + 1;
        end
    end
end

function shuffledDeck = shuffleDeck(deck)
    % Shuffle the deck
    shuffledDeck = deck(randperm(numel(deck)));
end

function value = calculateHandValue(hand)
    % Calculate the value of a hand
    value = 0;
    aceCount = 0;
    
    for i = 1:length(hand)
        card = hand{i}(1:end-1); % Strip the suit
        if ismember(card, {'J', 'Q', 'K'})
            value = value + 10;
        elseif strcmp(card, 'A')
            aceCount = aceCount + 1;
            value = value + 11;
        else
            value = value + str2double(card);
        end
    end
    
    % Adjust for aces
    while value > 21 && aceCount > 0
        value = value - 10;
        aceCount = aceCount - 1;
    end
end

function displayStr = displayHand(hand)
    % Create a string representation of a hand
    displayStr = strjoin(hand, ', ');
end

function displayStr = displayCard(card)
    % Create a string representation of a single card
    displayStr = card;
end
