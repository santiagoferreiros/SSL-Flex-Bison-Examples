Primeiro compilador utilizando Bison e flex:

Multi-Function Calculator: mfcalc

Por: Thiago Rogelio Ramos


--------------------------------------------------------------------


+ Para obter os pacotes necessários para compilação e atualização:

$ sudo apt-get install git build-essential

+ Para obter a versão mais atualizada deste programa:

$ git clone https://github.com/thiagorogelio/mfcalc

+ Compilação:

$ make

--------------------------------------------------------------------

Funcionando até o momento:

+ Variáveis

+ Funções nativas
  - Aritméticas: (atan, cos, exp, ln, sin, sqrt)
  - Funcionais: (exit, print)

+ Operações matemáticas

-------------------------------------------------------------------

Execução:

$ ./calc
> a = 10
10
> a + 2
12
> a = a + 6
16
> sqrt(a)
4
> a = a ^ sqrt(a)
65536
> exit
Goodbye!
$























