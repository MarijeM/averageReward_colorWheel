function [offers] = calculateRewardOnOffer(pms)
%The incentivized version of the color wheel requires a reward manipulation
%like in the Beierholm and Otto&Daw papers: Gaussian random walk (sd = 30).
%output are the rewards on offer for one block of n_trials trials. 

%Lieke Hofmans, February 2018

%% settings

%set reward limits
min_limit       = 5;
max_limit       = 95;

%set number of trials
n_trials   = pms.numTrials; %trials per block

%set parameters Gaussian
mu         = 0;
sd        = 20;

%% Gaussian random walk
offers = randi([min_limit,max_limit],1); %initial reward;
for i=2:n_trials
    offers(i,1) = round(offers(i-1,1) + randn(1)*sd+mu);
    if offers (i,1) > max_limit
       offers(i,1) = max_limit - ((offers(i,1) - max_limit)); %please check rewards. If you set the sd too high, it is possible that the rewards fall outside of the boundaries using this script. If so, adjust script. 
    elseif offers (i,1) < min_limit
       offers(i,1) = min_limit + ((min_limit - offers(i,1)));
    end   
end

end 




