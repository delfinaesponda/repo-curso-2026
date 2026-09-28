
# Tarea 05 ----------------------------------------------------------------

library(tidyverse)
library(tidytext)
library(topicmodels)
library(igraph)
library(ggraph)

url <- "https://gitlab.com/uploads/-/system/personal_snippet/4897254/d83847870c9577a22a20063379f91120/DATA-T9-mckinsey-mind-the-gap-articles-20251020.csv"
mckinsey <- read_csv(url)

glimpse(mckinsey)

# explorando el corpus:

mckinsey <- mckinsey %>% rename(id = ...1)

# rango de tiempo
range(mckinsey$date)

# buscamos todos los títulos, para ver el tema del corpus
mckinsey %>% select(id, title, date) %>% print(n = Inf)

# longitud de cada artículo (comparabilidad)
mckinsey <- mckinsey %>%
  mutate(n_words = str_count(article_text, "\\S+"))

summary(mckinsey$n_words)

# El corpus son 146 artículos de la newsletter "Mind the Gap" de McKinsey, desde 2022 a 2025, enfocada en la Gen Z.
# En cuanto a si son comparables, podemos ver que entre el primer y tercer cuartil van de 540 a 690 palabras, con una mediana de 611. Por lo tanto, son bastante similares en longitud.
# Hay algunos outliers.

# Vamos a tokenizar y ver tf-idf

tidy_mckinsey <- mckinsey %>%
  select(id, title, date, article_text) %>%
  unnest_tokens(word, article_text)

data(stop_words)
tidy_mckinsey <- tidy_mckinsey %>%
  anti_join(stop_words, by = "word") %>%
  filter(!str_detect(word, "^[0-9]+$"))

# palabras más frecuentes del corpus completo
tidy_mckinsey %>%
  count(word, sort = TRUE) %>%
  slice_max(n, n = 20)

# tf-idf por artículo
mckinsey_tfidf <- tidy_mckinsey %>%
  count(id, word, sort = TRUE) %>%
  bind_tf_idf(word, id, n)

mckinsey_tfidf %>%
  arrange(desc(tf_idf)) %>%
  slice_head(n = 20)

# Con las palabras mas ferecuentes del corpus completo, vemos que hay palabras que parecen acordes a los temas que tratan, mientras que hay otras que parecienran ser propias de la empresa de la newsletter (mckinsy; partner; client)
# Cuando hacemos tf-idf por artículo, vemos los temas más especifico spor artículo.


# Sentimineto => diccionario bing y afiinn

# sentimiento binario (bing)
bing <- get_sentiments("bing")

sentiment_bing <- tidy_mckinsey %>%
  inner_join(bing, by = "word") %>%
  count(id, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>%
  mutate(sentiment_score = positive - negative) %>%
  left_join(mckinsey %>% select(id, title, date), by = "id")

# los más negativos
sentiment_bing %>% arrange(sentiment_score) %>% slice_head(n = 5)       

# los más positivos
sentiment_bing %>% arrange(desc(sentiment_score)) %>% slice_head(n = 5) 

# sentimiento con graduación (afinn, -5 a +5)
afinn <- get_sentiments("afinn")

sentiment_afinn <- tidy_mckinsey %>%
  inner_join(afinn, by = "word") %>%
  group_by(id) %>%
  summarise(afinn_score = sum(value), .groups = "drop") %>%
  left_join(mckinsey %>% select(id, title, date), by = "id")

summary(sentiment_afinn$afinn_score)

# Con el diccionario bing, vemos que el corpus es más positivo que negativo. Los articulos mas negativos tratan sobre temas como salud mental, la incertidumbre de la "crisis del cuarto de vida", etc.
# Con el diccionario afinn, vemos que es coherente la tendencia positiva, mediana de 16 y media de 15,89, lo que tiene sentido con el tono optimista de contenido corporativo dirigido a la Gen Z.


# topic modeling con LDA, k=10 y k=15

# Hacemo un stopwords para sacar palabras que nos vana. generar "ruido" en los graficos
custom_stopwords <- tibble(word = c("gen", "zers", "mckinsey", "partner",
                                    "global", "percent", "it's", "it’s"))

tidy_mckinsey_clean <- tidy_mckinsey %>%
  anti_join(custom_stopwords, by = "word")

mckinsey_dtm2 <- tidy_mckinsey_clean %>%
  count(id, word) %>%
  cast_dtm(id, word, n)

set.seed(1234)
lda_k10 <- LDA(mckinsey_dtm2, k = 10, control = list(seed = 1234))
lda_k15 <- LDA(mckinsey_dtm2, k = 15, control = list(seed = 1234))

# top 10 términos por tópico, k=10
top_terms_k10 <- tidy(lda_k10, matrix = "beta") %>%
  group_by(topic) %>%
  slice_max(beta, n = 10) %>%
  ungroup()

top_terms_k10 %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free", ncol = 3) +
  coord_flip() +
  scale_x_reordered() +
  labs(title = "Términos por tópico (k = 10)", x = NULL, y = "beta")

# top 10 términos por tópico, k=15
top_terms_k15 <- tidy(lda_k15, matrix = "beta") %>%
  group_by(topic) %>%
  slice_max(beta, n = 10) %>%
  ungroup()

top_terms_k15 %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free", ncol = 3) +
  coord_flip() +
  scale_x_reordered() +
  labs(title = "Términos por tópico (k = 15)", x = NULL, y = "beta")

# k=10 vs k=15: con k=15 los topicos se subdividen mas (x ej, separa salud mental de salud fisica/wellness, o moda de belleza). k=10 muestra categorias mas amplias.
# k=15 captura mejor los distintos temas .

