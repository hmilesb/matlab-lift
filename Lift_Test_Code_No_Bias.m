floors = 10
simulationTime = 120 % Seconds
passengerRate = 5 % Passengers per Minute (Average)

i=0
passengerMatrix = []
while i < (passengerRate * (simulationTime / 60))
    passengerTemp = round(rand(1,2) * floors)
    if passengerTemp(1) ~= passengerTemp(2)
        i = i + 1
        passengerMatrix = [passengerMatrix; passengerTemp]
    end
end
simulationData = [round(simulationTime * rand(round(passengerRate * (simulationTime / 60)),1)) passengerMatrix] 