function blackjack()
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
    
    % Player's turn
    while true
        playerScore = calculateHandValue(playerHand);
        if playerScore > 21
            fprintf('Bust! Your hand: %s\n', displayHand(playerHand));
            fprintf('Your score: %d\n', playerScore);
            fprintf('You lose!\n');
            return;
        end
        
        choice = input('Do you want to hit or stand? (h/s): ', 's');
        if choice == 's'
            break;
        end
        
        playerHand = [playerHand, deck(1)];
        deck(1) = [];
        fprintf('Your hand: %s\n', displayHand(playerHand));
    end
    
    % Dealer's turn
    fprintf('Dealer turn\n');
    while calculateHandValue(dealerHand) < 17
        dealerHand = [dealerHand, deck(1)];
        deck(1) = [];
    end
    
    % Display final hands and scores
    playerScore = calculateHandValue(playerHand);
    dealerScore = calculateHandValue(dealerHand);
    
    fprintf('Your hand: %s\n', displayHand(playerHand));
    fprintf('Dealer hand: %s\n', displayHand(dealerHand));
    
    fprintf('Your score: %d\n', playerScore);
    fprintf('Dealer score: %d\n', dealerScore);
    
    if dealerScore > 21 || (playerScore <= 21 && playerScore > dealerScore)
        fprintf('You win!\n');
    elseif playerScore < dealerScore && dealerScore <= 21
        fprintf('You lose!\n');
    else
        fprintf('Its a tie!\n');
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