#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main() {
    FILE* fileEsatto, * fileApprossimato;
    char esattoFileName[] = "risultato_esatto_1x3.pgm"; 
    char approssimatoFileName[] = "risultato_approssimato_1x3.pgm";  

    fileEsatto = fopen(esattoFileName, "r");
    fileApprossimato = fopen(approssimatoFileName, "r");

    if (fileEsatto == NULL || fileApprossimato == NULL) {
        printf("Errore nell'apertura dei file.\n");
        return 1;
    }

    double esatto, approssimato;
    double erroreMedio = 0.0, nme = 0.0;
    int count = 0;
    int count_zeri = 0;
    
    while (fscanf(fileEsatto, "%lf", &esatto) != EOF 
        && fscanf(fileApprossimato, "%lf", &approssimato) != EOF) {
        double differenza = approssimato - esatto;
        double differenza_nme;
        if (esatto != 0) {
            differenza_nme = fabs(esatto - approssimato) / fabs(esatto);
            
        }
        else {
            differenza_nme = 0;
            count_zeri++;
        }
        erroreMedio += differenza;
        nme += differenza_nme;
        count++;
    }

  
    if (!feof(fileEsatto) || !feof(fileApprossimato)) {
        printf("I file non contengono lo stesso numero di valori.\n");
        fclose(fileEsatto);
        fclose(fileApprossimato);
        return 1;
    }

    
    if (count > 0) {
        erroreMedio /= count;
        nme /= count;

        printf("Errore Medio: %.6lf\n", erroreMedio);
        printf("Errore Medio normalizzato (NME): %.6lf\n", nme);
        printf("Nel file sono presenti %d zeri\n", count_zeri);
        printf("Nel file sono presenti %d righe\n", count);
    }
    else {
        printf("Nessun dato trovato nei file.\n");
    }

    
    fclose(fileEsatto);
    fclose(fileApprossimato);

    return 0;
}
