rm(list=ls())


# llamo librerias a utilizar ----------------------------------------------

library(tidyverse)
library(readr)
library(ggplot2)
library(scales)


`%notin%` <- Negate(`%in%`)


# levanto la tabla --------------------------------------------------------

trayectorias <- read_delim("DATA/2024 Trayectoria - agregada(in).csv", 
                           delim = ";", escape_double = FALSE, trim_ws = TRUE)



# Data transformacion -----------------------------------------------------


conurbano <- c(
  "ALMIRANTE BROWN", "AVELLANEDA", "BERAZATEGUI", "BERISSO", "ESCOBAR",
  "ESTEBAN ECHEVERRIA", "EZEIZA", "FLORENCIO VARELA", "GENERAL SAN MARTIN", "HURLINGHAM",
  "ITUZAINGO", "JOSE C. PAZ", "LA MATANZA", "LANUS", "LOMAS DE ZAMORA",
  "MALVINAS ARGENTINAS", "MERLO", "MORENO", "MORON", "QUILMES",
  "SAN FERNANDO", "SAN ISIDRO", "SAN MIGUEL", "TIGRE", "TRES DE FEBRERO",
  "VICENTE LOPEZ"
)

trayectorias_analisis <- trayectorias %>%
  gather(tipo,cantidad,5:ncol(.)) %>%
  separate(tipo,
           into = c("nombre", "codigo"),
           sep = "_(?=[0-9]+$)") %>%  ### para separar los años de escolaridad de los nombres de las variables
  mutate(Departamento_2=case_when(provincia=="Ciudad de Buenos Aires"~"CABA",
                                  Departamento %in% conurbano & provincia =="Buenos Aires" ~"CONURBANO",
                                  provincia=="Buenos Aires"& Departamento %notin% conurbano ~"Buenos Aires interior",
                                  TRUE~provincia),
         Region=case_when(provincia %in% c("Catamarca","Jujuy","La Rioja","Salta","Santiago del Estero","Tucumán")~"NOA",
                          provincia %in%  c("Mendoza","San Juan","San Luis")~ "Cuyo",
                          provincia %in% c("Chaco","Corrientes","Formosa","Misiones")~ "NEA",
                          provincia %in% c("Chubut","Santa Cruz","Tierra del Fuego","Neuquén","Río Negro")~"Patagónica",
                          Departamento_2 %in% c("Córdoba","Entre Ríos","La Pampa","Santa Fe","Buenos Aires interior")~"Pampeana",
                          Departamento_2 %in% c("CONURBANO","CABA")~"GBA")) %>% 
  relocate(Region) %>% 
  mutate(provincia = case_when(Region == "Pampeana" & provincia == "Buenos Aires" ~ "Buenos Aires Interior",
                               TRUE ~ provincia)) %>% 
  select(-c(Departamento_2))


# seleccion de variables y resumen ----------------------------------------

trayectorias_lista <- trayectorias_analisis %>% 
  group_by(Region,provincia,ambito,nombre,codigo) %>% 
  mutate(codigo=factor(codigo,levels = c(1:12,1314,20,"NA"))) %>% 
  summarise(cant=sum(cantidad,na.rm=TRUE)) %>% spread(codigo,cant) %>% 
  mutate(Diferenciacion=case_when(str_detect(nombre,"m_")~"Mujeres",
                                  TRUE ~"Total"),
         nombre=str_remove(nombre,"m_"))


# Analisis de los grados educativos ---------------------------------------


TABLA_GRADOS <- trayectorias_lista %>% 
  filter(!str_detect(nombre,"primaria|secundaria")) %>% 
  select(-(ncol(.)-1)) %>%  
  mutate(nombre=factor(nombre,levels =c("inicial","entrados","scp","ssp","ultimo",
                                        "promovidos","promovidos_ex","nopromo","regulares","otros",
                                        "primaria_egresados","secundaria_egresados") )) 



############## Calculo de la tasa de promovidos por area geografica , ambito y genero


TABLA_GRADOS_2 <- TABLA_GRADOS %>%
  filter(nombre %in% c("ultimo","promovidos","promovidos_ex","nopromo")) %>%
  select(Region,provincia,ambito,nombre,Diferenciacion,everything()) %>% 
  mutate(nombre=case_when(nombre=="promovidos_ex"~"promovidos",
                          TRUE ~ nombre)) %>% select(-ncol(.)) %>% 
  group_by(Region, provincia, ambito, nombre, Diferenciacion) %>%
  summarise(across(`1`:`1314`, sum, na.rm = TRUE),.groups = "drop") %>% 
  gather(grado,cantidad,6:ncol(.)) %>% spread(Diferenciacion,cantidad) %>% 
  mutate(Varones=Total-Mujeres) %>% gather(Sexo,cantidad,6:ncol(.)) %>% 
  spread(nombre,cantidad) %>% 
  mutate(Sexo=factor(Sexo,c("Mujeres","Varones","Total")),
         grado=factor(grado,c(1:12,1314)),
         Region=factor(Region,c("GBA","Pampeana","NOA","NEA","Cuyo","Patagónica")))

