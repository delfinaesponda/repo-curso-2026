"helow world"
5 + 5
plot(1:10)


# Variables ------------------------------------------------------

name <- "Delfina"
age <- "22"
name
age

# name y age son variables, los que ponemos en las comillas son valores.
# el <- se usa para asignar

name <- "pedro"
print(name)

# el print no es necesario en este caso, solo con escribir el nombre de la variable nos devuelve el valor qu le asignamos

for(x in 1:10) {print(x)}

## Concatenate elemnts ----

# para unir elementos usamos la funcion paste y una "," entre las variables o elementos

text <- "awesom"
paste ("R is",text)

# el resultado es unir las dos cosas, el comando devuelve "R is awesome"
# tambien podemos unir dos textos que creamos:

text1 <- "hola"
text2 <- "soy delfina"
paste(text1,text2)

# si hablamos de numeros, tenemos que usar el "+" para unirlos

num1 <- 5
num2 <- 10
num1 + num2

# no se puede combinar un (text) y un numero, da error

## Multiple Variables -----

# le asignamos el mismo valor a multiples variables:

var1 <- var2 <- var3 <- "Orange"

# si les hacemos print:
var1
var2
var3

## Variable Names ------

# El nombre de variable debe comenzar con una letra y puede ser una combinación de letras, dígitos, punto (.) y guion bajo (_). Si comienza con punto (.), no puede ir seguido de un dígito.
# El nombre de variable no puede comenzar con un número o un guion bajo (_)
# Los nombres de variables distinguen entre mayúsculas y minúsculas (age, Age y AGE son tres variables diferentes)
# Las palabras reservadas no pueden usarse como variables (TRUE, FALSE, NULL, if...)


# Data Types --------------------------------------------------------------

# con el class() podemos chequear que tipo de variable es

# numeric
x <- 10.5
class(x)

# integer
x <- 1000L
class(x)

# complex
x <- 9i + 3
class(x)

# character/string
x <- "Me llamo Delfina"
class(x)

# logical/boolean
x <- TRUE
class(x)


# Numbers -----------------------------------------------------------------

# hay 3 tipos de numeros en R

x <- 10.5
# numeric

y <- 10L
# integer

z <- 1i
# complex

# Number: cualquier numero con o sin decimales

x <- 10
y <- 20
x
y
class(x)
class(y)

# Integer: son si o si sin decimales. Hay que agregarles la letra "L" al final

x <- 100L
y <- 40L
x
y
class(x)
class(y)

# Complex: se pone la "i" para indicar que es un numero imaginario

x <- 3+5i
y <- 5i
x
y
class(x)
class(y)


# Podemos convertir de un numero a otro con las siguientes funciones:

x <- 1L
y <- 2

# de integer a numeric
a <- as.numeric(x)

# de numeric a integer
b <- as.integer(y)

# si les hacemos print y class:
x
y
class(a)
class(b)


# Math --------------------------------------------------------------------

# el signo "+" se usa para las sumas y el signo "-" para las restas:

5 + 5
20 - 5

# podemos hacer funciones:
# x ejemplo minimos y maximos en un set

max(5,10,15)
min(5,10,15)

# con el sqrt vamos a tener la raiz cuadrada:
sqrt(16)

# con abstenemos el valor positivo absoluto de un numero:
abs(-8.68)

# si queremos redondear un numero:
# para arriba: usamos ceiling
ceiling(1.4)
# para abajo: usamos floor
floor(1.4)


# Striings ----------------------------------------------------------------

# se usan para gardar textos y se puede usar dos comillas o una (son cadenas de texto)

"hello"
'helllo'

# para asignarle un string:
str <- "hello"
str

# podemos asignarle muchas lineas a una variable:
str <- "Me llamo Delfina, 
tengo 22 años,
estudio economia en la UBA"
str

# en el resultado sale una /n: eso indica que apretamos el enter, o sea una nueva linea

# si usamos "cat" devuelve todo en la misma posicion que en el codigo
cat(str)

