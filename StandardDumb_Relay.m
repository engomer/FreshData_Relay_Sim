
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

Node_Age = randi(3900,numOfNodes,1); %randomly generation of first ages
Age = zeros(numOfNodes,1); %age vector for logging
AgeArray = zeros(numOfNodes,length(t)); %whole age array to observe changes
QueueArray = zeros(numOfNodes*queueLength,2); %Queue array
channel_Sel = randi(7,numOfNodes,1) + 1; %channel selection of nodes
numOfTx = zeros(numOfNodes,1); %number of transmissions to relay
numOfRelayTx = zeros(numOfNodes,1); %log of relay to satelllite transmission
total_Age = zeros(numOfNodes, Days*satPassNum + 1); %age at all satellite passes
total_Age(:,1) = Node_Age; %first age is the initial ages

%% DUMB Node Case

txNum = 1;
for ii = 1:length(t)
    
    mayTransmitIdx = mod(Node_Age,length(t)/Days) == 0; %daily node transmission
    mayTransmitIdx(1:3,:) = 0; %first three are prioritized
    mayTransmitIdx(1:3,:) = mod(Node_Age(1:3,:),length(t)/(Days*satPassNum)) == 0; %first three transmit at every satellite pass
    mayTransmit = find(mayTransmitIdx==1); %find which nodes will transmit
    mayTransmitSize = size(mayTransmit);
    
    [~,canTransmitIdx] = unique(channel_Sel(mayTransmit)); %avoid collisions on same channels
    canTransmit = mayTransmit(canTransmitIdx);
    
    Node_Age(canTransmit) = 0; %make the age of the transmitted nodes zero
    numOfTx(canTransmit) = numOfTx(canTransmit) + 1; %increase number of tx
    
    channel_Sel(mayTransmit) = randi(7,mayTransmitSize(1),1) + 1; %regenerate channel nums
    
    % Relay Part

    if ~isempty(canTransmit) %if any packet of nodes are transmittable to satellite
        QueueArray = circshift(QueueArray,length(canTransmit)); %shift the queue array
        QueueArray(1:length(canTransmit),2) = canTransmit; %make the second column node number
        QueueArray(1:length(canTransmit),1) = 0.001; % make age close to zero
    end
    

    QueueArray(QueueArray(:,1)~=0,1) = QueueArray(QueueArray(:,1)~=0,1) + 0.1; %increase the age of nonzero packets in the queue
    Node_Age = Node_Age + 1; %increase age
    AgeArray(:,ii) = Age;
    Age = Age + 0.1; %increase the age vector

    if mod(ii,ceil(length(t)/(Days*satPassNum)))==0 %if the satellite is passing
        txNum = txNum+1;
        SatQueueArray = nonzeros(QueueArray); %find nonzero elements
        SatQueueArray = [SatQueueArray(1:end/2,1) SatQueueArray(end/2+1:end,1)];
        if length(SatQueueArray)<7 %if queue is less than 7 transmit whole array
            RelayTxIdx = SatQueueArray(:,2);
        else
            RelayTxIdx = SatQueueArray(end-RelayNodeCapacity+1:end,2);
        end

        numOfRelayTx(RelayTxIdx,1) = numOfRelayTx(RelayTxIdx,1) + 1; %increase num of tx of nodes
        
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

