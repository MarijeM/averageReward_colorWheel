function [respDif,tau,thetaCorrect,radius,lureDif]=respDev(colortheta,probeColorCorrect,lureColor,respX,respY,rect)
%function that finds the deviance in degrees between participant response and correct
%color for the colorwheel memory task. We estimate the deviance via
%Colortheta,which is a struct with all colorwheel colors (arcs)and corresponding angles.
%thetaCorrect is the angle of the correct color and tau the angle created by the participant's response
%respX and respY are the coordinates of the ppt mouse click on the screen.
%if the participant did not respond deviance is assigned as not a number
% 
% SYNTAX
% [respDif,tau,thetaCorrect,radius]=RESPDEV(colortheta,probeColorCorrect,lureColor,respX,respY,pms)
% respDif                     Deviance in degrees between response and correct color on the colorwheel
% tau                         Angle created with participant's response
% thetaCorrect                Angle of the correct color
% radius                      Radius of the angle of the circle created with ppt response
% lureDif                     Deviance in degrees between response color and lure color (for U encoding, for I intervening)
% 
% colortheta                  struct with all angles and corresponding colors
% probeColorCorrect           correct color for this trial
% lureColor                   lure color for this trial 
% respX                       response X coordinate
% respY                       response Y coordinate
% pms                         parameteres defined in main script BeautifulColorwheel.m
% 

%coordinates of center of screen (fixation cross)
centerX=rect(3)/2;
centerY=rect(4)/2;

%%finds shade in colortheta that matches the correct
%%color of the probe and provides the angle theta of
%%the correct response
for n=1:length(colortheta)    
    if colortheta(n).color==probeColorCorrect
        thetaCorrect=colortheta(n).theta;
    elseif colortheta(n).color==lureColor
        thetaLure=colortheta(n).theta;
    end
end

%correcting for added offset in angles
if thetaCorrect>360
   thetaCorrect=thetaCorrect-360;
end

%%%finds radius of circle based on x and y coordinates,as every response
%provides a different radius. Then we can find the tau angle of the
%response. Initially tau is provided with the xx' but we need the angle
%with yy', so it is converted. If they pressed on the fixation cross
%no angle is created.
if respX==centerX && respY==centerY || isnan(respX) && isnan(respY)
    tau=NaN;
    radius=NaN;
    respDif=NaN;
    lureDif=NaN;    
else
radius=sqrt((respX-centerX)^2+(respY-centerY)^2); 
sinTau=(respY-centerY)/radius; 
cosTau=(respX-centerX)/radius;
                       
if cosTau>=0 
   tau=90-(-asind(sinTau)); 
elseif cosTau<0
   tau=180+90-(asind(sinTau)); 
end

%% Estimating response deviance from correct color angle(tau from theta).
%We always want the smaller angle created between response and correct
%color or response and lure, so we use mod.

respDif=abs(thetaCorrect-tau);
lureDif=abs(thetaLure-tau);

if respDif>180
   respDif=mod(360,respDif);
end

if lureDif>180
   lureDif=mod(360,lureDif);
end
end
 
end %function