# para saber la cantidad de caracteres en un string usamos "nchar"
str <- "Hola mundo"
nchar(str)

# para verificar si un carácter o una secuencia de caracteres está presente en una cadena usamos "grelp"
str <- "hola mundo"
grepl("h",str)
grepl("hello",str)
grepl("hola",str)

# con la funcion "paste" concatenamos dos strings:
str1 <- "Hola"
str2 <- "me llamo Delfina"
paste(str1,str2)
# el resultado es la union de ambos: "Hola me llamo Delfina"


# escape characters:
# Para insertar caracteres que no están permitidos en una cadena, debés usar un carácter de escape.
# Un carácter de escape es una barra invertida `\` seguida del carácter que querés insertar.
# Un ejemplo de carácter no permitido es una comilla doble dentro de una cadena que está delimitada por comillas dobles:
str <- "We are the so-called "Vikings" from the north"

# para corregir el error: usamos la back slash:
str <- "We are the so-clled \"Vickings\" from the north"
str
cat(str)

# con el "cat" vemos el resultado del print de "str" sin la backslash  y las comillas


# Booleans/Logical Values -------------------------------------------------

# nos devuelve "TRUE" o "FALSE" segun lo que le pidamos:

# si comparamos numeros:
10 > 5
# nos devuelve TRUE porque 10 es mayor que 5
10 == 9
# nos devuelve FALSE porque 10 no es igual a 9
10 < 5
# nos devuelve False porque 10 no es menor que 5

# si comparamos varibles:
a <- 5
b <- 10
a > b
# nos devuelve FALSE

# tambien podemos usar condiciones con una funcion "if":
a <- 200
b <- 3
if(b>a) {print("b es mayor que a")} else {print ("b no es mayor que a")}


# Operators ---------------------------------------------------------------

# los distintos operadores de R son: arithmetic; assignment; comparison; logical; miscellaneous


## Arithmetic Operators -----

# para las operaciones matematicas basicas

# "+": para las sumas
# "-": para las restas
# "*": para las multiplicaciones
# "/": para las divisiones
# "^": para los exponentes
# "%%": para el resto de una divison
# "%/%": para el resultado de la division redondeado hacia abajo, sin decimales

## Assignment Operators ----

# para asignarle valor a las variables

my_var <- 3
my_var <<- 3
3 -> my_var
3 ->> my_var
my_var

# son todas formas distintas d ehacerlo. Cuando hacemos el print de my_var nos devuelve el 3


## Comparison Operators ----
# para comparar dos valores

# "==": igual
# "!=": no igual
# ">": mayor que
# "<": menor que
# ">=": mayor o igual que
# "<=": menor o igual que

## Logical Operators ----
# para combianr varias condiciones en una sola evaluacion

# "&": AND. Compara elemento x elemento
# "&&": AND. Solo mira el primer elemento de cada lado, y devuelve un único valor (TRUE o FALSE), no un vector.
# "|": OR. Compara elemento x elemento
# "||": OR. Solo mira el primer elemento de cada lado, y devuelve un único valor (TRUE o FALSE), no un vector.
# "!": NOT. Invierte el resultado, devuelve FALSE si es TRUE


## Miscellaneous Operators ----

# para manipular data

# ":": crea una serie de meros consecutivos del primero al ultimo
x <- 1:10
x
# vamos a ver una lista de numeros del uno al 10. Si ponemos 10:1 lo devuelve al reves, una lista de 10 a 1

# "%in%": pertenece a. Te dice si un elemto esta o no dentro de un vector. devuelve TRUE o FALSE
provincias <- c("Buenos Aires","Córdoba","Santa Fe")
# la "c" es para que se combinen los elementos y cree un vector. Sino da error.

"Córdoba" %in% provincias
"Jujuy" %in% provincias

# "%*%": para multiplicar matrices

A <- matrix(c(1, 2, 3, 4), nrow = 2)
B <- matrix(c(5, 6, 7, 8), nrow = 2)

A %*% B   
# multiplicación matricial real
A * B     
# multiplicación elemento por elemento (distinto resultado)