# Analisis de proporcion de promovidos y no promovidos por provincia ----------------------


PROP_GRADOS <- TABLA_GRADOS_2 %>%
  mutate(prop_nopromo = round(nopromo/ultimo,digits = 3) ,
         prop_promovidos =round(promovidos/ultimo,digits = 3))




# proporcion de promovidos y no promovidos por region -------------------------------------


TABLA_REGION <- TABLA_GRADOS_2 %>%
  group_by(Region, grado,Sexo) %>%
  summarise(across("nopromo":"ultimo", sum, na.rm = TRUE),.groups = "drop")

PROP_REGION <- TABLA_REGION %>%
  mutate(prop_nopromo = nopromo / ultimo,
         prop_promovidos = promovidos / ultimo) 



##### TASA DE NO ´PROMO SEGUN GRADO SEXO Y REGION####


grafico_1 <- PROP_REGION %>%
  filter(Sexo != "Total") %>%
  ggplot(
    aes(
      x = grado,
      y = prop_nopromo,
      fill = Sexo
    )
  ) +
  geom_col(
    position = position_dodge(width = 0.8),
    width = 0.7
  ) +
  geom_text(aes(label = round(prop_nopromo*100,1)),
            position = position_dodge(width = 0.9),
            angle = 90,
            size = 2.5,
            hjust = -0.1)+
  facet_wrap(
    ~ Region,
    ncol = 3
  ) +
  scale_fill_manual(
    values = c(
      "Mujeres" = "#E76F51",
      "Varones" = "#457B9D"
    )
  ) +
  scale_y_continuous(
    labels = percent_format(accuracy = 1),
    expand = expansion(mult = c(0, .13))
  ) +
  labs(
    title = "Tasa de no promoción por grado según sexo y región",
    subtitle = "Año 2024",
    x = "Grado",
    y = "Tasa de no promoción",
    fill = "Sexo"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(
      face = "bold",
      size = 15
    ),
    plot.subtitle = element_text(
      size = 11
    ),
    strip.text = element_text(
      face = "bold"
    ),
    legend.position = "top",
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(
      angle = 0,
      vjust = 0.5
    )
  )
print(grafico_1)
##### brechas de genero por no promocion ######

BRECHA <- PROP_REGION %>%
  filter(Sexo %in% c("Mujeres", "Varones")) %>%
  group_by(Region, grado, Sexo) %>%
  summarise(nopromo = sum(nopromo),
            ultimo = sum(ultimo),
            .groups = "drop") %>%
  mutate(prop_nopromo = nopromo / ultimo) %>%
  select(Region, grado, Sexo, prop_nopromo) %>%
  pivot_wider( names_from = Sexo,values_from = prop_nopromo) %>%
  mutate(brecha = Varones - Mujeres)



grafico_BRECHA_GENERO <- ggplot(
  BRECHA,
  aes(x = grado,y = brecha,fill = brecha > 0)) +
  geom_col(width = 0.7) +
  geom_text(aes(label = round(brecha*100,1)),
            position = position_dodge(width = 0.9),
            angle = 90,
            size = 2.5,
            hjust = -0.1)+
  facet_wrap(~ Region, ncol = 3) +
  scale_fill_manual(
    values = c(
      "TRUE" = "#457B9D",
      "FALSE" = "#E76F51"
    ),
    guide = "none"
  ) +
  scale_y_continuous(
    labels = scales::percent_format(accuracy = 1),
    expand = expansion(mult = c(0, .13))) +
  labs(
    title = "Brecha de no promoción entre varones y mujeres",
    subtitle = "Diferencia en puntos porcentuales por grado y región. Año 2024",
    x = "Grado",
    y = "Varones − Mujeres"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(
      face = "bold",
      size = 15
    ),
    plot.subtitle = element_text(
      size = 11
    ),
    strip.text = element_text(
      face = "bold"
    ),
    panel.grid.minor = element_blank()
  )

print(grafico_BRECHA_GENERO)


###################### tabla y graficos de fracaso x grado educativo año 2024####


