%
% Copyright 2017 Vienna University of Technology.
% Institute of Computer Graphics and Algorithms.
%

function [maximum] = gui_histshow(input, bins)
%EVC_HISTSHOW Zeichnet das Histogramm mit angegebenen Anzahl der Balken
%   Das Histogramm soll R, G und B zusammen akkumulieren, d.h. als ob
%   das Bild ein Vektor und keine Matrix wäre.
%   imhist normiert die Intensitäten, deshalb empfehlen wir die Funktionen
%   hist und bar. 
%
%   EINGABE
%   input... Bild
%   bins... Anzahl der Balken
%   AUSGABE
%   maximum... Höhe des größten Balken (Anzahl der Bildpunkte)
    
    %Generiere einen Vektor mit linearen Abständen im Intervall
    %[0,maximale_intensität_im_Bild].
    max_ = max(input(:));
    if isinf(max_)
        max_ = 0;
    end
    x = linspace(0, max(1,max_), bins); % FIXED: make sure max is big enough
    
    
    %Bilde den Histogramm auf das erzeugte Vektor ab und zeichne es
    %als Balkendiagramm. 
    h = hist(input(:), x);
    bar(x, h);
    maximum = max(h);
end