
# Tarea 04 ----------------------------------------------------------------

# Data Transformation Capitulo 3
# https://r4ds.hadley.nz/data-transform.html


# Introducción ------------------------------------------------------------

library(nycflights13)
library(tidyverse)
flights
glimpse (flights)

# Todos los dpylr que vamos a usar tienen en comun estas 3 cosas:
# 1. El primer argumento siempre es un data frame.
# 2. Los argumentos siguientes generalmente describen sobre qué columnas operar, utilizando los nombres de las variables (sin comillas).
# 3. El resultado siempre es un nuevo data frame.

# Tambien vamos a usar el pipe: |>
# Basicamente es un despues "then"


# Rows (filas) ------------------------------------------------------------

## Filter ----

# podríamos encontrar todos los vuelos que salieron con más de 120 minutos (dos horas) de retraso:
flights |> 
  filter(dep_delay > 120)

# Además de > (mayor que), podemos usar:

# >= (**mayor o igual que**)
# < (**menor que**)
# <= (**menor o igual que**)
# == (**igual a**)
# != (**distinto de**)

# También podemos combinar condiciones con & o , para indicar “y” (comprobar que se cumplan ambas condiciones), o con | para indicar “o” (comprobar que se cumpla cualquiera de las dos condiciones):

# Por ejemplo: Vuelos que salienron el 1 de enero:
flights |> 
  filter(month == 1 & day == 1)

# Vuelos que salieron en enero o febrero:
flights |> 
  filter(month == 1 | month == 2)

# Podemos usar un shortcut cuando combinamos == y |: %in%
flights |> 
  filter(month %in% c(1, 2))
# Con esto vemos los vuelos que salieron ene enero y febrero con un comando distinto


# Con estos comandos, no se reemplaza la tabla original, solo nos muestra lo que le pedimos. Para modificar el resultado, tenemos que usar el operador de asignacion
jan1 <- flights |> 
  filter(month == 1 & day == 1)
jan1
# Así creamos una tabla nueva (jan1) que tiene solamente los vuelos del 1 de enero


# Usar = en lugar de == va a devolver un error
# Si usamos | como si estuviensemos hablando normalmente, no va a devolver un error, pero no va a ser la interpretacion que queremos.
# El | lo que hace es chequear la primera condicion y despues pasa a la segunda

## Arrange ----

# Cambia el orden de las filas segun el valor de las columnas
# Por ejemplo: ordenamos por momento de salida en 4 columnas, primero o saños mas antiguos; dentro de cada año, los meses; dentro de cada mes el día;
flights |> 
  arrange(year, month, day, dep_time)

# Podemos usar desc() adentro del arrange para ordenar de manera descendente
flights |> 
  arrange(desc(dep_delay))

# Con todo esto, solamente reordanamos, pero no filtramos

## Distinct ----


# Encuentra las filas unicas de un dataset
flights |> 
  distinct()

flights |> 
  distinct(origin, dest)
# Busca los pares únicos de destino y origen


# si queremos conservar las demás columnas al filtrar las filas únicas, podemos usar la opción .keep_all = TRUE.
flights |> 
  distinct(origin, dest, .keep_all = TRUE)

# EL distinct() lo que hace es encontrar el primer valor y descartar el resto
# Si en cambio queremos encontrar la cantidad de veces que aparece cada uno, es mejor reemplazar [distinct()] por [count()].
# Con el argumento sort = TRUE, podemos ordenarlos en orden descendente según la cantidad de apariciones.
flights |>
  count(origin, dest, sort = TRUE)

## Exercises ----

# 1. In a single pipeline for each condition, find all flights that meet the condition:
# Had an arrival delay of two or more hours
flights |>
  filter(arr_delay >= 120)
# Flew to Houston (IAH or HOU)
flights |>
  filter (dest == "IAH" | dest == "HOU")
# Were operated by United, American, or Delta
flights |>
  filter (carrier %in% c("UA", "AA", "DL" ))
# Departed in summer (July, August, and September)
flights |>
  filter (month %in% c(7,8,9))
# Arrived more than two hours late but didn’t leave late
flights |>
  filter (arr_delay >= 120, dep_delay <= 0)
