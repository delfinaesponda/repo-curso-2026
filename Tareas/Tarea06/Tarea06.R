
# Tarea 06 ----------------------------------------------------------------

# install.packages(c("edgar", "textdata"))
library(tidytext)
library(tidyverse)
library(edgar)
library(textdata)

# Empresa YPF; CIK 904851
?getFilings

ypf <- getFilings(cik.no = 904851,
           form.type = "20-F",
           filing.year = 2026,
           quarter = 1,
           useragent = "Delfina Esponda delfinaesponda@gmail.com",
           downl.permit = "y")

ypf
ruta_ypf <- list.files("edgar_Filings", recursive = TRUE, full.names = TRUE)
ruta_ypf
texto_ypf <- readLines("edgar_Filings/Form 20-F/904851/904851_20-F_2026-03-26_0001193125-26-126363.txt",
          warn = FALSE)
length(texto_ypf)
head(texto_ypf, 40)

# buscamos en las líneas donde aparece </DOCUMENT>
fin_docs <- which(str_detect(texto_ypf, "</DOCUMENT>"))
fin_docs

# recortamos el 20-F:

doc_ypf <- texto_ypf[1:fin_docs[1]]
doc_ypf <- paste(doc_ypf, collapse = " ")
doc_ypf <- doc_ypf |>
  str_remove("(?i)<ix:header>.*?</ix:header>") |>   # saca el bloque XBRL oculto
  str_replace_all("<[^>]+>", " ") |>
  str_replace_all("&#160;|&nbsp;|&#[0-9]+;", " ") |>
  str_squish()
str_sub(doc_ypf, 20000, 21000)


# más empresas: YPF, Pampa, Galicia, Telecom
ciks <- c(904851, 1469395, 1114700, 932470)   

getFilings(cik.no = ciks,
           form.type = "20-F",
           filing.year = 2026,
           quarter = 1:2,   # algunas presentan en abril
           useragent = "Delfina Esponda delfinaesponda@gmail.com",
           downl.permit = "y")

# función de limpieza
limpiar_20f <- function(ruta) {
  lineas <- readLines(ruta, warn = FALSE)
  fin <- which(str_detect(lineas, "</DOCUMENT>"))[1]
  lineas[1:fin] |>
    paste(collapse = " ") |>
    str_remove("(?i)<ix:header>.*?</ix:header>") |>
    str_replace_all("<[^>]+>", " ") |>
    str_replace_all("&#160;|&nbsp;|&#[0-9]+;", " ") |>
    str_squish()
}

# aplicarla a los 4 reportes
rutas <- list.files("edgar_Filings", recursive = TRUE, full.names = TRUE)

reportes <- tibble(ruta = rutas) |>
  mutate(cik = str_extract(basename(ruta), "^[0-9]+"),
         empresa = case_when(cik == "904851"  ~ "YPF",
                             cik == "1469395" ~ "Pampa",
                             cik == "1114700" ~ "Galicia",
                             cik == "932470"  ~ "Telecom"),
         texto = map_chr(ruta, limpiar_20f))
reportes |> mutate(largo = nchar(texto)) |> select(empresa, largo)


# las 4 tienen aprox un millon de caracteres, lo que las hace comparables

# incidencia de palabras clave
# como varias palabras clave son una combinacion de dos palabras, en vez de tokenizar, contamos directo en el text con str_count().
# como los reportes tienen largos distintos, normalizamos x cada 10.000 palabras para poder comparar

palabras_clave <- c("inflation", "devaluation", "exchange controls", "default",
                    "restructuring", "imf", "capital controls", "price controls",
                    "country risk", "embi")

incidencia <- reportes |>
  mutate(texto = str_to_lower(texto),
         n_palabras = str_count(texto, "\\S+")) |>
  select(empresa, texto, n_palabras) |>
  crossing(palabra = palabras_clave) |>
  mutate(n = str_count(texto, paste0("\\b", palabra, "\\b")),
         por_10mil = n / n_palabras * 10000) |>
  select(-texto)