# los ejemplos de este tipo de operadores se los pedi a la AI para entenderlos mejor.


# If else -----------------------------------------------------------------

# Una "declaración if" se escribe con la palabra clave `if`, y se usa para especificar un bloque de código que se ejecutará si una condición es `TRUE`

a <- 33
b <- 200
if (a>b) {print("b es mayor que a")}
if (b>a) {print("b es mayor que a")}

# las {} se usan para el scope del codigo

# "else if": se usa para decir: si la condicion anterior no es cierta, proba esta otra

a <- 33
b <- 33
if (b > a) {print("b es mayor que a")} else if (a==b) {print("a y b son iguales")}

# el comando "else" tiene en cuenta todo lo que quedo por fuera de la condicion que se plateo

a <- 200
b <- 33
if(b>a) {print("b es mayor que a")} else if (a == b) {print("a y b son iguales")} else {print("a es mayor que b")}

# el "else" puede ser usado sin el "else if":

if (b > a) {print("b es mayor que a")} else {print("b no es mayor que a")}


## Nested if ----

# podemos poner un if adentro de otro:

x <- 41
if (x > 10) {print("por encima de diez") 
if (x > 20) {print("tambien por encima de 20!")} 
else {print("pero no por encima de 20.")} } else {print("por debajo de 10.")}

# para hacer un if dentro de otro hay uqe hacer un salto de linea. El eslse dentro de otro deben estar en la misma linea


## AND OR ----

# el simbolo "&" (AND) es un operador logico y se usa para combianr condiciones:

a <- 200
b <- 33
c <- 500
if (a > b & c > a) {print("las dos condiciones son ciertas")}

# el simbolo "|" (OR) es un operador logico y se usa para combinar condiciones: 

if (a > b | a > c) {print("al menos una de las condiciones es cierta")}


# While Loop --------------------------------------------------------------

# puede ejecutar un conjunto de instrucciones mientras la condicion sea verdadera

i <- 1
while(i < 6) {print(i) 
  i <- i + 1}

# el loop entrega numeros del 1 al 5, frena en 6 porque 6 < 6 es Falso
# con un break podemos frenar el loop aunque la condicion sea TRUE

i <- 1
while(i < 6) {
  print(i)
  i <- i + 1
  if(i == 4) {
    break
    }
}


# con el "next" podemos saltear una iteracion y seguir con el loop:

i <- 0
while (i < 6) {
  i <- i + 1
  if (i == 3) {
    next
  }
  print(i)
}

## If else combined with a while loop ----

dice <- 1
while (dice <= 6) {
  if (dice < 6) {
    print("No Yahtzee")
  } else {
    print("Yahtzee!")
  }
  dice <- dice + 1
}

# si el loop pasa por los valores del 1 al 5, imprime "No Yahtzee". Cuando pasa por el valor 6, imprime "Yahtzee!".


# For Loops ---------------------------------------------------------------

# para iterar sobre una secuecia

for (x in 1:10) {
  print (x)
}

fruits <- list("mazana", "banana", "frutilla")
for (x in fruits) {
  print(x)
}

dice <- c(1, 2, 3, 4, 5, 6)
for (x in dice) {
  print(x)
}


# con un "break" podemos frenar el loop tambien

fruits <- list("manzana", "banana", "frutilla")
for (x in fruits) {
  if (x == "frutilla") {
    break
  }
  print(x)
}


# con el next podemos saltear una iteracion:

fruits <- list("manzana", "banana", "frutilla")
for (x in fruits) {
  if (x == "banana") {
    next
  }
  print(x)
}


## If else combined with a For loop ----

# print "Yahtzee" si el dice number es 6

dice <- 1:6
for (x in dice) {
  if (x == 6) {
    print (paste("el dice number es", x, "Yahtzee"))
  } else {
    print (paste("el dice number es", x, "No Yahtzee"))
  }
}


## Nested loop -----

adj <- list("red", "big", "tasty")