# Were delayed by at least an hour, but made up over 30 minutes in flight
flights |>
  filter(dep_delay >= 60, dep_delay - arr_delay > 30)

   
# 2. Sort flights to find the flights with the longest departure delays. Find the flights that left earliest in the morning.
flights |>
  arrange (desc(dep_delay))
# Con eso los ordenamos de los que mas retraso tuvieron a los que menos

flights |> 
  arrange (dep_time)
# Con esto vemos los los que salieron mas temprano primero

# 3. Sort flights to find the fastest flights. (Hint: Try including a math calculation inside of your function.)
# Tenemos la variable air_time, qu enos dice el tiempo de vuelo
# Igual, con la consigna podemos hacer una formula matematica para encontrar las millas x hora:
flights |>
  arrange(desc(distance / (air_time / 60)))

# 4. Was there a flight on every day of 2013?
# Primero hacemos:
flights |>
  distinct(year, month, day)
# esto nos muestra combinaciones unicas de year + month + day
# Ahora si contamos las filas, debebria ser 365:
flights |>
  distinct(year, month, day) |>
  nrow()

# Podemos confirmar que hubo al menos un vuelo por dia en 2013


# 5. Which flights traveled the farthest distance? Which traveled the least distance?

# Ordenados de los que viajaron la mayor distancia.
flights |>
  arrange (desc(distance))

# Ordenados de los que viajaron menor distancia
flights |>
  arrange(distance)


# 6. Does it matter what order you used filter() and arrange() if you’re using both? Why/why not? Think about the results and how much work the functions would have to do.
# Si, imports oporque con el filter estamos dejando dilas de lado, las excluimos en el output, con el arrange solo las reordenamos.


# Columns -----------------------------------------------------------------

## Mutate ----

# para agregar nuevas columnas que se calculan a partir de las columnas existentes.
# Vamos a empezar con: 
# gain: cuánto tiempo recuperó en el aire un vuelo que había salido con retraso.
# speed: la velocidad en millas por hora.

flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60
  )


# Por defecto, las columnas se agregan a la derecha. Podemos usar:
# .before traerlas a la izquierda
flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .before = 1
  )

# El . indica que es n argumento de la funcion y no una nueva variable
# Tambien podemos usar .after para poner las columnas despues de una variable en especifico
flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .after = day
  )

# Tanto el .before como el .after pueden ser seguidos de una variable en particular


# Usando .keep, podemos controlar que variables queremos conservar
# Uno muy tipico es "used", que sirve para especificar que solo las columnas que se usaron/crearon durante el mutate se mantienen
flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours,
    .keep = "used"
  )

# Tal como pasaba con las filas, si no asignamos estos cambios, los vamos a ver reflejados solo en los comandos que mandamos, no en el dataset original


## Select ----

# permite seleccionar un subconjunto útil de variables, utilizando operaciones basadas en los nombres de las variables
# x nombre:
flights |> 
  select(year, month, day)

# todas las columnas entre year y day:
flights |> 
  select(year:day)

# todas las columnas excepto las que estan entre year y day:
flights |> 
  select(!year:day)

# todas las columnas que sean de tipo caracter:
flights |> 
  select(where(is.character))


# Podés renombrar variables al mismo tiempo que las seleccionás con [select()] utilizando =.
# El nuevo nombre aparece del lado izquierdo del =, y la variable original aparece del lado derecho:
flights |> 
  select(tail_num = tailnum)

## Rename ----
# Para renombrar solo algunas y mantener el resto. A la derecha del = va el nombre original
flights |> 
  rename(tail_num = tailnum)
# Con esto, vemos todas las columnas de la tabla y le cambiamos el nombre a la que queremos. si usasemos el select, le cambiamos el nombre y la seleccionamos tambien, es decir que solo vamos a ver esa columna en particular

## Relocate ----
# Sirve para mover variables de lugar dentro del dataset. Por default, las trae al ppio del dataset
flights |> 
  relocate(time_hour, air_time)

# con el .before y .after, podemos elegir donde moverlas dentro del dataset
flights |> 
  relocate(year:dep_time, .after = time_hour)
flights |> 
  relocate(starts_with("arr"), .before = dep_time)

