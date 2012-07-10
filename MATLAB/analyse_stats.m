function analyse_stats

    %clear all;
    %close all;
    fileName = 'soccer_premierleague_all.mat';
    temp = load(fileName);
    
    % load the bookie of interest
    bookie = 2;
    stats = temp.match;
    games = stats{1}.odds;
    numGames = length(games);
    assignin('base','games',games)
    
    gamesPlayed = zeros(6,1);
    homeWin = zeros(6,1);
    awayWin = zeros(6,1);
    drawWin = zeros(6,1);
    
    scatterHome = zeros(numGames,2);
    scatterAway = zeros(numGames,2);
    scatterDraw = zeros(numGames,2);
    
    oddsBand1 = 1.5;
    oddsBand2 = 1.75;
    oddsBand3 = 2.0;
    oddsBand4 = 2.5;
    oddsBand5 = 3.0;
    
    betPool = 1000;
    bet     = 50;
    betOdds = 1.55;
    
    betsPlayed = 0;
    numDraws = 0;
    
    for gameIndex = 1 : numGames
        
        homeWinOdds     = str2num(stats{bookie}.odds{gameIndex,1});
        awayWinOdds     = str2num(stats{bookie}.odds{gameIndex,2});
        drawOdds        = str2num(stats{bookie}.odds{gameIndex,3});
        homeAwayDiff    = abs(homeWinOdds - awayWinOdds);
        outcome         = stats{bookie}.odds{gameIndex,4};
        
        if homeWinOdds <= oddsBand1
            band = 1;
        elseif homeWinOdds <= oddsBand2
            band = 2;
        elseif homeWinOdds <= oddsBand3
            band = 3;
        elseif homeWinOdds <= oddsBand4
            band = 4;
        elseif homeWinOdds <= oddsBand5
            band = 5;
        else
            band = 6;
        end
                    
        if outcome == '"H"'
            homeWin(band)               = homeWin(band) + 1;
            scatterHome(gameIndex,1)    = drawOdds;
            scatterHome(gameIndex,2)    = homeAwayDiff;
            scatterHome(gameIndex,3)    = homeWinOdds;
        elseif outcome == '"A"'
            awayWin(band)               = awayWin(band) + 1;
            scatterAway(gameIndex,1)    = awayWinOdds;
            scatterAway(gameIndex,2)    = (homeAwayDiff);
            numDraws = numDraws + 1;
        elseif outcome == '"D"'
            drawWin(band)               = drawWin(band) + 1;
            scatterDraw(gameIndex,1)    = drawOdds;
            scatterDraw(gameIndex,2)    = homeAwayDiff;
            scatterDraw(gameIndex,3)    = homeWinOdds;
        end
        
        gamesPlayed(band) = gamesPlayed(band) + 1;
        
        playWins = 0;
        playDraw1 = 1;
        playDraw2 = 0;
        
        if playWins
            if homeWinOdds <= betOdds
                if abs(homeAwayDiff) > 2.5
                    if outcome == '"H"'
                        betPool = betPool + ( (bet*homeWinOdds) - bet );
                    else
                        betPool = betPool - bet;
                    end
                end
            end
        end
        if playDraw1
            if (drawOdds > 3.0) && (drawOdds < 4.0)
                if ~((homeWinOdds > 3.0) && (homeWinOdds < 4.0))
                    if ~((awayWinOdds > 3.0) && (awayWinOdds < 4.0))
                        if (homeAwayDiff > 2.5) && (homeAwayDiff < 5.0)
                            if outcome == '"D"'
                                betPool = betPool + ( (bet*drawOdds) - bet );
                                 betsPlayed = betsPlayed + 1;
                            else
                                betPool = betPool - bet;
                            end
                        end
                    end
                end
            end
        end
        if playDraw2
            if (homeAwayDiff > 5.0) && (homeAwayDiff < 10.0)
                if (drawOdds > 4.0) && (drawOdds < 6.0)
                    if (homeWinOdds > 1.5) || (awayWinOdds > 1.5)
                        if outcome == '"D"'
                            betPool = betPool + ( (bet*drawOdds) - bet );
                            betsPlayed = betsPlayed + 1;
                        else
                            betPool = betPool - bet;
                        end
                    end
                end
            end
        end
        winnings(gameIndex) = betPool;
        
    end
    
    assignin('base','games',gamesPlayed);
    assignin('base','homeWin',homeWin);
    assignin('base','scatterHome',scatterHome);
    assignin('base','scatterAway',scatterAway);
    assignin('base','scatterDraw',scatterDraw);
    
