#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
int main() {
    FILE* file;


    int a, b;
    double esatto, approssimato;
    double erroreMedio = 0.0, nme = 0.0;
    int count = 0;


    char fileName[] = "valori_integer.txt";  
    file = fopen(fileName, "r");
    if (file == NULL) {
        printf("Errore nell'apertura del file.\n");
        return 1;
    }
    
    while (fscanf(file, 
        "Valore di A: %d\nValore di B: %d\nRisultato esatto: %lf\nRisultato approssimato: %lf\n",
        &a, &b, &esatto, &approssimato) != EOF) {
        double differenza = approssimato - esatto;
        double differenza_nme;
        if (esatto != 0) {
            differenza_nme = fabs(esatto - approssimato) / fabs(esatto);
        }
        else differenza_nme = 0;
        erroreMedio += differenza;
        nme += differenza_nme;
        count++;
    }
    
    if (count > 0) {
        erroreMedio /= count;
        nme /= count;

        printf("Errore Medio: %.6lf\n", erroreMedio);
        printf("Errore Medio normalizzato (NME): %.6lf\n", nme);
    }
    else {
        printf("Nessun dato trovato nel file.\n");
    }

    
    fclose(file);

    return 0;
}
