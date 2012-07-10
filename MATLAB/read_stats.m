function read_stats

    fileName = 'soccer_premierleague_all.csv';
    fid = fopen(fileName);
    
    % list of csv indexes potining to data of interest
    division = 1;
    date = 2;
    homeTeam = 3;
    awayTeam = 4;
    FTR = 7;
    
    bet365HomeWinOdds = 24;
    bet365DrawOdds = 25;
    bet365AwayWinOdds = 26;
    
    BSHomeWinOdds = 51;
    BSDrawOdds = 52;
    BSAwayWinOdds = 53;
    
    BWHomeWinOdds = 27;
    BWDrawOdds = 28;
    BWAwayWinOdds = 29;
    
    GBHomeWinOdds = 30;
    GBDrawOdds = 31;
    GBAwayWinOdds = 32;
    
    IWHomeWinOdds = 33;
    IWDrawOdds = 34;
    IWAwayWinOdds = 35;
    
    LBHomeWinOdds = 36;
    LBDrawOdds = 37;
    LBAwayWinOdds = 38;
    
%     SOHomeWinOdds = 42;
%     SOAwayWinOdds = 44;
    
    SBHomeWinOdds = 39;
    SBDrawOdds = 40;
    SBAwayWinOdds = 41;

    SJHomeWinOdds = 45;
    SJDrawOdds = 46;
    SJAwayWinOdds = 47;
    
%     SYHomeWinOdds = 50;
%     SYAwayWinOdds = 52;

    line = '';
    outer = 0;
    while ischar(line)
        outer = outer + 1;
        line = fgetl(fid);
        csvLoc = find(line==',');
        if line == -1;
            break
        end
        for inner = 1 : 71
            if inner == 1
                startLoc = 1;
                endLoc = csvLoc(inner) - 1;
            elseif inner == 71
                startLoc = csvLoc(inner-1) + 1;
                endLoc = length(line);                                
            else
                startLoc = csvLoc(inner-1) + 1;
                endLoc = csvLoc(inner) - 1;
            end
            text{outer,inner} = line(startLoc:endLoc);           
        end
        if outer ~=1
            match{1}.odds{outer-1,1} = text{outer, bet365HomeWinOdds};
            match{1}.odds{outer-1,2} = text{outer, bet365AwayWinOdds};
            match{1}.odds{outer-1,3} = text{outer, bet365DrawOdds};
            match{1}.odds{outer-1,4} = text{outer, FTR};
            match{1}.odds{outer-1,5} = text{outer, homeTeam};
            match{1}.odds{outer-1,6} = text{outer, awayTeam};
            match{2}.odds{outer-1,1} = text{outer, BSHomeWinOdds};
            match{2}.odds{outer-1,2} = text{outer, BSAwayWinOdds};
            match{2}.odds{outer-1,3} = text{outer, BSDrawOdds};
            match{2}.odds{outer-1,4} = text{outer, FTR};
            match{2}.odds{outer-1,5} = text{outer, homeTeam};
            match{2}.odds{outer-1,6} = text{outer, awayTeam};            
            match{3}.odds{outer-1,1} = text{outer, BWHomeWinOdds};
            match{3}.odds{outer-1,2} = text{outer, BWAwayWinOdds};
            match{3}.odds{outer-1,3} = text{outer, BWDrawOdds};
            match{3}.odds{outer-1,4} = text{outer, FTR};
            match{3}.odds{outer-1,5} = text{outer, homeTeam};
            match{3}.odds{outer-1,6} = text{outer, awayTeam};            
            match{4}.odds{outer-1,1} = text{outer, GBHomeWinOdds};
            match{4}.odds{outer-1,2} = text{outer, GBAwayWinOdds};
            match{4}.odds{outer-1,3} = text{outer, GBDrawOdds};
            match{4}.odds{outer-1,4} = text{outer, FTR};
            match{4}.odds{outer-1,5} = text{outer, homeTeam};
            match{4}.odds{outer-1,6} = text{outer, awayTeam};            
            match{5}.odds{outer-1,1} = text{outer, IWHomeWinOdds};
            match{5}.odds{outer-1,2} = text{outer, IWAwayWinOdds};
            match{5}.odds{outer-1,3} = text{outer, IWDrawOdds};
            match{5}.odds{outer-1,4} = text{outer, FTR};
            match{5}.odds{outer-1,5} = text{outer, homeTeam};
            match{5}.odds{outer-1,6} = text{outer, awayTeam};            
            match{6}.odds{outer-1,1} = text{outer, LBHomeWinOdds};
            match{6}.odds{outer-1,2} = text{outer, LBAwayWinOdds};
            match{6}.odds{outer-1,3} = text{outer, LBDrawOdds};
            match{6}.odds{outer-1,4} = text{outer, FTR};
            match{6}.odds{outer-1,5} = text{outer, homeTeam};
            match{6}.odds{outer-1,6} = text{outer, awayTeam};            
            match{7}.odds{outer-1,1} = text{outer, SBHomeWinOdds};
            match{7}.odds{outer-1,2} = text{outer, SBAwayWinOdds};
            match{7}.odds{outer-1,3} = text{outer, SBDrawOdds};
            match{7}.odds{outer-1,4} = text{outer, FTR};
            match{7}.odds{outer-1,5} = text{outer, homeTeam};
            match{7}.odds{outer-1,6} = text{outer, awayTeam};            
            match{8}.odds{outer-1,1} = text{outer, SJHomeWinOdds};
            match{8}.odds{outer-1,2} = text{outer, SJAwayWinOdds};
            match{8}.odds{outer-1,3} = text{outer, SJDrawOdds};
            match{8}.odds{outer-1,4} = text{outer, FTR};
            match{8}.odds{outer-1,5} = text{outer, homeTeam};
            match{8}.odds{outer-1,6} = text{outer, awayTeam};            
        end
        
    end
    fclose(fid);
    assignin('base','match',match);
    
    matFileName = fileName(1:length(fileName)-4)
    save matFileName match
    
    
   