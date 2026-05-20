#include <stdio.h>
#include <io.h>
#include "system.h"

#define INVERTER_BASE   BYTE_INVERTER_AVALON_INTERFACE_0_BASE

void print_bytes(unsigned int val, const char *label)
{
    unsigned char b0 = (val >>  0) & 0xFF;
    unsigned char b1 = (val >>  8) & 0xFF;
    unsigned char b2 = (val >> 16) & 0xFF;
    unsigned char b3 = (val >> 24) & 0xFF;

    printf("%s : 0x%02X | 0x%02X | 0x%02X | 0x%02X\n", label, b3, b2, b1, b0);
}

int main(void)
{
    /* ===== A MODIFIER : valeurs de test ===== */
    unsigned int input = 0x12345678;   // mot à inverser
    unsigned int mode = 0;              // 0 = complet, 1 = paires
    /* ========================================== */

    unsigned int output;

    printf("=== Inverseur de Bytes ===\n\n");

    print_bytes(input, "Entree");

    IOWR_32DIRECT(INVERTER_BASE, 0, input);
    IOWR_32DIRECT(INVERTER_BASE, 4, mode);

    output = IORD_32DIRECT(INVERTER_BASE, 8);

    print_bytes(output, "Sortie");

    if (mode == 0) {
        printf("Mode : COMPLET\n");
    } else {
        printf("Mode : PAIRES\n");
    }

    return 0;
}