%Her passte 1 transmission

clear;clc;
format long
tic

numberOfPasses = [2 4 10 15]; %number of satellite passes
satPassNum = numberOfPasses(3); %selected sat pass case
Days = 1; %simulation day duration
numOfNodes = 10; %number of nodes
queueLength = 25; %queue length
RelayNodeCapacity = 7; %relay node capacity
Priority_Weight = 0.3;
Age_Weight = 1-Priority_Weight;
t = 0.1:0.1:Days*24*60*60;

Node_Age = randi(3900,numOfNodes,1);
Age = zeros(numOfNodes,1);
AgeArray = zeros(numOfNodes,length(t));
Node_Priority = randi(8,numOfNodes,1) + 1;
QueueArray = zeros(numOfNodes,queueLength);
channel_Sel = randi(7,numOfNodes,1) + 1;
numOfTx = zeros(numOfNodes,1);
numOfRelayTx = zeros(numOfNodes,1);
total_Age = zeros(numOfNodes, Days*satPassNum + 1);
total_Age(:,1) = Node_Age;

%% DUMB Node Case
oneDayt = 24*60*60;
txNum = 1;
for ii = 1:length(t)
    
    mayTransmitIdx = mod(Node_Age,65) == 0;
    mayTransmit = find(mayTransmitIdx==1);
    mayTransmitSize = size(mayTransmit);
    
    [~,canTransmitIdx] = unique(channel_Sel(mayTransmit));
    canTransmit = mayTransmit(canTransmitIdx);
    
    Node_Age(canTransmit) = 0;
    numOfTx(canTransmit) = numOfTx(canTransmit) + 1;
    
    channel_Sel(mayTransmit) = randi(7,mayTransmitSize(1),1) + 1;
    
    % Relay Part

    if ~isempty(canTransmit)
        QueueArray(canTransmit,:) = circshift(QueueArray(canTransmit,:),1,2);
        QueueArray(canTransmit,1) = Priority_Weight*Node_Priority(canTransmit);
    end
    

    QueueArray(QueueArray~=0) = QueueArray(QueueArray~=0) + Age_Weight*0.1;
    Node_Age = Node_Age + 1;
    AgeArray(:,ii) = Age;
    Age = Age + 0.1;

    if mod(ii,ceil(Days*length(t)/(Days*satPassNum)))==0
        txNum = txNum+1;
        QueueLCArray = sortrows([QueueArray(:,1), (1:numOfNodes)'],-1);
        RelayTxIdx = QueueLCArray(1:RelayNodeCapacity,2);

        numOfRelayTx(RelayTxIdx,1) = numOfRelayTx(RelayTxIdx,1) + 1;
        
        total_Age(RelayTxIdx,txNum) = Age(RelayTxIdx,1);
        Age(RelayTxIdx) = QueueArray(RelayTxIdx,1)-Priority_Weight*Node_Priority(RelayTxIdx,1);
        
        QueueArray(RelayTxIdx,1) = 0;
        QueueArray(RelayTxIdx,:) = circshift(QueueArray(RelayTxIdx,:),-1,2);
        
    end
end



toc