fruits <- list("apple", "banana", "cherry")
for (x in adj) {
  for (y in fruits) {
    print(paste(x, y))
  }
}


# Data Structures ---------------------------------------------------------

## Vectors ----

# lista de items que son del mismo tipo
# para combianr los items hay que poner  "c()" para que se cree el vector y separar los items con una coma

frutas <- c("manzana", "banana", "pera")
frutas

numeros <- c(1, 2, 3)
numeros

# para que el vector sea una secuencia numerica usamos los ":"

numeros <- 1:10
numeros

# lo mismo podemos hacer con decimales, lo unico es que si el numero que escribimos (el decimal) no esta incluido, no va a aparecer

numeros1 <- 1.5:6.5
numeros1

# el resultado es 1.5 2.5 3.5 4.5 5.5 6.5

numeros2 <- 1.5:6.3
numeros2

# el resultado es 1.5 2.5 3.5 4.5 5.5

# tambien podemos hacer un verctor de valores logicos:

log_values <- c(TRUE, FALSE, TRUE, FALSE)
log_values


# podemos ver la cantidad de items de un vector usando "length()"

frutas <- c("manzana", "banana", "pera")
length(frutas)


# podemos ordenar el vector usando "sort()"

frutas <- c("manzana", "banana", "pera")
sort(frutas)

numeros <- c(50, 20, 100,14)
sort(numeros)

# podemos ir al item del vector que querramos referenciandolo entre "[]"
frutas <- c("manzana", "banana", "pera")
frutas [1]

# esto devuelve: manzana, porque es el primer item del vector

# tambien podemos acceder a mas de uno poniendo [c()]:

frutas [c(1,3)]

# para acceder a todos menos uno, podemos poner un "-" adelante del numero de item que nos referimos:

frutas <- c("manzana", "banana", "pera", "naranja", "frutilla")
frutas [c(-2)]

# para cambiar un item de nombre:

frutas <- c("manzana", "banana", "pera", "naranja", "frutilla")
frutas [1] <- "mandarina"
frutas
# ahora el primer item paso de ser manzana a mandarina

# si queremos repetir los vectores usamos "rep"

repeat_each <- rep(c(1, 2, 3), each = 3)
repeat_each

# repetimos la secuencia:

repeat_times <- rep (c(1, 2, 3), times = 3)
repeat_times

# basicamente aparece: 123123123

# para hecre repeticiones de cada valor especificamente:

repeat_indep <- rep (c(1, 2, 3), times = c(5, 2, 1))
repeat_indep

# el 1 aparece 5 veces, el 2 dos veces y el 3 una vez


# sequenced vectors

numeros <- seq(from = 0, to = 100, by = 20)
numeros

# lo que le pedimos en este caso es que nos de los numero del 0 al 100 de 20 en 20

## Lists ----

# para crear una lista usamos "list()"

thislist <- list("delfina", "pedro","juan")
thislist

# con [] accedemos al item que queremos
thislist[1]

# para cambiar un valor de la lista:
thislist[2] <- "marta"
thislist

# para ver el largo de la lista:
length(thislist)


# podemos ver si un item existe en la lista usnado %in%:

thislist <- list("delfina", "marta","juan")
"delfina" %in% thislist

# como delfina esta en la lista devuelve TRUE

# si queremos agregar algo mas a la lista usamos "append()"

thislist <- list("delfina", "marta","juan")
append(thislist, "vanina")

# para agregar algo en un lugar especifico, tenemos que poner dentro del append "after=index number"

thislist <- list("delfina", "marta","juan")
append(thislist, "vanina", after = 2)

# para eliminar un item ponemos el numero de index entre [] con un -

thislist
newlist <- thislist [-1]
newlist

# podemos especificar un rango de index, mencionando el principio y el final

thislist <- list("delfina", "juan", "vanina", "rodrigo", "josefina", "alfonso")
(thislist) [2:5]

# solamente muestra los index 2,3,4 y 5

# podemos hacer un loop en la lista usando el for loop:

