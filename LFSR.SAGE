#funcion que genera una lista con la clave en funcion de la palabra de entrada y el polinomio
def generarClave(input,poly):
    actual=list(input)
    key=[]

    while(True):
        #Se realiza el XOR de las posiciones actuales de la palabra inicial en funcion del polinomio
        #Para ello hacemos la suma de los bits de la secuencia de entrada que coinciden con el polinomio
        acum=0
        for p in poly:
            acum=acum+actual[p-1]

        #insertamos el nuevo bit en la secuencia (si la sumatoria de bits es par, el XOR da 0, en caso contrario es 1)
        if(acum%2==0):
            actual.insert(0,0)
        else:
            actual.insert(0,1)

        #extraemos de la secuencia el primer elemento (mas a la derecha) y añadimos el nuevo bit a la clave
        elem=actual.pop()
        key.insert(0,elem)

        #si la secuencia actual es igual a la palabra inicial, se detiene la generacion de la clave
        if(actual==input):
            break

    #print key
    return key

#funcion que cifra haciendo un XOR entre las dos listas que recibe
def cifrar(listaBinarios,listaClave):
    listaCifrada=[]

    #Se hace XOR de cada bit en orden con uno de la clave
    for i in range(0,len(listaBinarios)):
        listaCifrada.append((listaBinarios[i]+listaClave[i])%2)
    return listaCifrada


#Fichero a cifrar, palabra inicial y exponentes del polinomio utilizados
filename="/home/pedromi/nombre.txt"
input = [1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1]
poly = [16,15,13,4]


#abrir fichero
fich=open(filename,"rb")
textoInicial=fich.read()
print textoInicial

#pasamos el texto a un numero y despues a una lista de bits
lista=[ord(c) for c in textoInicial]
numero=ZZ(lista,256)
listaBinarios=numero.digits(2)

#generamos la clave en funcion de la palabra inicial y el polinomio
listaClave=generarClave(input,poly)

#si la clave generada es mas grande que el texto a cifrar, se cifra el texto
if(len(listaClave)>len(listaBinarios)):

    #ciframos haciendo un XOR de la clave generada y la lista de bits del texto
    listaCifrada=cifrar(listaBinarios,listaClave)

    #la lista de bits cifrados se pasa a un numero entero y despues a texto ASCII
    numeroCifrado=ZZ(listaCifrada,2)
    textoCifrado=''.join([chr(c) for c in numeroCifrado.digits(256)])
    print "\n"+textoCifrado

    #El texto se escribe en un fichero con el mismo nombre que el original y ".lfsr" como extension final
    fichCifrado=open(filename+".lfsr","wb")
    fichCifrado.write(textoCifrado)
    fichCifrado.close()
    print "\n"+"Fichero escrito correctamente en: "+filename+".lfsr"

    """
    #Como prueba de que se descifra correctamente, se repite el proceso con el texto cifrado y la misma clave
    #Como archivo a leer se introduce el que se acaba de escribir con el texto cifrado
    fich=open(filename+".lfsr","rb")
    textoCifrado=fich.read()
    listaCif=[ord(c) for c in textoCifrado]
    numeroCif=ZZ(listaCif,256)
    listaBinariosCif=numeroCif.digits(2)
    listaDescifrada=cifrar(listaBinariosCif,listaClave) #no se genera una nueva clave, se reutiliza la ya calculada al cifrar
    numeroDescifrado=ZZ(listaDescifrada,2)
    textoDescifrado=''.join([chr(c) for c in numeroDescifrado.digits(256)])
    print "\n"+textoDescifrado
    fichCifrado=open(filename+".deslfsr","wb")
    fichCifrado.write(textoDescifrado)
    fichCifrado.close()
    """

#si la clave generada a partir del input y el polinomio es mas pequeña que el texto a cifrar se muestra un mensaje de eror
else:
    print "El polinomio y los bits introducidos generan una clave demasiado corta para cifrar el texto"