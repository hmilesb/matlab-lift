%% THREE FUNCTION CALLS AVAILABLE: LIFT REQUEST BUTTON PRESSED, LIFT STOP
%% Init. Variables and Data
global passengerMatrix = [] % 2D Array

%% Lift Request Button Pressed
function nextFloor = liftCall(Floor,Direction,liftDirection,liftPosition,liftDestination) % nextFloor changes from existing if redirection to be done
    % Generates New User ID in the Passenger Matrix
    avgFloor = 0
    if Direction == "Up"
        avgFloor = round(((10 - Floor)/2) + Floor)
    else
        avgFloor = round(Floor / 2)
    end
    
    passenger = [Floor, now, avgFloor, 0, 0, Direction]
    
    global passengerMatrix % Adds to Passenger Matrix
    passengerMatrix(length(passengerMatrix + 1) = passenger
    
    % Checks if request is en-route and that there is no urgent passenger
    
    overtimeFloor = overtimeCheck()
    
    nextFloor = 0
    
    if overtimeFloor ~= 0
        if liftDirection == "Up" && overtimeFloor > liftPosition && overtimeFloor < liftDestination
            nextFloor = overtimeFloor
        elseif liftDirection == "Down" && overtimeFloor < liftPosition && overtimeFloor > liftDestination
            nextFloor = overtimeFloor
        else
            nextFloor = liftDestination
        end
    else
        if liftDirection == "None" % Lift is Stationary
            nextFloor = Floor
        elseif liftDirection == "Up" && Floor > liftPosition && Direction == liftDirection && Floor < liftDestination
            nextFloor = Floor
        elseif liftDirection == "Down" && Floor < liftPosition && Direction == liftDirection && Floor > liftDestination
            nextFloor = Floor
        else
            nextFloor = liftDestination
        end
    end  
    
    %Check if enough time to slow down
end

%% Lift Stopped on Floor
function bestNextFloor = liftStopped(liftFloor, buttonPressed)
    global passengerMatrix
    
    % Checks for passengers getting off on this floor, and assinging floors
    % to passengers getting on at the floor
    buttonPressedTemp = buttonPressed
    allocationCounter = 1
    for i = 1:length(passengerMatrix)
        if passengerMatrix(i,5) == liftFloor
            passengerMatrix(i) = [] % Deletes from Passenger Matrix
        elseif passengerMatrix(i,1) == liftFloor && passengerMatrix(i,4) == 0
            passengerMatrix(i,4) = now % Adds wait time to Passenger Matrix
            passengerMatrix(i,5) = buttonPressedTemp(allocationCounter)
            if allocationCounter < length(buttonPressed) % Checks if multiple floor buttons pressed
                allocationCounter = allocationCounter + 1
            end
        end
    end
        
    
    pickupArray = []
    distinationArray = []
    directionArray = []
    passengerDone = []
    for i = 1:length(passengerMatrix)
        pickupArray(i) = passengerMatrix(i,1)
        destinationArray(i) = passengerMatrix(i,3)
        directionArray(i) = passengerMatrix(1,6)
        if passengerMatrix(i,4) == 0
            passengerDone(i) = 1
        else
            passengerDone(i) = 2
        end
    end
    
    minPath = 0
    timeStop = 5
    timeMotion = 1
    timeArrayUp = [] % Where results of Up calculation are held
    timeArrayDown = [] % Where results of Down calculation are held
    for i = 1:10 % Cycles through each floor (1-10)
        currentPath = abs(liftFloor - i)  * (length(passengerDone) - sum(passengerDone(:) == 3)) * (timeStop + timeMotion) % Cost to travel to current tested floor
        % START UP
        if i ~= 10 %Doesn't go up if on top floor
                currentStops = 0
                currentMotion = 0
                Direction = "Up"
                floorTemp = i
                flag = 0
                if floorTemp == 10
                    Direction = "Down"
                elseif floorTemp == 1
                    Direction = "Up"
                end

                currentJobArray = []
                for j = 1:length(passengerMatrix) % Cycles through the entire passsenger matrix to check for passengers in same direction
                    if directionArray(j) == Direction
                            currentJobArray = [currentJobArray pickupArray(j)]
                            currentJobArray = [currentJobArray destinationArrayArray(j)]
                    end
                end

                sortedJobs = unique(sort(currentJobArray)) % Sorts array and removes duplicates for Up

                currentJobArray = []
                for j = 1:length(passengerMatrix)
                    if directionArray(j) ~= Direction
                            currentJobArray = [currentJobArray pickupArray(j)]
                            currentJobArray = [currentJobArray destinationArrayArray(j)]
                    end
                end

                sortedJobs2 = fliplr(unique(sort(currentJobArray))) % repeat for opposite, flipped (higher floors first)


                startIndex = find(unique(sort([currentJobArray floorTemp])) == floorTemp) %%CHANGES THESE IN BELOW FOR GOING DOWN, FLIP SORT
                % Checks the index position of the nearest demanded floor, will
                % set that floor as the first desitination

                inuseArray = sortedJobs

                    while ismember(1,passengerDone()) == 1 || ismember(2,passengerDone()) % While there is still demand

                        for i = 1:length(passengerMatrix) % Checks each passenger and adjusts their current status at this gloor
                            if directionArray(i) == Direction
                                if passengerDone(i) == 1 && pickupArray(i) == startIndex
                                    passengerDone(i) = 2
                                    if flag ~= 1
                                        currentStops = currentStops + (1 * (length(passengerDone) - sum(passengerDone(:) == 3)))
                                        currentMotion = currentMotion + (abs(inuseArray(startIndex) - floorTemp) * (length(passengerDone) - sum(passengerDone(:) == 3)))
                                        floorTemp = inuseArray(startIndex)
                                        flag = 1
                                    end
                                end
                                if passengerDone(i) == 2 && destinationArray(i) == startIndex
                                    passengerDone(i) = 3
                                    if flag ~= 1
                                        currentStops = currentStops + (1 * (length(passengerDone) - sum(passengerDone(:) == 3)))
                                        currentMotion = currentMotion + (abs(inuseArray(startIndex) - floorTemp) * (length(passengerDone) - sum(passengerDone(:) == 3)))
                                        floorTemp = inuseArray(startIndex)
                                        flag = 1
                                    end
                                end
                            end
                        end

                        % Checks if the index position should be reset at end
                        % of floors
                        if direction == "Up" && startIndex == length(inuseArray)
                            direction = "Down"
                            startIndex = 1
                            inuseArray = sortedJobs2
                        elseif direction == "Down" && startIndex == length(inuseArray)
                            direction = "Up"
                            startIndex = 1
                            inuseArray = sortedJobs
                        end
                        startIndex = startIndex + 1
                        flag = 0
                    end
            timeArrayUp(length(timeArrayUp)) = ((currentStops * timeStop) + (currentMotion * timeMotion)) + currentPath
        end


        % START DOWN
        if i ~= 1 %Doesn't go down if on bottom floor
                currentStops = 0
                currentMotion = 0
                Direction = "Down";
                floorTemp = i
                flag = 0
                if floorTemp == 10
                    Direction = "Down"
                elseif floorTemp == 1
                    Direction = "Up"
                end

                currentJobArray = []
                for j = 1:length(passengerMatrix) % Cycles through the entire passsenger matrix to check for passengers in same direction
                    if directionArray(j) ~= Direction
                            currentJobArray = [currentJobArray pickupArray(j)]
                            currentJobArray = [currentJobArray destinationArrayArray(j)]
                    end
                end

                sortedJobs = fliplr(unique(sort(currentJobArray))) % Sorts array and removes duplicates for Down, flipped

                currentJobArray = []
                for j = 1:length(passengerMatrix)
                    if directionArray(j) == Direction
                            currentJobArray = [currentJobArray pickupArray(j)]
                            currentJobArray = [currentJobArray destinationArrayArray(j)]
                    end
                end

                sortedJobs2 = unique(sort(currentJobArray)) % repeat for opposite


                startIndex = find(unique(sort([currentJobArray floorTemp])) == floorTemp) %%CHANGES THESE IN BELOW FOR GOING DOWN, FLIP SORT
                % Checks the index position of the nearest demanded floor, will
                % set that floor as the first desitination

                inuseArray = sortedJobs

                    while ismember(1,passengerDone()) == 1 || ismember(2,passengerDone()) % While there is still demand

                        for i = 1:length(passengerMatrix) % Checks each passenger and adjusts their current status at this gloor
                            if directionArray(i) == Direction
                                if passengerDone(i) == 1 && pickupArray(i) == startIndex
                                    passengerDone(i) = 2
                                    if flag ~= 1
                                        currentStops = currentStops + (1 * (length(passengerDone) - sum(passengerDone(:) == 3)))
                                        currentMotion = currentMotion + (abs(inuseArray(startIndex) - floorTemp) * (length(passengerDone) - sum(passengerDone(:) == 3)))
                                        floorTemp = inuseArray(startIndex)
                                        flag = 1
                                    end
                                end
                                if passengerDone(i) == 2 && destinationArray(i) == startIndex
                                    passengerDone(i) = 3
                                    if flag ~= 1
                                        currentStops = currentStops + (1 * (length(passengerDone) - sum(passengerDone(:) == 3)))
                                        currentMotion = currentMotion + (abs(inuseArray(startIndex) - floorTemp) * (length(passengerDone) - sum(passengerDone(:) == 3)))
                                        floorTemp = inuseArray(startIndex)
                                        flag = 1
                                    end
                                end
                            end
                        end

                        % Checks if the index position should be reset at end
                        % of floors
                        if direction == "Up" && startIndex == length(inuseArray)
                            direction = "Down"
                            startIndex = 1
                            inuseArray = sortedJobs2
                        elseif direction == "Down" && startIndex == length(inuseArray)
                            direction = "Up"
                            startIndex = 1
                            inuseArray = sortedJobs
                        end
                        startIndex = startIndex + 1
                        flag = 0
                    end
            timeArrayDown(length(timeArrayDown)) = ((currentStops * timeStop) + (currentMotion * timeMotion)) + currentPath
        end   
    end
    % Compares up and Down Times, picks the shortest and spits out the best next
    % floor to go to
    bestNextFloor = 0
    sortUp = sort(timeArrayUp)
    sortDown = sort(timeArrayDown)
    if sortUp(1) < sortDown(1)
        bestNextFloor = 1 + find(timeArrayUp == sortUp(1)) % Extracts the index of the best next floor
    else
        bestNextFloor = 1 + find(timeArrayDown == sortDown(1))
    end
    
    if overtimeCheck() ~= 0
        bestNextFloor = overtimeCheck()
    end
end

function priorityFloor = overtimeCheck()
    % Goes through Pass.Mtrx and checks for overtime
    global passengerMatrix
    overtimePos = []
    overtimeWait = []
    overtimeType = []
    for i = 1:length(passengerMatrix)
        if now - passengerMatrix(i,1) > WAIT_TARGETTIME_MILLISECONDS && passengerMatrix(i,4) == 0
            overtimePos(length(overtimePos + 1)) = i
            overtimeWait(length(overtimeWait + 1)) = now - passengerMatrix(i,1) - WAIT_TARGETTIME_MILLISECONDS
            overtimeType(length(overtimePos + 1)) = "Wait"
        elseif now - passengerMatrix(i,4) > LIFT_TARGETTIME_MILLISECONDS  && passengerMatrix(i,4) ~= 0
            overtimePos(length(overtimePos + 1)) = i
            overtimeWait(length(overtimeWait + 1)) = now - passengerMatrix(i,4) - LIFT_TARGETTIME_MILLISECONDS
            overtimeType(length(overtimePos + 1)) = "Lift"
        elseif ((now - (passengerMatrix(i,4)))+(passengerMatrix(i,4)-passengerMatrix(i,1))) > TOTAL_TARGETTIME_MILLISECONDS  && passengerMatrix(i,4) ~= 0
            overtimePos(length(overtimePos + 1)) = i
            overtimeWait(length(overtimeWait + 1)) = ((now - (passengerMatrix(i,4)))+(passengerMatrix(i,3)-passengerMatrix(i,1))) - TOTAL_TARGETTIME_MILLISECONDS
            overtimeType(length(overtimePos + 1)) = "Lift"
        end
    end
    
    % Checks if overtime present, where to go first.
    
    if length(overtimeWait) > 0
        sortWaitTimes = sort(overtimeWait)
        priorityIndex = find(overtimeWait == sortWaitTimes(length(sortWaitTimes)))
        priorityFloor = passengerMatrix(overtimePos(priorityIndex),1)
    else
        priorityFloor = 0
    end
end