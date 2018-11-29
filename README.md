# LFSR
Simple LFSR (linear feedback shift register) based text file cipher in SAGE

The inputs are the exponents of a polynomial (x^16+x^5+x^3->[16,5,3]), a bit word with the same length that the polynomial biggest exponet (using the previous example polynomial, the lenght should be 16) and the file to encrypt.
These fields are specified in the code in the variables: poly, input and filename.

The output is written in a file with the same name that the objective file with .lfsr as additional extension.
