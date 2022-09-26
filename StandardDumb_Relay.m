
format long

% caseNum = 1;
% numberOfPasses = [4 12 24]; %number of satellite passes
% satPassNum = numberOfPasses(caseNum); %selected sat pass case
% Days = 7; %simulation day duration
% Nodes = [19 51 99];
% numOfNodes = Nodes(caseNum); %number of nodes
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
    
    mayTransmitIdx = mod(Node_Age,length(t)/Days) == 0;
    mayTransmitIdx(1:3,:) = 0;
    mayTransmitIdx(1:3,:) = mod(Node_Age(1:3,:),length(t)/(Days*satPassNum)) == 0;
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

    if mod(ii,ceil(length(t)/(Days*satPassNum)))==0
        txNum = txNum+1;
        SatQueueArray = nonzeros(QueueArray);
        SatQueueArray = [SatQueueArray(1:end/2,1) SatQueueArray(end/2+1:end,1)];
        if length(SatQueueArray)<7
            RelayTxIdx = SatQueueArray(:,2);
        else
            RelayTxIdx = SatQueueArray(end-RelayNodeCapacity+1:end,2);
        end

        numOfRelayTx(RelayTxIdx,1) = numOfRelayTx(RelayTxIdx,1) + 1;
        
        total_Age(RelayTxIdx,txNum) = Age(RelayTxIdx,1);
        if length(SatQueueArray)<7
            Age(RelayTxIdx) = SatQueueArray(:,1);

            QueueArray(1:length(SatQueueArray),:) = 0;
        else
            Age(RelayTxIdx) = SatQueueArray(end-RelayNodeCapacity+1:end,1);

            QueueArray(length(SatQueueArray)-RelayNodeCapacity+1:length(SatQueueArray),:) = 0;
        end
        
    end
end

PeakAge_PerNode = max(AgeArray,[],2);