thislist <- list("delfina", "marta","juan") 
  for(x in thislist){
    print(x)
  }


# para concatenar varias listas hay diversas maneras:

# 1:
list1 <- list(1, 2, 3)
list2 <- list ("a", "b", "c")
list3 <- c(list1,list2)
list3


## Matrices ----

# para crear una matriz vamos a tener que especificar las filas y columnas:

thismatrix <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 3, ncol = 2)
thismatrix

# lo mismo podemos hacer con strings

thismatrix <- matrix(c("delfina", "juan", "vanina", "rodrigo", "josefina", "alfonso"), nrow = 3 , ncol = 2)
thismatrix


# para acceder a algun item en especifico usamos los []

thismatrix [1,2]

# eso nos trae el elemnto de la fila 1 columna 2

# para acceder a toda la fila:
thismatrix [1,]

# para acceder a toda la columna:
thismatrix [,2]

# para acceder a mas de una fila usamos c():
thismatrix <- matrix (c("delfina", "juan", "vanina", "rodrigo", "josefina", "alfonso", "liliana", "daniel", "fran"), nrow = 3, ncol = 3)
thismatrix
thismatrix [c(1,2),]                     
# aca tenemos las filas 1 y 2 de la matriz

# para acceder a mas de una columna tambien usamos c():
thismatrix
thismatrix[, c(1,2)]
# aca tenemos las columnas 1 y 2

# para agregar una columna usamons cbind()
thismatrix
newmatrix <- cbind(thismatrix, c("juli", "valen", "mica"))
newmatrix

# para agregar una fila usamos rbind()
thismatrix
newmatrix <- rbind(thismatrix, c("juli", "valen", "mica"))
newmatrix                   

# para eliminar filas y columnas:
thismatrix
thismatrix <- thismatrix [-c(1), -c(1)]
thismatrix
# ahí eliminamos la primer fila y la primer columna de la matriz

# para chquear si un item esta en a matriz usamos "%in%"
thismatrix
"josefina" %in% thismatrix
# si es verdadero devuelve TRUE

# para saber la cantidad de columans y filas de la matriz usamos "dim()"
thismatrix
dim(thismatrix)

# para saber la dimension de la matriz (cantidad de elementos) usamos "length()"
thismatrix
length(thismatrix)

# con un for loop podemos hacr loop en la matriz
thismatrix <- matrix(c("apple", "banana", "cherry", "orange"), nrow = 2, ncol = 2)

for (rows in 1:nrow(thismatrix)) {
  for (columns in 1:ncol(thismatrix)) {
    print(thismatrix[rows, columns])
  }
}


# Tambien se puede combianr matrices:
Matrix1 <- matrix(c("apple", "banana", "cherry", "grape"), nrow = 2, ncol = 2)
Matrix2 <- matrix(c("orange", "mango", "pineapple", "watermelon"), nrow = 2, ncol = 2)

# la agregamos como fila:
Matrix_Combined <- rbind(Matrix1, Matrix2)
Matrix_Combined

# la agregamos como columna:
Matrix_Combined <- cbind(Matrix1, Matrix2)
Matrix_Combined

## Arrays ----

# pueden tener mas de dos dimensiones 

# un array de una dimension con valores del rango 1 a 24
thisarray <- c(1:24)
thisarray

# ahora con varias dimensiones:
multiarray <- array (thisarray, dim = c(4, 3, 2))
multiarray


# How does dim=c(4,3,2) work?
# The first and second number in the bracket specifies the amount of rows and columns.
# The last number in the bracket specifies how many dimensions we want.

# para acceder a algun elemnto usamos []

multiarray
multiarray[2, 3, 2]
# ahi estamos buscando el elemento de la fila 2, columna 3, matirz 2

# para acceder a la primer fila:
multiarray
multiarray[c(1),,1]
# el 1 es la fila 1, entre las comas no hay nada porque no buscamos columnas y el 1 del final indica que es la primer matriz

# idem con la columna:
multiarray
multiarray[,c(1),1]
# al principio no hay nada porqu eno buscamos filas, el 1 es la columna que queremos y el otro 1 es la matriz que queremos

