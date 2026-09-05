
# Tarea 02 capítulo1  -----------------------------------------------------

# Data Visualization


library(tidyverse)
library (palmerpenguins)
penguins
glimpse (penguins)
?penguins

## Creating a ggplot ----

# el primer argumento del ggplot() es el data set para usar en el grafico:
ggplot(data = penguins)

# para la visualizacion del plot vamos a hacer: 
# 1. mapping = aes (x = variable, y = variable). Esto es para definir los ejes del grafico 
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
)

# 2. geom_: este lo usamos para definir la forma que le queremos dar a la info. Puede ser: line; point; boxplot; bar.
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point()

# el waerning msj que nos sale es porqu ehay 2 pinguinos en nuestro dataset que no tienen informacion cargada.


## Adding Aesthetics and Layers ----

# vamos a agregar las especies en nuestro plot, esto lo hacemos poniendole colores diferntes a cada especie
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point()

# con un geom_smooth() vamos a pedirle que trase una curva para cada especie de pinguino. Dentro del parentesis ponemos method = lm para indicar que es un modelo lineal
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)
) +
  geom_point() +
  geom_smooth(method = "lm")

# Como queremos que los puntos tengan colores según la especie, pero no queremos que las líneas se separen según cada especie, debemos especificar color = species solamente para geom_point().
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(mapping = aes(color = species)) +
  geom_smooth(method = "lm")

# tambien podemos agregar distintas formas para las epecies
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(mapping = aes(color = species, shape = species)) +
  geom_smooth(method = "lm")


# podemos mejorar las etiquetas de nuestro gráfico utilizando la función labs() en una nueva capa. Algunos de los argumentos de labs() pueden resultar bastante intuitivos: title agrega un título y subtitle agrega un subtítulo al gráfico.
# Otros argumentos se corresponden con las asignaciones estéticas: x es la etiqueta del eje x, y es la etiqueta del eje y, y color y shape definen las etiquetas de la leyenda.
# Además, podemos mejorar la paleta de colores para que sea accesible para personas con daltonismo utilizando la función scale_color_colorblind() del paquete ggthemes.

library(ggthemes)

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point(aes(color = species, shape = species)) +
  geom_smooth(method = "lm") +
  labs(
    title = "Body mass and flipper length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Flipper length (mm)", y = "Body mass (g)",
    color = "Species", shape = "Species"
  ) +
  scale_color_colorblind()


## Visualizing distributions ----

# Una variable es categórica si solo puede tomar uno de un conjunto reducido de valores. Para examinar la distribución de una variable categórica, podés utilizar un gráfico de barras. La altura de las barras muestra cuántas observaciones corresponden a cada valor de x.
ggplot(penguins, aes(x = species)) +
  geom_bar()

# podemos reordenar las barras transformando las variables en factores para ver la frecuecia
ggplot(penguins, aes(x = fct_infreq(species))) +
  geom_bar()


# Una variable es numérica (o cuantitativa) si puede tomar un amplio rango de valores numéricos y tiene sentido sumar, restar o calcular promedios con esos valores. Las variables numéricas pueden ser continuas o discretas.
# lo mas comun para ver este tipo de variables es un histograma
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200)

# Un histograma divide el eje x en intervalos de igual amplitud y luego utiliza la altura de una barra para mostrar la cantidad de observaciones que caen dentro de cada intervalo.
# Podés establecer el ancho de los intervalos de un histograma con el argumento binwidth, que se mide en las unidades de la variable x. Al trabajar con histogramas, siempre deberías probar distintos valores de binwidth, ya que diferentes anchos de intervalo pueden revelar distintos patrones. En los gráficos de abajo, un binwidth de 20 es demasiado pequeño, lo que da como resultado demasiadas barras y dificulta determinar la forma de la distribución. De manera similar, un binwidth de 2.000 es demasiado grande

ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 20)
ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 2000)

# Una visualización alternativa para las distribuciones de variables numéricas es un gráfico de densidad. Un gráfico de densidad es una versión suavizada de un histograma
ggplot(penguins, aes(x = body_mass_g)) +
  geom_density()

## Visualizing relationships ----

# una numerica y una catecgorica:

