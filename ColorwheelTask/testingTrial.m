function [U I I1 I2 I3 I4 U1 U2 U3 U4]=testingTrial(trial)  %data of trial

% load trial dmv load trial.mat/ load data dmv ColorFun_sx_sesx.mat
% als test trial, verander dan alle 'data' in 'trial' en vv.
load ColorFun_s159_ses1.mat
U=zeros(size(trial,2),1);
I=zeros(size(trial,2),1);
% UL=zeros(size(data,2),1);
I1=zeros(size(trial,2),1);
I2=zeros(size(trial,2),1);
I3=zeros(size(trial,2),1);
I4=zeros(size(trial,2),1);
U1=zeros(size(trial,2),1);
U2=zeros(size(trial,2),1);
U3=zeros(size(trial,2),1);
U4=zeros(size(trial,2),1);
% UL1=zeros(size(data,2),1);
% UL2=zeros(size(data,2),1);
% UL3=zeros(size(data,2),1);
% UL4=zeros(size(data,2),1);

for x=1:length(trial)
    for y=1:size(trial,2)
      
        if trial(x,y).type==2 || trial(x,y).type==22

           
            U(y)=U(y)+1;
             switch trial(x,y).setSize    %setSize if trial, setsize if data
                 case 1
                    U1(y)=U1(y)+1;
                 case 2
                    U2(y)=U2(y)+1;
                 case 3
                    U3(y)=U3(y)+1;
                 case 4
                    U4(y)=U4(y)+1;
             end
             
        elseif trial(x,y).type==0
             I(y)=I(y)+1;
             switch trial(x,y).setSize    %setSize if trial, setsize if data
                case 1
                    I1(y)=I1(y)+1;
                 case 2
                    I2(y)=I2(y)+1;
                 case 3
                    I3(y)=I3(y)+1;
                 case 4
                    I4(y)=I4(y)+1;
             end
     
        
%         elseif data(x,y).type==2 %|| data(x,y).type==2
%            
%             UL(y)=UL(y)+1;
%              switch data(x,y).setsize
%                  case 1
%                     UL1(y)=UL1(y)+1;
%                  case 2
%                     UL2(y)=UL2(y)+1;
%                  case 3
%                     UL3(y)=UL3(y)+1;
%                  case 4
%                     UL4(y)=UL4(y)+1;
%              end
        end

    end
end
end
        
            
        