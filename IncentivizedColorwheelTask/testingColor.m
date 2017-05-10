function [comp1 comp2 comp3 comp4]=testingColor(trial)    %data2 or trial
I1=[];I2=[];I3=[];I4=[];U1=[];U2=[];U3=[];U4=[];

% load trial dmv load trial.mat/ load data dmv ColorFun_sx_sesx.mat
% als test trial, verander dan alle 'data2' in 'trial' en vv.
load ColorFun_s159_ses2.mat     %zet betreffende data in current folder!
%load trial.mat
for x=1:length(trial)
    for y=1:2
        if trial(x,y).type==0
            switch trial(x,y).setSize 
                case 1
                    I1=[I1; trial(x,y).colPie];
                case 2 
                    I2=[I2;trial(x,y).colPie];
                case 3
                    I3=[I3;trial(x,y).colPie];
                case 4
                    I4=[I4;trial(x,y).colPie];
            end
        elseif trial(x,y).type==2 || trial(x,y).type==22
            switch trial(x,y).setSize
                case 1
                    U1=[U1; trial(x,y).colPie];
                case 2 
                    U2=[U2;trial(x,y).colPie];
                case 3
                    U3=[U3;trial(x,y).colPie];
                case 4
                    U4=[U4;trial(x,y).colPie];
            end
        end
    end
end
% number of color categories (pies)
col=1:12;
I1c=histc(I1(:,1),col); U1c=histc(U1(:,2),col);
comp1=[I1c,U1c,col'];

I2c=histc(I2(:,1),col); U2c=histc(U2(:,3),col);
comp2=[I2c,U2c,col'];

I3c=histc(I3(:,1),col); U3c=histc(U3(:,4),col);
comp3=[I3c,U3c,col'];

I4c=histc(I4(:,1),col); U4c=histc(U4(:,5),col);
comp4=[I4c,U4c,col'];

allComp=[I1c I2c I3c I4c U1c U2c U3c U4c];
sumCol=sum(allComp,2);
