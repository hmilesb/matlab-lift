%% THREE FUNCTION CALLS AVAILABLE: LIFT REQUEST BUTTON PRESSED, LIFT STOP
%% Init. Variables and Data
global passengerMatrix
passengerMatrix = [] % 2D Array

global maxPassengers
maxPassengers = 10


testvalue = liftCall(3,1,0,1,0)
% testvalue = liftCall(4,-1,0,1,0)
testvalue2 = liftStopped(3,6)

%testValue = liftCall(10,-1,0,5,0)

%testValue = liftCall(10,-1,-1,5,1)
%testValue = liftCall(6,-1,-1,5,1)
%testValue = liftCall(4,-1,-1,5,1)
%testValue = liftCall(2,1,-1,5,1)
%testValue = liftCall(7,1,-1,5,1)
%testValue = liftCall(7,1,-1,5,1)
%testValue = liftCall(7,1,-1,5,1)

%liftCall(9,1,0,3,0)

%testValue = liftCall(8,1,1,4,9)

%testvalue2 = liftStopped(7,8)
%testvalue2 = liftStopped(7,[8 9 10])


%testvalue2 = liftStopped(10, 5)

%testvalue2 = liftStopped(2,6)

%testvalue3 = liftStopped(6, 3)
%testvalue4 = liftStopped(5, 0)
%testvalue4 = liftStopped(4, 2)
%testvalue5 = liftStopped(3, 0)
%testvalue6 = liftStopped(7, 9)
%testvalue7 = liftStopped(9,0)
%testvalue8 = liftStopped(2,6)
%testvalue9 = liftStopped(6,0)

%testvalue7 = liftStopped(1, 0)


%% Lift Request Button Pressed
function nextFloor = liftCall(Floor,Direction,liftDirection,liftPosition,liftDestination) % nextFloor changes from existing if redirection to be done
    % Generates New User ID in the Passenger Matrix
    avgFloor = 0;
    if Direction == 1
        avgFloor = round(((10 - Floor)/2) + Floor);
    else
        avgFloor = round(Floor / 2);
    end
    
    passenger = [double(Floor), now, avgFloor, 0, 0, Direction];
    
    global passengerMatrix % Adds to Passenger Matrix, also checks if empty
    if size(passengerMatrix,1) == 0
        passengerMatrix = passenger;
    else
        passengerMatrix = [passengerMatrix; passenger]
    end
    
    % Checks if request is en-route and that there is no urgent passenger
    
    overtimeFloor = overtimeCheck()
    
    nextFloor = 0;
    
    if double(overtimeFloor) ~= 0
        if liftDirection == 1 && overtimeFloor > liftPosition && overtimeFloor < liftDestination
            nextFloor = overtimeFloor;
        elseif liftDirection == -1 && overtimeFloor < liftPosition && overtimeFloor > liftDestination
            nextFloor = overtimeFloor;
        else
            nextFloor = liftDestination;
        end
    else
        if liftDirection == 0 % Lift is Stationary
            nextFloor = Floor;
        elseif liftDirection == 1 && Floor > liftPosition && Direction == liftDirection && Floor < liftDestination
            nextFloor = Floor;
        elseif liftDirection == -1 && Floor < liftPosition && Direction == liftDirection && Floor > liftDestination
            nextFloor = Floor;
        else
            nextFloor = liftDestination;
        end
    end  
    
    % Checks if doing the re-route will cause too many passengers to be
    % picked up
    global maxPassengers
    if nextFloor == Floor
        tempCounter = 0
        currentPassengers = 0
        for j = 1:size(passengerMatrix,1)
            passengerMatrix(j,4)
            if double(passengerMatrix(j,4)) ~= 0
                currentPassengers = currentPassengers + 1
            end
            if double(passengerMatrix(j,5)) == Floor
                tempCounter = tempCounter - 1
            elseif double(passengerMatrix(j,1)) == Floor
                tempCounter = tempCounter + 1
            end
        end
        if currentPassengers + tempCounter > maxPassengers
            nextFloor = liftDestination;
        end
    end
        
    
    %Check if enough time to slow down