## Excercises ----

# 1. Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?
# dep_delay deberia ser la diferencia de dep_time y sched_dep_time
flights |>
  select(dep_time, sched_dep_time, dep_delay)

# 2. Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.
# Podemos hacer un select directamente menscionando todas
# Podemos poner contains ("dep"), contains ("arr")

# 3. What happens if you specify the name of the same variable multiple times in a select() call?
# Lo pruebo para ver el rdo:
flights |>
  select(dep_time, dep_time, dep_delay)
# La repetida (dep_time) figuara un asola vez, no toma el duplicado

# 4. What does the any_of() function do? Why might it be helpful in conjunction with this vector?
variables <- c("year", "month", "day", "dep_delay", "arr_delay")
# any_of() Le dice a select(): "Seleccioná las columnas cuyos nombres están en este vector."
flights |>
  select(any_of(variables))


# 5. Does the result of running the following code surprise you? How do the select helpers deal with upper and lower case by default? How can you change that default?
flights |> 
  select(contains("TIME"))
# no distingue entre mayusculas y minusculas
# para cambiar este default:
flights |>
  select(contains("TIME", ignore.case = FALSE))
# ahora nos devuelve cero columnas, porque ninguna contine TIME


# 6. Rename air_time to air_time_min to indicate units of measurement and move it to the beginning of the data frame.
flights |>
  rename(air_time_min = air_time) |>
  relocate(air_time_min)

# 7. Why doesn’t the following work, and what does the error mean?

flights |> 
  select(tailnum) |> 
  arrange(arr_delay)
# da error porque primero seleccionamos la columna tailnum, excluyendo al resto. De esta forma, el arrange no va a funcionar.


# The Pipe ----------------------------------------------------------------

# Es muy util cuando queremos combinar varios de los verbos anteriores a la vez
# Por ejemplo: queremos encontrar los vuelos más rápidos al aeropuerto IAH de Houston:
flights |>
  filter(dest == "IAH") |> 
  mutate(speed = distance / air_time * 60) |> 
  select(year:day, dep_time, carrier, flight, speed) |> 
  arrange(desc(speed))

# otra forma es anidar:
arrange(
  select(
    mutate(
      filter(
        flights, 
        dest == "IAH"
      ),
      speed = distance / air_time * 60
    ),
    year:day, dep_time, carrier, flight, speed
  ),
  desc(speed)
)

# otra forma es crear varios subconjuntos:
flights1 <- filter(flights, dest == "IAH")
flights2 <- mutate(flights1, speed = distance / air_time * 60)
flights3 <- select(flights2, year:day, dep_time, carrier, flight, speed)
arrange(flights3, desc(speed))



# Groups ------------------------------------------------------------------

## Group by ----

# Para dividir el dataset en grupos que nos resulten relevantes
# no modifica los datos, pero al ppio de la salida que obtenemos nos indica como esta agrupado. Esto se mantiene en las operaciones siguinetes
flights |> 
  group_by(month)


## Summarize -----
# reduce el data frame a una sola fila por grupo
flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay)
  )
# Esto nos devuelve todos NA (missing values). Esto ocurre porque calcula el promedio teniendo en cuenta los missing values
# Para solucionar esto, vamos a usar la funcion mean() y le indicamos que ingnore los missin values con na.rm en TRUE
flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE)
  )    

# Si agregamos n(), vamos a ver la cantidad de filas que hay en cada grupo:
flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), 
    n = n()
  )


## The slice_function -----

# Son funciones que permiten extraer filas especificas dentro de cada grupo:
# df |> slice_head(n = 1) toma la primera fila de cada grupo.
# df |> slice_tail(n = 1) toma la última fila de cada grupo.
# df |> slice_min(x, n = 1) toma la fila con el valor más pequeño de la columna x.
# df |> slice_max(x, n = 1) toma la fila con el valor más grande de la columna x.
# df |> slice_sample(n = 1) toma una fila aleatoria.

# Podés variar n para seleccionar más de una fila. Como alternativa a n =, podés usar prop = 0.1 para seleccionar, por ejemplo, el 10% de las filas de cada grupo.

