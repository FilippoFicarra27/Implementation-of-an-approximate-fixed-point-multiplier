#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *file;
    char fileName[] = "valori_integer.txt";  // Nome del file con i valori
    
    // Aprire il file per la lettura
    file = fopen(fileName, "r");
    if (file == NULL) {
        printf("Errore nell'apertura del file.\n");
        return 1;
    }

    int a, b;  // Valori di A e B (non necessari per i calcoli ma letti dal file)
    double esatto, approssimato;
    double erroreMedio = 0.0, mse = 0.0;
    int count = 0;

    // Leggere i valori esatti e approssimati dopo le rispettive etichette
    while (fscanf(file, "Valore di A: %d\nValore di B: %d\nRisultato esatto: %lf\nRisultato approssimato: %lf\n", &a, &b, &esatto, &approssimato) != EOF) {
        double differenza = approssimato - esatto;
        erroreMedio += differenza;
        mse += differenza * differenza;
        count++;
    }

    // Calcolo dell'errore medio e dell'MSE
    if (count > 0) {
        erroreMedio /= count;
        mse /= count;

        printf("Errore Medio: %.6lf\n", erroreMedio);
        printf("Errore Quadratico Medio (MSE): %.6lf\n", mse);
    } else {
        printf("Nessun dato trovato nel file.\n");
    }

    // Chiudere il file
    fclose(file);

    return 0;
}