end

%% Lift Stopped on Floor
function bestNextFloor = liftStopped(liftFloor, buttonPressed)% buttonPressed = Internal Button
    global passengerMatrix;
    
    % Checks for passengers getting off on this floor, and assinging floors
    % to passengers getting on at the floor
    buttonPressedTemp = buttonPressed;
    allocationCounter = 1;
    tempCounter = size(passengerMatrix,1);
    i = 1;
    while i <= tempCounter % goes through passenger matrix
        if double(passengerMatrix(i,5)) == liftFloor
            passengerMatrix(i,:) = []; % Deletes from Passenger Matrix if they got off here
            tempCounter = tempCounter - 1;
        elseif double(passengerMatrix(i,1)) == liftFloor && double(passengerMatrix(i,4)) == 0
            passengerMatrix(i,4) = now; % Adds wait time to Passenger Matrix if they got on here
            passengerMatrix(i,5) = buttonPressedTemp(allocationCounter); %appends actual floor to person who got on here
            if allocationCounter < length(buttonPressed) % Checks if multiple floor buttons pressed
                allocationCounter = allocationCounter + 1; % as buttonPressed can be array, work through the list
            end
            i = i + 1;
        else
            i = i + 1;
        end
    end
    
    if length(passengerMatrix) == 0
        bestNextFloor = 0;
        return
    end
    
    stopArray = [];
    motionArray = [];
    
    pickupArray = [];
    distinationArray = [];
    directionArray = [];
    passengerDone = [];
    for i = 1:size(passengerMatrix,1) % Goes through passenger matrix
        pickupArray(i) = passengerMatrix(i,1); % Pickup location
        if double(passengerMatrix(i,5)) == 0
            destinationArray(i) = passengerMatrix(i,3); % Dropoff Location (ESTIMATED)
        else
            destinationArray(i) = passengerMatrix(i,5); % Dropoff Location (ACTUAL)
        end
        directionArray = [directionArray passengerMatrix(i,6)];
        if double(passengerMatrix(i,4)) == 0
            passengerDone(i) = 1;
        else
            passengerDone(i) = 2;
        end
    end
    
    minPath = 0;
    timeStop = 5;
    timeMotion = 1;
    timeArrayUp = []; % Where results of Up calculation are held
    locationArrayUp = [];
    timeArrayDown = []; % Where results of Down calculation are held
    locationArrayDown = [];
    for i = 1:10 % Cycles through each floor (1-10)
        currentPath = abs(liftFloor - i)  * (length(passengerDone) - sum(passengerDone(:) == 3)) * (timeStop + timeMotion); % Cost to travel to current tested floor
        % START UP
        if i ~= 10 %Doesn't go up if on top floor
                currentStops = 0;
                currentMotion = 0;
                Direction = 1;
                floorTemp = i;
                flag = 0;
                
                passengerDone = [];
                for i2 = 1:size(passengerMatrix,1) % Goes through passenger matrix
                    if double(passengerMatrix(i2,4)) == 0
                        passengerDone(i2) = 1;
                    else
                        passengerDone(i2) = 2;
                    end
                end

                currentJobArray = [];
                for j = 1:size(passengerMatrix,1) % Cycles through the entire passsenger matrix to check for passengers in same direction
                    if directionArray(j) == Direction
                            currentJobArray = [currentJobArray pickupArray(j)];
                            currentJobArray = [currentJobArray destinationArray(j)];
                    end
                end
                
                sortedJobs = unique(sort(double(currentJobArray))); % Sorts array and removes duplicates for Up
                startIndex = find(double(unique(sort([currentJobArray floorTemp]))) == double(floorTemp)) %%CHANGES THESE IN BELOW FOR GOING DOWN, FLIP SORT
                "here"
                
                currentJobArray = [];
                for j = 1:size(passengerMatrix,1)
                    if directionArray(j) ~= Direction
                            currentJobArray = [currentJobArray pickupArray(j)];
                            currentJobArray = [currentJobArray destinationArray(j)];
                    end
                end
                
                sortedJobs2 = fliplr(unique(sort(double(currentJobArray)))); % repeat for opposite, flipped (higher floors first)
                
                % Checks the index position of the nearest demanded floor, will
                % set that floor as the first desitination

                inuseArray = sortedJobs;
                locationArray = [];
                
                if startIndex > length(inuseArray)
                    startIndex = length(inuseArray)
                end
                
                    while (ismember(1,passengerDone()) == 1 || ismember(2,passengerDone())); % While there is still demand
                        global maxPassengers % Checks again for passenger overload
                        tempCounter = 0;
                        currentPassengers = 0;
                        if startIndex <= length(inuseArray) && startIndex > 0
                        for j = 1:size(passengerMatrix,1)
                            if double(passengerMatrix(j,4)) ~= 0
                                currentPassengers = currentPassengers + 1;
                            end
                            sortedJobs
                            sortedJobs2
                            startIndex
                            if double(passengerMatrix(j,5)) == inuseArray(startIndex)
                                tempCounter = tempCounter - 1;
                            elseif double(passengerMatrix(j,1)) == inuseArray(startIndex)
                                tempCounter = tempCounter + 1;
                            end
                        end
                        if currentPassengers + tempCounter <= maxPassengers
                            for i2 = 1:size(passengerMatrix,1) % Checks each passenger and adjusts their current status at this gloor
                                if directionArray(i2) == Direction
                                    if passengerDone(i2) == 1 && pickupArray(i2) == inuseArray(startIndex)
                                        passengerDone(i2) = 2;
                                        if flag ~= 1
                                            locationArray(length(locationArray) + 1) = inuseArray(startIndex);
                                            currentStops = currentStops + ((length(passengerDone) - sum(passengerDone(:) == 3)));
                                            currentMotion = double(currentMotion) + (abs(double(inuseArray(startIndex)) - double(floorTemp)) * (double(length(passengerDone)) - double(sum(passengerDone(:) == 3))));
                                            floorTemp = inuseArray(startIndex);
                                            flag = 1;
                                        end
                                    end
                                    if passengerDone(i2) == 2 && double(destinationArray(i2)) == inuseArray(startIndex)
                                        passengerDone(i2) = 3;
                                        if flag ~= 1
                                            locationArray(length(locationArray) + 1) = inuseArray(startIndex);
                                            currentStops = currentStops + ((length(passengerDone) - sum(passengerDone(:) == 3)));
                                            currentMotion = double(currentMotion) + (abs(double(inuseArray(startIndex)) - double(floorTemp)) * (double(length(passengerDone)) - double(sum(passengerDone(:) == 3))));
                                            floorTemp = inuseArray(startIndex);
                                            flag = 1;
                                        end
                                    end
                                end
                            end
                        end
                        end
                        % Checks if the index position should be reset at end
                        % of floors
                        
                        if Direction == 1 && startIndex >= length(inuseArray)
                            Direction = -1;
                            startIndex = 0;
                            inuseArray = sortedJobs2;
                        elseif Direction == -1 && startIndex >= length(inuseArray)
                            Direction = 1;
                            startIndex = 0;
                            inuseArray = sortedJobs;
                        end
                        startIndex = startIndex + 1;
                        flag = 0;
                    end
            timeArrayUp(length(timeArrayUp)+1) = ((currentStops * timeStop) + (currentMotion * timeMotion)) + currentPath; % Added +1
            locationArrayUp = [locationArrayUp locationArray(1)];
        end
   

        % START DOWN
        if i ~= 1 %Doesn't go down if on bottom floor
                currentStops = 0;
                currentMotion = 0;
                Direction = -1;
                floorTemp = i;
                flag = 0;
                
                passengerDone = [];
                for i2 = 1:size(passengerMatrix,1) % Goes through passenger matrix
                    if double(passengerMatrix(i2,4)) == 0
                        passengerDone(i2) = 1;
                    else
                        passengerDone(i2) = 2;
                    end
                end
                
                %passengerDone
                currentJobArray = [];
                for j = 1:size(passengerMatrix,1) % Cycles through the entire passsenger matrix to check for passengers in same direction
                    if directionArray(j) ~= Direction
                        currentJobArray = [currentJobArray pickupArray(j)];
                        currentJobArray = [currentJobArray destinationArray(j)];
                    end
                end

                sortedJobs = fliplr(unique(sort(double(currentJobArray)))); % Sorts array and removes duplicates for Down, flipped
                startIndex = find(double(unique(sort([currentJobArray floorTemp]))) == double(floorTemp)); %%CHANGES THESE IN BELOW FOR GOING DOWN, FLIP SORT
                
                currentJobArray = [];
                for j = 1:size(passengerMatrix,1)
                    if directionArray(j) == Direction
                        currentJobArray = [currentJobArray pickupArray(j)];
                        currentJobArray = [currentJobArray destinationArray(j)];
                    end
                end

                sortedJobs2 = unique(sort(double(currentJobArray))); % repeat for opposite
               
                % Checks the index position of the nearest demanded floor, will
                % set that floor as the first desitination

                inuseArray = sortedJobs;
                locationArray = [];
                if startIndex > length(inuseArray)
                    startIndex = length(inuseArray)
                end

                    while ismember(1,passengerDone()) == 1 || ismember(2,passengerDone()) % While there is still demand
                        global maxPassengers % Checks again for passenger overload
                        tempCounter = 0;
                        currentPassengers = 0;
                        startIndex
                        if startIndex <= length(inuseArray) && startIndex > 0
                        for j = 1:size(passengerMatrix,1)
                            if double(passengerMatrix(j,4)) ~= 0
                                currentPassengers = currentPassengers + 1;
                            end
                            if double(passengerMatrix(j,5)) == inuseArray(startIndex)
                                tempCounter = tempCounter - 1;
                            elseif double(passengerMatrix(j,1)) == inuseArray(startIndex)
                                tempCounter = tempCounter + 1;
                            end
                        end
                        if currentPassengers + tempCounter <= maxPassengers
                            %passengerDone
                            %inuseArray(startIndex)
                            for i2 = 1:size(passengerMatrix,1) % Checks each passenger and adjusts their current status at this gloor
                                
                                if directionArray(i2) == Direction
                                    if passengerDone(i2) == 1 && pickupArray(i2) == inuseArray(startIndex)
                                        passengerDone(i2) = 2;
                                        if flag ~= 1
                                            locationArray(length(locationArray) + 1) = inuseArray(startIndex);
                                            currentStops = currentStops + ((length(passengerDone) - sum(passengerDone(:) == 3)));
                                            currentMotion = double(currentMotion) + (abs(double(inuseArray(startIndex)) - double(floorTemp)) * (double(length(passengerDone)) - double(sum(passengerDone(:) == 3))));
                                            floorTemp = inuseArray(startIndex);
                                            flag = 1;
                                        end
                                    end
                                    if double(passengerDone(i2)) == 2 && double(destinationArray(i2)) == inuseArray(startIndex)
                                        passengerDone(i2) = 3;
                                        if flag ~= 1
                                            locationArray(length(locationArray) + 1) = inuseArray(startIndex);
                                            currentStops = currentStops + ((length(passengerDone) - sum(passengerDone(:) == 3)));
                                            currentMotion = double(currentMotion) + (abs(double(inuseArray(startIndex)) - double(floorTemp)) * (double(length(passengerDone)) - double(sum(passengerDone(:) == 3))));
                                            floorTemp = inuseArray(startIndex);
                                            flag = 1;
                                        end
                                    end
                                end
                            end
                        end
                        end

                        % Checks if the index position should be reset at end
                        % of floors
                        if Direction == 1 && double(startIndex) >= length(inuseArray)
                            Direction = -1;
                            startIndex = 0;
                            inuseArray = sortedJobs2;
                        elseif Direction == -1 && double(startIndex) >= length(inuseArray)
                            Direction = 1;
                            startIndex = 0;
                            inuseArray = sortedJobs;
                        end
                        startIndex = startIndex + 1;
                        flag = 0;
                    end
            timeArrayDown(length(timeArrayDown)+1) = ((currentStops * timeStop) + (currentMotion * timeMotion)) + currentPath;
            stopArray(length(stopArray)+1) = currentStops;
            motionArray(length(motionArray)+1) = currentMotion;
            locationArrayDown = [locationArrayDown locationArray(1)];
        end
    end
    % Compares up and Down Times, picks the shortest and spits out the best next
    % floor to go to
    
    timeArrayUp
    timeArrayDown
    
    locationArrayDown
    locationArrayUp
    
    
    bestNextFloor = 0;
    sortUp = sort(timeArrayUp)
    sortDown = sort(timeArrayDown)
    if sortUp(1) < sortDown(1)
        "here"
        sortUp(1)
        bestNextFloor = locationArrayUp(find(timeArrayUp == sortUp(1))); % Extracts the index of the best next floor
    else
        timeArrayDown
        find(timeArrayDown == sortDown(1))
        bestNextFloor = locationArrayDown(find(timeArrayDown == sortDown(1)));
        if length(bestNextFloor) > 1
            bestNextFloor = bestNextFloor(1);
        end
    end
    
    if overtimeCheck() ~= 0
        bestNextFloor = overtimeCheck();
    end
