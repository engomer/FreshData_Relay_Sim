%Her passte 1 transmission


format long

% caseNum = 1;
% numberOfPasses = [4 12 24]; %number of satellite passes
% satPassNum = numberOfPasses(caseNum); %selected sat pass case
% Days = 5; %simulation day duration
% Nodes = [19 51 99];
% numOfNodes = Nodes(caseNum); %number of nodes
% queueLength = 25; %queue length
% RelayNodeCapacity = 7; %relay node capacity
% t = 0.1:0.1:Days*24*60*60;

Priority_Weight = 0.3;
Age_Weight = 1-Priority_Weight;

Node_Age = randi(3900,numOfNodes,1);
Age = zeros(numOfNodes,1);
AgeArray = zeros(numOfNodes,length(t));
Node_Priority = randi(2,numOfNodes,1) + 1; %3 levels of priority
QueueArray = zeros(numOfNodes,queueLength);%one column queue array
channel_Sel = randi(7,numOfNodes,1) + 1; %randomly assign channels
numOfTx = zeros(numOfNodes,1); %number of transmissions to relay
numOfRelayTx = zeros(numOfNodes,1); %log of relay to satelllite transmission
total_Age = zeros(numOfNodes, Days*satPassNum + 1); %age at all satellite passes
total_Age(:,1) = Node_Age; %first age is the initial ages
mayTransmitIdx = zeros(numOfNodes,1);

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
        QueueArray(canTransmit,:) = circshift(QueueArray(canTransmit,:),1,2); %shift the queue array
        QueueArray(canTransmit,1) = Priority_Weight*Node_Priority(canTransmit); %calculate the weight
    end
    

    QueueArray(QueueArray~=0) = QueueArray(QueueArray~=0) + Age_Weight*0.1; %increase the age of nonzero packets in the queue
    Node_Age = Node_Age + 1; %increase age
    AgeArray(:,ii) = Age;
    Age = Age + 0.1; %increase the age vector

    if mod(ii,ceil(length(t)/(Days*satPassNum)))==0 %if the satellite is passing
        txNum = txNum+1;
        QueueLCArray = sortrows([QueueArray(4:end,1), (4:numOfNodes)'],-1); %sort packets due to ages
        
        RelayTxIdx = [1;2;3;QueueLCArray(QueueLCArray(1:RelayNodeCapacity-3,1)~= 0,2);]; %find transmittable nodes
        
        numOfRelayTx(RelayTxIdx,1) = numOfRelayTx(RelayTxIdx,1) + 1; %increase num of tx
    
        total_Age(RelayTxIdx,txNum) = Age(RelayTxIdx,1);
        Age(RelayTxIdx) = QueueArray(RelayTxIdx,1)-Priority_Weight*Node_Priority(RelayTxIdx,1); %get the age by subtracting priority
    
        QueueArray(RelayTxIdx,1) = 0; %make last indexes zero
        QueueArray(RelayTxIdx,:) = circshift(QueueArray(RelayTxIdx,:),-1,2); %shift queue array
        
    end
end

PeakAge_PerNode = max(AgeArray,[],2);

