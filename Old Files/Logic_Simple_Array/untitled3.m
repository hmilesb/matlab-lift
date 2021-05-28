

liftButtons = [2 1]
Req_Floor = 3;
Cur_Floor = 2.98

[r,c] = size(liftButtons)
if isempty(liftButtons)
    buttonPressed = 0;
elseif (Req_Floor - Cur_Floor) < 0.3 && c >= 2 && liftButtons(1) == Req_Floor
    buttonPressed = liftButtons(2:end);
elseif (Req_Floor - Cur_Floor) < 0.3 && c == 1
    buttonPressed = 0;
else
    buttonPressed = liftButtons;

end
buttonPressed