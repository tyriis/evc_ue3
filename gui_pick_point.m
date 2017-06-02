%
% Copyright 2017 Vienna University of Technology.
% Institute of Computer Graphics and Algorithms.
%

function [x y p] = gui_pick_point(input)
%EVC_PICK_POINT Lässt den Benutzer einen Bildpunkt selektieren
%
%   EINGABE
%   input... Bild
%   AUSGABE
%   x... X Koordinate des ausgewählten Punktes
%   y... Y Koordinate des ausgewählten Punktes
%   p... true, falls die Koordinate (x,y) im Bild liegt
%              sonst p = false

    %Default Werte
    x = 1;
    y = 1;
    p = true;

    %Lasse den Benutzer einen Bildpunkt auswählen (mit ginput)
    %Beachte, dass x und y aus der Rückgabe vertauscht gehören,
    %denn Matlab speichert die Bilder Spaltenweise!
    [x y] = ginput(1);
    
    %Die Koordinaten runden
    x = floor(x);
    y = floor(y);

    %Liegt der Punkt im Bild?
    if(x < 1 || y < 1 || x > size(input, 2) || y > size(input, 1))
        p = false;
    end
end