# para chequear si existe un elemento usamos %in%:
2 %in% multiarray
# si devuelve TRUE es porque esta el elemento

# para saber la cantidad de filas y columnas usamos dim()
multiarray
dim(multiarray)
# en este caso devuelve 432: esto significa que hay 4 filas en cada matriz, 3 columnas en cada matriz y 2 matrices

# para saber la dimension (cant de elementos) usamos length()
multiarray
length(multiarray)


# con el for loop podemos hacer loop en los array:
multiarray
for (x in multiarray) {
  print(x)
}


# Data Frames -------------------------------------------------------------

# es data en tablas. Puede combinar ditintos tipos de data, characters, logical, numerical. Pero cada columna tiene que tener el mismo data type
# para crear un dat aframe usamos la funcion: "data.frame()"

data_frame <- data.frame (
  entrenamiento = c ("fuerza", "velocidad", "otro"),
  pulso = c(100, 150, 200),
  duracion = c (60, 30,45)
)
data_frame


summary(data_frame)


# para acceder a info de la data frame podemos usar [] [[]] o $

data_frame[1]

data_frame[["entrenamiento"]]

data_frame$entrenamiento

# las tres opciones devuelven la misma informacion

# para agregar una nueva fila usamos "rbind()"
data_frame
newrowDF <- rbind(data_frame, c("fuerza", 110, 110))
newrowDF


# para agregar columnas usamos "cbind()"
data_frame
newcolDF <- cbind (data_frame, pasos = c(1000, 2000, 6000))
newcolDF

# para eliminar filas y columnas usamos -c
data_frame_new <- data_frame [-c(1), -c(1)]
data_frame_new

# para contar la dimension usamos dim()
dim(data_frame)
# el rdo es 3 3 porque son 3 filas 3 columnas

# para saber el numero de columnas: ncol(). Tambien podemos usar length
length(data_frame)
ncol(data_frame)
# para saber el numero de filas: nrow()
nrow(data_frame)


# para combinar data frames de manera vertical usamos rbind:
Data_Frame1 <- data.frame (
  Training = c("Strength", "Stamina", "Other"),
  Pulse = c(100, 150, 120),
  Duration = c(60, 30, 45)
)

Data_Frame2 <- data.frame (
  Training = c("Stamina", "Stamina", "Strength"),
  Pulse = c(140, 150, 160),
  Duration = c(30, 30, 20)
)

New_Data_Frame <- rbind(Data_Frame1, Data_Frame2)
New_Data_Frame


# para combinar data frames de manera horizontal usamos cbind:
Data_Frame3 <- data.frame (
  Training = c("Strength", "Stamina", "Other"),
  Pulse = c(100, 150, 120),
  Duration = c(60, 30, 45)
)

Data_Frame4 <- data.frame (
  Steps = c(3000, 6000, 2000),
  Calories = c(300, 400, 300)
)

New_Data_Frame1 <- cbind(Data_Frame3, Data_Frame4)
New_Data_Frame1



# Factors -----------------------------------------------------------------

# sirven para categorizar data
# usamos la funcion factor()

genero_musical <- factor(c("pop","rock","jazz","trap", "classic","pop","trap"))
genero_musical

# levels es una vez cada uno, no se repite
# para ver solo los levels hacemos "levels()"
levels(genero_musical)

# con lagth vemos la cantidad de items del factor:
length(genero_musical)

# para acceder a un item usamos []
genero_musical[3]

# para cambiar un valor: si o si tiene que ser por uno que ya exista dentro del factor
genero_musical[3] <- "pop"
genero_musical


# si es uno que no existe en el factor, hay que especificarlo en levels()
music_genre <- factor(c("Jazz", "Rock", "Classic", "Classic", "Pop", "Jazz", "Rock", "Jazz"), levels = c("Classic", "Jazz", "Pop", "Rock", "Opera"))

music_genre[3] <- "Opera"

music_genre[3]
