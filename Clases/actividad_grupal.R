
# Actividad grupal --------------------------------------------------------

# libros de guía pra la actividad
# https://ppi-network-analisis-r.netlify.app/#antes-de-empezar
# https://rpubs.com/writetosamadalvi/734930


# vamos a calcular coeficiente de Clustering local: cuanto se conectan entre si los vecinos de un nodo? Mide el grado de cohesión local de una red.
# buscamos tríadas cerradas.
# tmb vamos a calcular el coeficiente de Clustering Medio: es la probabilidad de que dos vecinos de un nodo seleccionado aleatoria/ se enlacen etre sí.
# si tenemos una red conectada todos con todos, el cof de clustering es 1
# si la red es una estrella: el coef de clustering es 0. Los vecinos no estan conectados entre si.
# Coeficiente Global de Clustering: como esta global/la red.

# dostrib normal: la mayoria de los nodos tienen las conexiones casi igual
# si es decreciente: la mayoria de los nodos tiene muy pocas conexiones y algo pasa al final (outliners)

# vamos a calcular los caminos cortos: en redes la distancia física no importa en redes, lo que importa es cuantos links/enlaces hay entre los nodos.


# DATASET: USairports -----------------------------------------------------

## Características de la red: ----
library(igraph); library(igraphdata)
data(USairports)
g <- USairports
summary(g)

# Dirigida con 755 nodos y 23473 aristas
# Atributos de los nodos:
# name (v/c), City (v/c), Position (v/c)
# Atributos de las aristas:
# Carrier (e/c), Departures (e/n), Seats (e/n), Passengers (e/n), Aircraft (e/n), Distance (e/n)

# para saber si es ponderada o no:
is_weighted(g)
# No es ponderada

# para saber si esta conectada
is_connected(g)
# no es conectada

# analizamos los componentes
comp <- components(g)
# cuántas componentes
comp$no 

# cuántas hay de cada tamaño
table(comp$csize)
# tamaño de la más grande
max(comp$csize)        

max(comp$csize) / vcount(g)
# Tiene 6 componentes
# Componente + grande 745 aeropuertos
# 1 de 3
# 3 pares
# 1 aeropuerto solo 
# El 98,7% de los aeropuertos esta en la componente gigante. Solo quedan afuera 10 aeropuertos grupos chicos.


# como se conecta-----
grados <- degree(g)
mean(grados)
median(grados)
# Grado promedio: 62,18
# Mediana: 13
# Hay mucha asimetría. La mediana nos dice cómo es el aeropuerto típico.

# histograma:
hist(grados, breaks = 50, col = "steelblue", border = "white",
     main = "Distribución de grados - USairports", xlab = "Grado")
# top 5 hubs:
top5 <- sort(grados, decreasing = TRUE)[1:5]
top5
V(g)[names(top5)]$City
# Los 5 aeropuertos más conectados: Atlanta; Chicago; Denver; Detroit y Minneapolis
# Tiene sentido que sean hubs xq coincide con que pocos tienen muchas conexiones y son grandes aeropuertos.


# densidad:
edge_density(g)
# La densidad es 4,1%: es una red muy esparsa.


# estructura de la red:
# clustering
transitivity(g, type = "global")
# distancia promedio
mean_distance(g)  
# diámetro: distancia más larga entre dos aeropuertos
diameter(g)         

# El coeficiente de clustering global es de 0.3384 se considera alto con respecto a la densidad, aunque la red es esparza es general, las conexiones tienden concentrarse en grupos locales 
# La distancia promedio entre nodos 3.447169. Entre dos aeropuertos cualesquiera, el camino más corto tiene en promedio entre 3 y 4 vuelos (2 o 3 escalas). El diámetro de 8, los dos aeropuertos mas alejados de la red estan a 8 vuelos de distancia. Aunque la red es esparsa (densidad 0,0145), los hubs funcionan como atajos y acortan casi todos los caminos. (Efecto mundo pequeño)


# comunidades:
# el set.seed se usa para que tenga siempre la misma aleatoriedad
set.seed(1)
com <- cluster_louvain(as_undirected(g))
length(com)
sizes(com)

# hay 17 comunidades. Las 5 grandes concentran casi toda la red. Las mas chicas con componentesd esconectadas.





# Integrantes -------------------------------------------------------------

# Martina Trezza
# Xavier López
# Delfina Esponda
