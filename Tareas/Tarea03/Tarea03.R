
# Tarea 03capítulo1  -----------------------------------------------------

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

# Exercise:

# 1.How many rows are in penguins? How many columns?
nrow(penguins)
ncol(penguins)
glimpse(penguins)
# Con estas formas podemos ver que hay 8 columnas y 344 filas

# 2. What does the bill_depth_mm variable in the penguins data frame describe? Read the help for ?penguins to find out.
?penguins
# Mide la profundidad del pico en milimertos. Es una variable numerica

# 3. Make a scatterplot of bill_depth_mm vs. bill_length_mm. That is, make a scatterplot with bill_depth_mm on the y-axis and bill_length_mm on the x-axis. Describe the relationship between these two variables.
ggplot(
  data = penguins,
  mapping = aes(x = bill_length_mm, y = bill_depth_mm)
) +
  geom_point(aes(color = species, shape = species)) +
  geom_smooth(method = "lm") +
  labs(
    title = "Bill length and depth",
    subtitle = "Adelie, Chinstrap, and Gentoo Penguins",
    x = "Bill length (mm)", y = "Bill depth (mm)",
    color = "Species", shape = "Species"
  ) +
  scale_color_colorblind()

# En el grafico, la linea lm global muestra una tendencia negativa, por lo que enterminos generales, cuanto mas largo el pico, menos profundo.
# Si miramos cada especie en particular: Adelie tienen en su mayoria picos cortos pero profundos; Chinstrap tienen picos mas bien profundos y mas largos que los Adelie; Gentoo tinen picos largos y poco profundos.


# 4. What happens if you make a scatterplot of species vs. bill_depth_mm? What might be a better choice of geom?
ggplot(
  data = penguins, mapping = aes(x = species, y = bill_depth_mm)) +
  geom_boxplot()
# Con el boxplot vemos la distribucion de una variable numerica dentro de cada categoria. Tambien nos permite ver outliers.


# 5. Why does the following give an error and how would you fix it?
ggplot(data = penguins) + 
  geom_point()
# Cuando lo corremos, el error nos indica que nos falta definir los ejes (x;y)
# Habria que agregar despues de data: mapping = aes (x = ..., y =...)


# 6. What does the na.rm argument do in geom_point()? What is the default value of the argument? Create a scatterplot where you successfully use this argument set to TRUE.
?geom_point
# El default de na.rm es FALSE, los valores missing se remueven y sale un aviso. Si ponemos TRUE, los missing values se remueven pero sin aviso
# con na.rm = TRUE
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = bill_depth_mm)) + 
  geom_point(na.rm = TRUE)

# 7. Add the following caption to the plot you made in the previous exercise: “Data come from the palmerpenguins package.” Hint: Take a look at the documentation for labs().
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = bill_depth_mm)) + 
  geom_point(na.rm = TRUE) + 
  labs(caption = "Data come from the palmerpenguins package.")


# 8. Recreate the following visualization. What aesthetic should bill_depth_mm be mapped to? And should it be mapped at the global level or at the geom level?
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(aes(color = bill_depth_mm)) +
  geom_smooth() +
  labs(caption = "Data come from the palmerpenguins package.")
# El bill_depth_mm va mapped al nivel del geom point, para que se coloren los puntos segun bill depth.


# 9. Run this code in your head and predict what the output will look like. Then, run the code in R and check your predictions.
# El grafico va a ser de las islas y va a eliminar los missing values. Como color esta a nivel del ggplot, vamos a ver una curva por isla
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = island)
) +
  geom_point() +
  geom_smooth(se = FALSE)

# 10. Will these two graphs look different? Why/why not?
# Gráfico A
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point() +
  geom_smooth()

# Gráfico B
ggplot() +
  geom_point(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  ) +
  geom_smooth(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  )

# Los graficos son iguales. Mas alla del que el grafico B tenga el mapping en geom_smooth, los valores de los geom son los mismos.


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


# Exercises:

# 1. Make a bar plot of species of penguins, where you assign species to the y aesthetic. How is this plot different?
ggplot(penguins, aes(y = species)) +
  geom_bar()
# Ahora las barras son horizontales


# 2. How are the following two plots different? Which aesthetic, color or fill, is more useful for changing the color of bars?
ggplot(penguins, aes(x = species)) +
  geom_bar(color = "red")

ggplot(penguins, aes(x = species)) +
  geom_bar(fill = "red")
# El segundo dice fill, lo que hace que se rellene la barra del color, el primero solo cambia el borde de color


# 3. What does the bins argument in geom_histogram() do?
?geom_histogram
# Indica en cuantos intervalos se van a dividir los valores de la variable y cuantas observaciones va a haber en cada uno
  