# Por ejemplo: los vuelos con mayoretraso al llegar a destino:
flights |> 
  group_by(dest) |> 
  slice_max(arr_delay, n = 1) |>
  relocate(dest)


## Agrupar multiples variables -----
# Por ejemplo. podemos crear un grupo por cada fecha:

daily <- flights |>  
  group_by(year, month, day)
daily


# Cuando resumís un tibble agrupado por más de una variable, cada resumen elimina el último grupo.

## Ungroup ----

# También puede que quieras eliminar el agrupamiento de un data frame sin usar summarize(). Podés hacerlo con ungroup().
daily |> 
  ungroup()

# Cuando resumís un data frame que no está agrupado:
daily |> 
  ungroup() |>
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), 
    flights = n()
  )
# Obtenés una sola fila, porque dplyr considera que todas las filas de un data frame no agrupado pertenecen a un único grupo.

## .by ----

# para agrupar dentro de una única operación:
flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE), 
    n = n(),
    .by = month
  )

# o multiples variables:
flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE), 
    n = n(),
    .by = c(origin, dest)
  )

# funciona con todos los verbos y tiene la ventaja de que no necesitás usar el argumento .groups para evitar el mensaje de agrupamiento, ni ungroup() cuando terminás.

## Exercises ----

# 1. Which carrier has the worst average delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about flights |> group_by(carrier, dest) |> summarize(n()))
flights |>
  group_by(carrier) |>
  summarize(avg_delay = mean(arr_delay, na.rm = TRUE)) |>
  arrange(desc(avg_delay))

# Primero agrupamos x aerolinea; despues hacemos el promedio de retraso de llegada para cada aerolinea dejando de lado los missing values; por ultimo reacomodamos de mayor a menor


# 2. Find the flights that are most delayed upon departure to each destination.
flights |>
  group_by(dest) |>
  slice_max(dep_delay)

# 3. How do delays vary over the course of the day? Illustrate your answer with a plot.
ggplot(flights, aes(x = dep_time, y = dep_delay)) +
  geom_point()

# 4. What happens if you supply a negative n to slice_min() and friends?
# excluye las n observaciones con los valores mínimos.


# 5. Explain what count() does in terms of the dplyr verbs you just learned. What does the sort argument to count() do?
# Count() es una forma abreviada de group_by y summarize (n = n()). Si agregamos sort = TRUE, los grupos con más observaciones aparecen primero.


# 6. Suppose we have the following tiny data frame:

df <- tibble(
  x = 1:5,
  y = c("a", "b", "a", "a", "b"),
  z = c("K", "K", "L", "L", "K")
)

df
# Write down what you think the output will look like, then check if you were correct, and describe what group_by() does.
# va a agrupar segun y
df |>
  group_by(y)

# Write down what you think the output will look like, then check if you were correct, and describe what arrange() does. Also, comment on how it’s different from the group_by() in part (a).
# va a cambiar el orden de y
df |>
  arrange(y)

# Write down what you think the output will look like, then check if you were correct, and describe what the pipeline does.
# va a crear el grupo "y" y despues hacer el promedio de x para cada grupo
df |>
  group_by(y) |>
  summarize(mean_x = mean(x))

# Write down what you think the output will look like, then check if you were correct, and describe what the pipeline does. Then, comment on what the message says.
# va a crear dos grupos: y;z. Despues va a hacer el promedio de x para cada grupo
df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))
# group_by(y, z) agrupa los datos según las combinaciones de y y z. Luego, summarize() calcula el promedio de x para cada grupo, por lo que el resultado tiene tres filas. Después de resumir, el resultado sigue agrupado por y, porque summarize() elimina el último nivel de agrupamiento, que en este caso era z.


# Write down what you think the output will look like, then check if you were correct, and describe what the pipeline does. How is the output different from the one in part (d)?
  
  df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x), .groups = "drop")
# La diferencia esta en que despues de hacer el summarize elimuna los grupos
  
# Write down what you think the outputs will look like, then check if you were correct, and describe what each pipeline does. How are the outputs of the two pipelines different?
  
  df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))
# summarize es un esumen de cada grupo
  
df |>
  group_by(y, z) |>
  mutate(mean_x = mean(x))
# mutate es calcular algo dentro de cada grupo, manteniendo todas las filas


