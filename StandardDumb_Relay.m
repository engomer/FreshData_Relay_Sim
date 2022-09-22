
format long


% numberOfPasses = [2 4 10 15]; %number of satellite passes
% satPassNum = numberOfPasses(1); %selected sat pass case
% Days = 1; %simulation day duration
% numOfNodes = 10; %number of nodes
% queueLength = 25; %queue length
% RelayNodeCapacity = 7; %relay node capacity
% t = 0.1:0.1:Days*24*60*60;

Node_Age = randi(3900,numOfNodes,1);
Age = zeros(numOfNodes,1);
AgeArray = zeros(numOfNodes,length(t));
QueueArray = zeros(numOfNodes*queueLength,2);
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
        QueueArray = circshift(QueueArray,length(canTransmit));
        QueueArray(1:length(canTransmit),2) = canTransmit;
        QueueArray(1:length(canTransmit),1) = 0.001;  
    end
    

    QueueArray(QueueArray(:,1)~=0,1) = QueueArray(QueueArray(:,1)~=0,1) + 0.1;
    Node_Age = Node_Age + 1;
    AgeArray(:,ii) = Age;
    Age = Age + 0.1;

    if mod(ii,ceil(Days*length(t)/(Days*satPassNum)))==0
        txNum = txNum+1;
        SatQueueArray = nonzeros(QueueArray);
        SatQueueArray = [SatQueueArray(1:end/2,1) SatQueueArray(end/2+1:end,1)];
        RelayTxIdx = SatQueueArray(end-RelayNodeCapacity+1:end,2);

        numOfRelayTx(RelayTxIdx,1) = numOfRelayTx(RelayTxIdx,1) + 1;
        
        total_Age(RelayTxIdx,txNum) = Age(RelayTxIdx,1);
        Age(RelayTxIdx) = SatQueueArray(end-RelayNodeCapacity+1:end,1);
        
        QueueArray(length(SatQueueArray)-RelayNodeCapacity+1:length(SatQueueArray),:) = 0;
        
    end
end

meanNodeAge = mean(AgeArray,2);
meanAge = mean(AgeArray,"all");