# 4. Make a histogram of the carat variable in the diamonds dataset that is available when you load the tidyverse package. Experiment with different binwidths. What binwidth reveals the most interesting patterns?

ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.1)

ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.5)

ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.05)


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



# Exercises:

# 1.The mpg data frame that is bundled with the ggplot2 package contains 234 observations collected by the US Environmental Protection Agency on 38 car models. Which variables in mpg are categorical? Which variables are numerical? (Hint: Type ?mpg to read the documentation for the dataset.) How can you see this information when you run mpg?
?mpg
# Categorical: manufacture; model; trans; drv; fl; class
# Numerical: displ; year; cyl; cty; hwy

# 2. Make a scatterplot of hwy vs. displ using the mpg data frame. Next, map a third, numerical variable to color, then size, then both color and size, then shape. How do these aesthetics behave differently for categorical vs. numerical variables?
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, color = cyl)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, size = cyl)) +
  geom_point()

ggplot(mpg, aes(
  x = displ,
  y = hwy,
  color = cyl,
  size = cyl
)) +
  geom_point()

ggplot(mpg, aes(
  x = displ,
  y = hwy,
  shape = cyl
)) +
  geom_point()

# Con este ultimo sale un error, porque cyl es una variable continua y el comando shape() necesita una variable categorica o discreta para funcionar
ggplot(mpg, aes(x = displ, y = hwy, shape = class)) +
  geom_point()
# Probamos con una categorica como class y vemos que funciona

# 3. In the scatterplot of hwy vs. displ, what happens if you map a third variable to linewidth?
ggplot(mpg, aes(x = displ, y = hwy, linewidth = cyl)) +
  geom_point()
# Mapear una variable a linewidth no cambia visualmente los puntos en geom_point(), porque linewidth se usa principalmente para las geometrías de líneas.

# 4. What happens if you map the same variable to multiple aesthetics?
# Vamos a poder identificar mejor las variables
ggplot(penguins, aes(
  x = flipper_length_mm,
  y = body_mass_g,
  color = species,
  shape = species
)) +
  geom_point()
# En el ejemplo vemos que le asignamos form ay color a las especies para distinguirlas mejor

# 5. Make a scatterplot of bill_depth_mm vs. bill_length_mm and color the points by species. What does adding coloring by species reveal about the relationship between these two variables? What about faceting by species?
ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point()
# Podemos ver la relacion entre el largo y l aprofundidad del pico segun la especie
# El faceting nos va a devolver un grafico para cada especie:
ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point() +
  facet_wrap(~species)
# Ahora la relacion se ve mas clara porque tenemos 3 graficos distintos.

# 6. Why does the following yield two separate legends? How would you fix it to combine the two legends?

ggplot(
  data = penguins,
  mapping = aes(
    x = bill_length_mm, y = bill_depth_mm, 
    color = species, shape = species
  )
) +
  geom_point() +
  labs(color = "Species")
# Esto pasa porque en labs solo le pusimos el nombre a la legend color. Si le agregamos la de shape, va a identificar que es la misma en ambos casos y combinarla
ggplot(
  data = penguins,
  mapping = aes(
    x = bill_length_mm, 
    y = bill_depth_mm, 
    color = species, 
    shape = species
  )
) +
  geom_point() +
  labs(color = "Species", shape = "Species")


# 7. Create the two following stacked bar plots. Which question can you answer with the first one? Which question can you answer with the second one?

ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")
ggplot(penguins, aes(x = species, fill = island)) +
  geom_bar(position = "fill")

# Con el primer grafico vemos las especies en cada isla. Que porcentaje de cada especie esta en cada isla.
# Con el segundo vemos las islas en las que esta cada especie. De una especie en particular, que porcentaje vive en cada isla

# Saving your plots
# Una vez que hayas creado un gráfico, es posible que quieras sacarlo de R guardándolo como una imagen que puedas utilizar en otro lugar. Esa es la función de ggsave(), que guarda en el disco el gráfico creado más recientemente:
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()
ggsave(filename = "penguin-plot.png")

# Exercices:

# 1. Run the following lines of code. Which of the two plots is saved as mpg-plot.png? Why?

ggplot(mpg, aes(x = class)) +
  geom_bar()
ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()
ggsave("mpg-plot.png")

# Se guarda el segundo, porque el comando ggsave(), sin especificar cual, guarda el ultimo grafico que se crea

# 2. What do you need to change in the code above to save the plot as a PDF instead of a PNG? How could you find out what types of image files would work in ggsave()?
# Hay que cambiar el .png por .pdf