# Resumen: ----------------------------------------------------------------



# | Función         | Qué hace                        |
#   | ------------- | ------------------------------- |
#   | `group_by()`  | Crea grupos                     |
#   | `summarize()` | Resume/reduce cada grupo        |
#   | `mutate()`    | Crea columnas sin reducir filas |
#   | `slice_max()` | Busca los valores máximos       |
#   | `slice_min()` | Busca los valores mínimos       |
#   | `count()`     | Cuenta observaciones por grupo  |
#   | `arrange()`   | Ordena filas                    |
  



# 19.2.4 Exercises: Keys --------------------------------------------------

# https://r4ds.hadley.nz/joins.html#exercises

# 1. We forgot to draw the relationship between weather and airports in Figure 19.1. What is the relationship and how should it appear in the diagram?
# Se conectan por el código de aeropuerto: weather$origin corresponde a airports$faa. Es una relación muchos-a-uno: muchas filas de weather (una por cada hora) apuntan a un mismo aeropuerto en airports.

# 2. weather only contains information for the three origin airports in NYC. If it contained weather records for all airports in the USA, what additional connection would it make to flights?
# Podriamos establecer otra conexión entre weather y flights$dest, permitiendo conocer las condiciones climáticas en el aeropuerto de destino al momento de la llegada del vuelo.
   
# 3. The year, month, day, hour, and origin variables almost form a compound key for weather, but there’s one hour that has duplicate observations. Can you figure out what’s special about that hour?
library(nycflights13)
library(tidyverse)

weather |> 
  count(year, month, day, hour, origin) |> 
  filter(n > 1)
# Se refiere al l3 de noviembre de 2013, a la 1am, en los tres aeropuertos de origen. Ese día terminó el horario de verano (Daylight Saving Time) en Estados Unidos, por lo que la hora 1am ocurrió dos veces (el reloj retrocedió de las 2am a la 1am), generando dos observaciones de clima con la misma clave year, month, day, hour, origin.
   
# 4. We know that some days of the year are special and fewer people than usual fly on them (e.g., Christmas eve and Christmas day). How might you represent that data as a data frame? What would be the primary key? How would it connect to the existing data frames?
special_days <- tibble(
  year = c(2013, 2013),
  month = c(12, 12),
  day = c(24, 25),
  holiday = c("Christmas Eve", "Christmas Day")
)

# 5. Draw a diagram illustrating the connections between the Batting, People, and Salaries data frames in the Lahman package. Draw another diagram that shows the relationship between People, Managers, AwardsManagers. How would you characterize the relationship between the Batting, Pitching, and Fielding data frames?
install.packages("Lahman")
library(Lahman)
Batting |> distinct(playerID, yearID, stint) |> nrow() == nrow(Batting)
People |> distinct(playerID) |> nrow() == nrow(People)

# son tablas paralelas: cada una describe un aspecto distinto (bateo, pitcheo, fildeo) del desempeño del mismo jugador en la misma temporada. La relación entre ellas es de tipo uno-a-uno sobre esa clave compartida, aunque un jugador puede aparecer en una, en varias, o en ninguna, según lo que haya jugado esa temporada.




# 19.3.4 Exercises Basic Joins --------------------------------------------

# 1. Find the 48 hours (over the course of the whole year) that have the worst delays. Cross-reference it with the weather data. Can you see any patterns?
worst_hours <- flights |>
  mutate(hour = sched_dep_time %/% 100) |>
  group_by(origin, year, month, day, hour) |>
  summarise(avg_delay = mean(dep_delay, na.rm = TRUE), n = n(), .groups = "drop") |>
  slice_max(avg_delay, n = 48)

worst_hours_weather <- worst_hours |>
  left_join(weather, by = c("origin", "year", "month", "day", "hour"))

worst_hours_weather |> select(origin, year, month, day, hour, avg_delay, temp, wind_speed, precip, visib)

# las horas suelen coincidir con condiciones climáticas adversas — baja visibilidad (visib), vientos fuertes (wind_speed) y/o precipitaciones (precip) elevadas. Esto sugiere que el mal clima es un factor determinante en los grandes atraso
   
