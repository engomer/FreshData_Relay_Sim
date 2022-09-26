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
Node_Priority = randi(8,numOfNodes,1) + 1;
QueueArray = zeros(numOfNodes,queueLength);
channel_Sel = randi(7,numOfNodes,1) + 1;
numOfTx = zeros(numOfNodes,1);
numOfRelayTx = zeros(numOfNodes,1);
total_Age = zeros(numOfNodes, Days*satPassNum + 1);
total_Age(:,1) = Node_Age;
mayTransmitIdx = zeros(numOfNodes,1);

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
        QueueArray(canTransmit,:) = circshift(QueueArray(canTransmit,:),1,2);
        QueueArray(canTransmit,1) = Priority_Weight*Node_Priority(canTransmit);
    end
    

    QueueArray(QueueArray~=0) = QueueArray(QueueArray~=0) + Age_Weight*0.1;
    Node_Age = Node_Age + 1;
    AgeArray(:,ii) = Age;
    Age = Age + 0.1;

    if mod(ii,ceil(length(t)/(Days*satPassNum)))==0
        txNum = txNum+1;
        QueueLCArray = sortrows([QueueArray(4:end,1), (4:numOfNodes)'],-1);
        
        RelayTxIdx = [1;2;3;QueueLCArray(QueueLCArray(1:RelayNodeCapacity-3,1)~= 0,2);];
        
        numOfRelayTx(RelayTxIdx,1) = numOfRelayTx(RelayTxIdx,1) + 1;
    
        total_Age(RelayTxIdx,txNum) = Age(RelayTxIdx,1);
        Age(RelayTxIdx) = QueueArray(RelayTxIdx,1)-Priority_Weight*Node_Priority(RelayTxIdx,1);
    
        QueueArray(RelayTxIdx,1) = 0;
        QueueArray(RelayTxIdx,:) = circshift(QueueArray(RelayTxIdx,:),-1,2);
        
    end
end

PeakAge_PerNode = max(AgeArray,[],2);