# str_to_lower() pasa todo a minúsculas, así “Inflation” e “inflation” cuentan igual.
# str_count(texto, "\\S+") cuenta las palabras totales.
# crossing() arma todas las combinaciones empresa × palabra (4 × 10 = 40 filas).
# \\b es “borde de palabra”: evita que “imf” cuente dentro de otra palabra.


# tabla acomodada:
incidencia |>
  select(empresa, palabra, n) |>
  pivot_wider(names_from = empresa, values_from = n)

# graficamente:
ggplot(incidencia, aes(x = por_10mil, y = reorder(palabra, por_10mil), fill = empresa)) +
  geom_col(position = "dodge") +
  labs(title = "Incidencia de palabras clave en los 20-F 2025",
       x = "Menciones cada 10.000 palabras", y = NULL)
ggsave("Tareas/Tarea06/tarea06_incidencia.png", width = 8, height = 6)

# La palabra más nombrada en los 4 reportes es "inflation"
# "default" aparece mucho en Galicia
# "devaluation" aparece más en Telecom que en el resto
# "excehange controls" en Pamapa


# TF-IDF:
tfidf <- reportes |>
  select(empresa, texto) |>
  unnest_tokens(word, texto) |>
  filter(!str_detect(word, "[0-9]")) |>   # saca números
  filter(!word %in% c("galicia", "galicia's", "financiero", "ggal", "telecom",
                      "pampa", "ypf", "anonima", "sociedad", "cont")) |>
  count(empresa, word) |>
  bind_tf_idf(word, empresa, n) |>
  arrange(desc(tf_idf))

tfidf |>
  group_by(empresa) |>
  slice_max(tf_idf, n = 10) |>
  ggplot(aes(x = tf_idf, y = reorder_within(word, tf_idf, empresa), fill = empresa)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~empresa, scales = "free") +
  scale_y_reordered() +
  labs(title = "Palabras más distintivas por empresa (TF-IDF)", x = "tf-idf", y = NULL)
ggsave("Tareas/Tarea06/tarea06_tfidf.png", width = 9, height = 7)

# Galicia: naranja; hsbc; fima: inviu. Estas son todas subsidiarias de Galicia.
# Pampa: cammesa (mayorista); generators; transener.
# Telecom: arpu (metrica, ingreso prom x usuario); mobile; sistemas; television.
# YPF: refinery; downstream; midstream; lng (proyecto de gas natural licuado)

# sentimiento con Loughran-McDonald
# install.packages("SentimentAnalysis")
library(SentimentAnalysis)

# Diccionario Loughran-McDonald (textdata no lo pudo descargar, se usa el de SentimentAnalysis)
loughran <- bind_rows(
  tibble(word = DictionaryLM$negative,    sentiment = "negative"),
  tibble(word = DictionaryLM$positive,    sentiment = "positive"),
  tibble(word = DictionaryLM$uncertainty, sentiment = "uncertainty")
)
sentimiento <- reportes |>
  select(empresa, texto) |>
  unnest_tokens(word, texto) |>
  inner_join(loughran, by = "word", relationship = "many-to-many") |>
  count(empresa, sentiment) |>
  group_by(empresa) |>
  mutate(prop = n / sum(n))

ggplot(sentimiento, aes(x = prop, y = sentiment, fill = empresa)) +
  geom_col(position = "dodge") +
  labs(title = "Sentimiento en los 20-F (diccionario Loughran-McDonald)",
       x = "Proporción de palabras con sentimiento", y = NULL)
ggsave("Tareas/Tarea06/tarea06_sentimiento.png", width = 10, height = 6)


# En los 4 reportes domina el sentimiento negativo, mayormente en Pampa.
# la incertidumbre es bastante alta y muy similar en los 4 reportes.

# podemos ver que palabras pesan más en cada categoría:
reportes |>
  select(empresa, texto) |>
  unnest_tokens(word, texto) |>
  inner_join(loughran, by = "word", relationship = "many-to-many") |>
  count(sentiment, word, sort = TRUE) |>
  group_by(sentiment) |>
  slice_max(n, n = 10)