# 2. Imagine you’ve found the top 10 most popular destinations using this code:
top_dest <- flights2 |>
  count(dest, sort = TRUE) |>
  head(10)
flights2 |> semi_join(top_dest, by = "dest")
# How can you find all flights to those destinations?
# con un semi_join(). Filtra flights2 quedándose solo con las filas cuyo dest aparece en top_dest, sin agregar columnas de la segunda tabla


# 3. Does every departing flight have corresponding weather data for that hour?
flights |>
  anti_join(weather, by = c("origin", "year", "month", "day", "hour"))
# vemos los vuelos que no tienen una observación de clima correspondiente para su hora y aeropuerto de origen
   
# 4. What do the tail numbers that don’t have a matching record in planes have in common? (Hint: one variable explains ~90% of the problems.)
flights |>
  anti_join(planes, by = "tailnum") |>
  count(carrier, sort = TRUE)
# La mayoria de los tailnum sin registro en planes son de AA
 
# 5. Add a column to planes that lists every carrier that has flown that plane. You might expect that there’s an implicit relationship between plane and airline, because each plane is flown by a single airline. Confirm or reject this hypothesis using the tools you’ve learned in previous chapters.
planes_carriers <- flights |>
  distinct(tailnum, carrier) |>
  group_by(tailnum) |>
  summarise(carriers = list(unique(carrier)), n_carriers = n_distinct(carrier))

# Aviones volados por más de una aerolínea:
planes_carriers |> filter(n_carriers > 1)

# Agregar la columna a planes:
planes |> left_join(planes_carriers, by = "tailnum")

# Se rechaza la hipótesis de que cada avión pertenece a una sola aerolínea: al agrupar por tailnum y contar carriers distintos, aparecen aviones que fueron operados por más de una aerolínea durante el periodo q analizamos
 
# 6. Add the latitude and the longitude of the origin and destination airport to flights. Is it easier to rename the columns before or after the join?
airports_sm <- airports |> select(faa, lat, lon)

flights |>
  left_join(airports_sm, by = c("origin" = "faa")) |>
  rename(origin_lat = lat, origin_lon = lon) |>
  left_join(airports_sm, by = c("dest" = "faa")) |>
  rename(dest_lat = lat, dest_lon = lon)
# si se renombraran antes habría que crear dos versiones distintas de la tabla auxiliar. Renombrando después de cada left_join, evitamos q haya nombres duplicados
   
# 7. Compute the average delay by destination, then join on the airports data frame so you can show the spatial distribution of delays. Here’s an easy way to draw a map of the United States:
airports |>
  semi_join(flights, join_by(faa == dest)) |>
  ggplot(aes(x = lon, y = lat)) +
  borders("state") +
  geom_point() +
  coord_quickmap()
1

avg_delay_dest <- flights |>
  group_by(dest) |>
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE), n = n())

avg_delay_dest |>
  inner_join(airports, by = c("dest" = "faa")) |>
  ggplot(aes(x = lon, y = lat, size = n, color = avg_delay)) +
  borders("state") +
  geom_point(alpha = 0.7) +
  coord_quickmap() +
  scale_color_viridis_c() +
  labs(title = "Atraso promedio de llegada por destino",
       color = "Delay (min)", size = "N° vuelos")

# You might want to use the size or color of the points to display the average delay for each airport.
 
# 8. What happened on June 13 2013? Draw a map of the delays, and then use Google to cross-reference with the weather.

june13 <- flights |>
  filter(year == 2013, month == 6, day == 13) |>
  group_by(dest) |>
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE), n = n()) |>
  inner_join(airports, by = c("dest" = "faa"))

june13 |>
  ggplot(aes(x = lon, y = lat, size = n, color = avg_delay)) +
  borders("state") +
  geom_point(alpha = 0.7) +
  coord_quickmap() +
  scale_color_viridis_c() +
  labs(title = "Atrasos del 13 de junio de 2013", color = "Delay (min)")

# Vemos atrasos fuertemente concentrados en aeropuertos del centro-este y sureste de EEUU.
# Se debe a que el 13 de Junio de 2013, la region de Medio Oeste y el valle del Ohio se vio afectada por tormentas eléctricas en línea, con vientos muy fuertes