%     % Plot of the outcome % of homeWins, awayWins, Draws against odds
%     figure(1);
%     subplot(3,1,1);plot(100 * homeWin./gamesPlayed); title('homeWins odds vs outcome [%]');
%     subplot(3,1,2);plot(100 * awayWin./gamesPlayed); title('awayWins odds vs outcome [%]');
%     subplot(3,1,3);plot(100 * drawWin./gamesPlayed); title('drawWins odds vs outcome [%]');
    
%     % Scatter plot the Odds of homeWins, awayWins, draws vs homeAway Odds diff
%     figure(2);
%     xMax = max(max([scatterHome(:,1)' scatterAway(:,1)' scatterDraw(:,1)']));
%     yMax = max(max([scatterHome(:,2)' scatterAway(:,2)' scatterDraw(:,2)']));
%     subplot(3,1,1); scatter(scatterHome(:,1),scatterHome(:,2)); title('homeWins Odds vs OddsDiff');
%     xlim([0 xMax]); ylim([-yMax yMax]);
%     subplot(3,1,2); scatter(scatterAway(:,1),scatterAway(:,2)); title('awayWins Odds vs OddsDiff');
%     xlim([0 xMax]); ylim([-yMax yMax]);
%     subplot(3,1,3); scatter(scatterDraw(:,1),scatterDraw(:,2)); title('Draws Odds vs OddsDiff');
%     xlim([0 xMax]); ylim([-yMax yMax]);
    
    % Scatter plot the Odds of homeWins, awayWins, draws vs homeAway Odds diff
    figure(1);
    xMax = max(max([scatterHome(:,1)' scatterAway(:,1)' scatterDraw(:,1)']));
    yMax = max(max([scatterHome(:,2)' scatterAway(:,2)' scatterDraw(:,2)']));
    scatter(scatterHome(:,1),scatterHome(:,2),'b'); title('homeWins Odds vs OddsDiff');
    xlim([0 xMax]); ylim([-yMax yMax]); hold on;
    scatter(scatterAway(:,1),scatterAway(:,2),'g'); title('awayWins Odds vs OddsDiff');
    xlim([0 xMax]); ylim([-yMax yMax]);
    scatter(scatterDraw(:,1),scatterDraw(:,2),'r'); title('Draws Odds vs OddsDiff');
    xlim([0 xMax]); ylim([-yMax yMax]);
    grid on;
    
%     figure(2);
%     xMax = max(max([scatterHome(:,1)' scatterAway(:,1)' scatterDraw(:,1)']));
%     yMax = max(max([scatterHome(:,2)' scatterAway(:,2)' scatterDraw(:,2)']));
%     scatter(scatterHome(:,1),scatterAway(:,1),'b'); title('homeWins Odds vs OddsDiff');
%     xlim([0 xMax]); ylim([-yMax yMax]); hold on;
%     scatter(scatterAway(:,1),scatterDraw(:,1),'g'); title('awayWins Odds vs OddsDiff');
%     xlim([0 xMax]); ylim([-yMax yMax]);
%     scatter(scatterDraw(:,1),scatterDraw(:,2),'r'); title('Draws Odds vs OddsDiff');
%     xlim([0 xMax]); ylim([-yMax yMax]);
    grid on;    
    
    % output pilot betting scheme
    fix(betPool)
    figure(3);
    plot(winnings);
    betsPlayed
    numDraws
    
    
    
    
   