# Podemos utilizar diagramas de caja (boxplots) lado a lado. Un boxplot es una especie de representación visual resumida de las medidas de posición (percentiles) que describen una distribución. También es útil para identificar posibles valores atípicos (outliers).
# Cada boxplot está compuesto por:
# 1. Una caja: indica el rango del 50% central de los datos, una distancia conocida como rango intercuartílico (IQR). Se extiende desde el percentil 25 de la distribución hasta el percentil 75. En el medio de la caja hay una línea que muestra la mediana, es decir, el percentil 50 de la distribución. Estas tres líneas permiten tener una idea de la dispersión de la distribución y de si esta es simétrica respecto de la mediana o está sesgada hacia un lado.
# 2. Puntos visuales: representan las observaciones que se encuentran a más de 1,5 veces el IQR de cualquiera de los extremos de la caja. Estos puntos atípicos son poco habituales, por lo que se representan individualmente.
# 3.Una línea: se extiende desde cada extremo de la caja hasta el punto más alejado de la distribución que no es un valor atípico.

ggplot(penguins, aes(x = species, y = body_mass_g)) +
  geom_boxplot()

# Como alternativa, podemos hacer **gráficos de densidad** utilizando `geom_density()`.
ggplot(penguins, aes(x = body_mass_g, color = species)) +
  geom_density(linewidth = 0.75)


# También hemos personalizado el grosor de las líneas utilizando el argumento linewidth, para que se destaquen un poco más sobre el fondo.
# Además, podemos asignar species tanto a las estéticas color como fill, y utilizar la estética alpha para agregar transparencia a las curvas de densidad rellenas. Esta estética toma valores entre 0 (completamente transparente) y 1 (completamente opaco). En el siguiente gráfico, está configurada en 0,5.
ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) +
  geom_density(alpha = 0.5)

# Dos variables categoricas

# Podemos utilizar gráficos de barras apiladas (stacked bar plots) para visualizar la relación entre dos variables categóricas. Por ejemplo, los siguientes dos gráficos de barras apiladas muestran la relación entre island y species, es decir, permiten visualizar la distribución de species dentro de cada isla.
# El primer gráfico muestra las frecuencias de cada especie de pingüinos en cada isla. El gráfico de frecuencias muestra que hay una cantidad igual de Adelies en cada isla.
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar()

# El segundo gráfico, un gráfico de frecuencias relativas creado al establecer position = "fill" en el geom, es más útil para comparar las distribuciones de las especies entre las islas, ya que no se ve afectado por las diferentes cantidades de pingüinos que hay en cada isla.
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")

# Al crear estos gráficos de barras, asignamos la variable que queremos separar en barras a la estética x, y la variable que va a cambiar los colores dentro de las barras a la estética fill.
# Desafortunadamente, ggplot2 etiqueta el eje y como "count" de manera predeterminada, pero podemos modificarlo agregando una capa labs() en la que especificamos que la etiqueta del eje y sea "proportion" (proporción).
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill") +
  labs(y = "proportion")


# Dos variables numericas

# Un gráfico de dispersión probablemente sea el gráfico más utilizado para visualizar la relación entre dos variables numéricas.
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()


# Tres o mas variables

# podemos incorporar más variables a un gráfico asignándolas a estéticas adicionales. Por ejemplo, en el siguiente gráfico de dispersión, los colores de los puntos representan las especies y las formas de los puntos representan las islas.
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = island))

# Sin embargo, agregar demasiadas asignaciones estéticas a un gráfico hace que quede sobrecargado y sea difícil de interpretar. Otra opción, que es particularmente útil para las variables categóricas, es dividir el gráfico en facetas (facets), es decir, subgráficos en los que cada uno muestra un subconjunto de los datos.
# Para dividir tu gráfico en facetas según una sola variable, utilizá facet_wrap(). El primer argumento de facet_wrap() es una fórmula3, que se crea utilizando ~ seguido del nombre de una variable. La variable que pases a facet_wrap() debería ser categórica.
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = species, shape = species)) +
  facet_wrap(~island)


# Saving your plots
# Una vez que hayas creado un gráfico, es posible que quieras sacarlo de R guardándolo como una imagen que puedas utilizar en otro lugar. Esa es la función de ggsave(), que guarda en el disco el gráfico creado más recientemente:
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()
ggsave(filename = "penguin-plot.png")

# Esto guardará tu gráfico en tu directorio de trabajo
