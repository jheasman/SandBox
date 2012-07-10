function broker

    winPercentage = 56;
    spread = [1.7, 1.9];
    numRaces = 20;
    startingSum = 1000;
    startingBet = startingSum / numRaces;
    
    winTotal = 0;
    netWin = 0;
    remRaces = numRaces;
    
    bet = startingBet;
    for numRounds = 1 : 20;
        outcome = randi(100,numRaces,1);
        odds = randi(spread*10,numRaces,1)/10;
        disp('new round');
        for raceIndex = 1 : numRaces
            if outcome(raceIndex) < winPercentage
                winTotal = winTotal + ((odds(raceIndex) * bet));

            end
        end
        fix(winTotal)
        netWin = netWin + (winTotal - (numRaces * bet));
        if netWin <= -500
            break;
        end
        %bet = fix(winTotal / numRaces)
        %numRaces = fix(winTotal / bet)
        winTotal = 0;
        plotWin(numRounds) = netWin;
    end
    disp('net win =');
    fix(netWin)
    plot(plotWin);
    