end

function priorityFloor = overtimeCheck()
    % Goes through Pass.Mtrx and checks for overtime
    global passengerMatrix
    overtimePos = [];
    overtimeWait = [];
    overtimeType = [];
    for i = 1:size(passengerMatrix,1)
        if now - double(passengerMatrix(i,2)) > 45000 && double(passengerMatrix(i,4)) == 0
            overtimePos(length(overtimePos) + 1) = i;
            overtimeWait(length(overtimeWait) + 1) = now - double(passengerMatrix(i,2)) - 45000; %Target Times in Milliseconds
            overtimeType(length(overtimePos) + 1) = "Wait";
        elseif now - double(passengerMatrix(i,4)) > 45000  && double(passengerMatrix(i,4)) ~= 0
            overtimePos(length(overtimePos) + 1) = i;
            overtimeWait(length(overtimeWait) + 1) = now - double(passengerMatrix(i,4)) - 45000;
            overtimeType(length(overtimePos) + 1) = "Lift";
        elseif ((now - (double(passengerMatrix(i,4))))+(double(passengerMatrix(i,4))-double(passengerMatrix(i,2)))) > 60000  && double(passengerMatrix(i,4)) ~= 0
            overtimePos(length(overtimePos) + 1) = i;
            overtimeWait(length(overtimeWait) + 1) = ((now - (double(passengerMatrix(i,4))))+(double(passengerMatrix(i,4))-double(passengerMatrix(i,2)))) - 60000;
            overtimeType(length(overtimePos) + 1) = "Lift";
        end
    end
    
    % Checks if overtime present, where to go first.
    
    if length(overtimeWait) > 0
        sortWaitTimes = sort(overtimeWait);
        priorityIndex = find(overtimeWait == sortWaitTimes(length(sortWaitTimes)));
        priorityFloor = passengerMatrix(overtimePos(priorityIndex),1);
    else
        priorityFloor = 0;
    end
end