%
% Copyright 2017 Vienna University of Technology.
% Institute of Computer Graphics and Algorithms.
%

function[] = gui_main(filename)
%EVC_MAIN Die Hauptfunktion. Nicht abgeben! 
%Änderungen der Signaturen jeglicher Funktionen ist verboten (Name, Eingabe, Ausgabe).
    close all;
    clear global;
    CFA = imread(filename); %Einlesen der Bilddatei
    
    old_warning_state = warning;
    warning('off', 'Images:initSize:adjustingMag');

    [CFA, asShotNeutral, param1,param2] = evc_black_level(CFA, filename); %Schwarz ausgleichen
      
    bins = 512; %Anzahl der Bündel im Histogramm
    
    [RGB,param1,param2,param3,param4] = evc_demosaic(CFA, asShotNeutral); %Farben nachrechnen	
    clear CFA; %wird nicht mehr gebraucht
    close all;

	RGB_WB = gui_white_balance(RGB); %Weißabgleich
    RGB_GAMMA = gui_gamma_correction(RGB_WB, bins); %Gammakorrektur
    RGB_RESULT = gui_histogram_clipping(RGB_GAMMA, bins); %Kontrasterhöhung

    %optional - Bild nochmal zeigen
    imshow(RGB_RESULT, []);
    warning(old_warning_state);
    %optional - Bild speichern
    %imwrite(uint8(RGB_RESULT * 255), 'output.png', 'png');
end