TABLA_GRADOS_ambito <- TABLA_GRADOS %>%
  filter(nombre %in% c("inicial","entrados","ssp","nopromo")) %>%
  select(Region,provincia,ambito,nombre,Diferenciacion,everything(.)) %>% 
  mutate(nombre=case_when(nombre %in% c("inicial","entrados")~"Alumnos",
                          TRUE ~ "ssp_nopromo")) %>% select(-ncol(.)) %>% 
  group_by(Region, provincia, ambito, nombre, Diferenciacion) %>%
  summarise(across(`1`:`1314`, \(x) sum(x, na.rm = TRUE)),.groups = "drop") %>% 
  gather(grado,cantidad,6:ncol(.)) %>% spread(Diferenciacion,cantidad) %>% 
  mutate(Varones=Total-Mujeres) %>% gather(Sexo,cantidad,6:ncol(.)) %>% 
  spread(nombre,cantidad) %>% 
  mutate(Sexo=factor(Sexo,c("Mujeres","Varones","Total")),
         grado=factor(grado,c(1:12,1314)),
         Region=factor(Region,c("GBA","Pampeana","NOA","NEA","Cuyo","Patagónica")))


PROP_GRADOS_fracaso_region <- TABLA_GRADOS_ambito %>%
  group_by(Region, ambito, grado, Sexo) %>%
  summarise(Alumnos = sum(Alumnos, na.rm = TRUE),
            ssp_nopromo = sum(ssp_nopromo, na.rm = TRUE),
            .groups = "drop") %>%
  mutate(tasa_fracaso = ssp_nopromo / Alumnos)


PROP_GRADOS_fracaso_pais <- TABLA_GRADOS_ambito %>%
  group_by(ambito, grado, Sexo) %>%
  summarise(Alumnos = sum(Alumnos, na.rm = TRUE),
            ssp_nopromo = sum(ssp_nopromo, na.rm = TRUE),
            .groups = "drop") %>%
  mutate(tasa_fracaso = ssp_nopromo / Alumnos)



##### Grafico de la tasa de fracaso por region y ambito####
grafico_fracaso_region_ambito <- PROP_GRADOS_fracaso_region %>%
  filter(Sexo == "Total") %>%
  ggplot(
    aes(
      x = grado,
      y = tasa_fracaso,
      fill = ambito
    )
  ) +
  geom_col(
    position = position_dodge(width = 0.8),
    width = 0.7
  ) +
  geom_text(aes(label = round(tasa_fracaso*100,1)),
            position = position_dodge(width = 0.9),
            angle = 90,
            size = 2.5,
            hjust = -0.1)+
  facet_wrap(
    ~ Region,
    ncol = 3
  ) +
  scale_fill_manual(
    values = c(
      "Rural" = "#E76F51",
      "Urbano" = "#457B9D"
    )
  ) +
  scale_y_continuous(
    labels = percent_format(accuracy = 1),
    expand = expansion(mult = c(0, .13))
  ) +
  labs(
    title = "Tasa de fracaso según grado por región y ambito",
    subtitle = "Año 2024",
    x = "Grado",
    y = "Tasa de fracaso",
    fill = "Ambito"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(
      face = "bold",
      size = 15
    ),
    plot.subtitle = element_text(
      size = 11
    ),
    strip.text = element_text(
      face = "bold"
    ),
    legend.position = "top",
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(
      angle = 0,
      vjust = 0.5
    )
  )

print(grafico_fracaso_region_ambito)

###### grafico de la tasa de fracaso nivel pais por ambito(rural/urbano)#####

grafico_fracaso_pais <- PROP_GRADOS_fracaso_pais %>%
  filter(Sexo == "Total") %>%
  ggplot(
    aes(
      x = grado,
      y = tasa_fracaso,
      fill = ambito
    )
  ) +
  geom_col(
    position = position_dodge(width = 0.8),
    width = 0.7
  ) +
  geom_text(aes(label = round(tasa_fracaso*100,1)),
            position = position_dodge(width = 0.9),
            angle = 90,
            size = 2.5,
            hjust = -0.1)+
  scale_fill_manual(
    values = c(
      "Rural" = "#E76F51",
      "Urbano" = "#457B9D"
    )
  ) +
  scale_y_continuous(
    labels = percent_format(accuracy = 1),
    expand = expansion(mult = c(0, .10))
  ) +
  labs(
    title = "Tasa de fracaso según grado y ambito nivel pais",
    subtitle = "Año 2024",
    x = "Grado",
    y = "Tasa de fracaso",
    fill = "Ambito"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(
      face = "bold",
      size = 15
    ),
    plot.subtitle = element_text(
      size = 11
    ),
    strip.text = element_text(
      face = "bold"
    ),
    legend.position = "top",
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(
      angle = 0,
      vjust = 0.5
    )
  )

print(grafico_fracaso_pais)




# pdf("RESULTADOS/Graficos_hackaton.pdf", width = 18, height = 10)
# 
# print(grafico_1)
# print(grafico_BRECHA_GENERO)
# print(grafico_fracaso_region_ambito)
# 
# dev.off()


