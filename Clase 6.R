rm(list=ls())

install.packages(pacman)
require(pacman)

## usar la función p_load de pacman para instalar/llamar las librerías de la clase
p_load(tidyverse, # funciones para manipular/limpiar conjuntos de datos.
       rio, # función import/export: permite leer/escribir archivos desde diferentes formatos. 
       skimr, # función skim: describe un conjunto de datos
       janitor) # función tabyl: frecuencias relativas
library("tidyverse")


data(package="datasets")

df=as_tibble(x=women)
df

##Crear una variable con la estatura en centimetreos 
df$height_cm = df$height*2.54 # agregar nueva variable
df

df$height_m = df$height_cm/100
df

##Generar una variable con la relación weight/height_cm:
df = mutate(.data = df , weight_hcm = weight/height_cm, weight_hm = weight/height_m)
head(x=df, n=5)


##Generar variables usando condicionales 
##Mostrar mujeres de más de 1.80 con 1
df$height_180 = ifelse(test=df$height_cm>180 , yes=1 , no=0)
df

#Usando mutate 
df = mutate(.data=df , sobrepeso = ifelse(test=weight_hcm>=0.85 , yes=1 , no=0))
head(x=df, n=5)

##Generar una variable con categorías para la relación weight/height_cm.
df = mutate(df , category = case_when(weight_hcm>=0.85 ~ "pesado" ,
                                      weight_hcm>=0.8 & weight_hcm<0.85 ~ "promedio" ,
                                      weight_hcm<0.8 & weight_hcm>0.787~ "liviano",
                                      weight_hcm<=0.787 ~ "super_liviano"))
head(x=df, n=5)

##Convertir todas las variables en caracteres: No es muy útil 
df = mutate_all(.tbl=df , .funs = as.character)
str(df)

##Convertir algunas variables a numéricas 
df = mutate_at(.tbl=df , .vars = c("height","weight","height_cm","weight_hcm"),.funs = as.numeric)
glimpse(df)

##Convertir a numéricas solo las variables que son caracteres:
df2 = mutate_if(.tbl=df , .predicate = is.character,.funs = as.numeric)
glimpse(df2)

##Ordenar un objeto por los valores de una variable 
##Ordenar un df por órden alfabetico ascendetne 
df = arrange(.data=df , category)
head(df)
##Orden descentendte 
df = arrange(.data=df , category)
head(df)


##Remover filas y/o columnas 

#Seleccionar variables 
db = tibble(iris) %>% mutate(Species=as.character(Species))
db
##No usar la psocicion como en la siguiente linea 
db %>% select(c(1,3,5)) %>% head(n=3) 
##Seleccionar usando el nombre (usar esta)
db %>% select(Petal.Length , Petal.Width , Species) %>% head(n=3)

##Seleccionar variables usando partes del nombre 
#Nombre de variables que empiezan por (sepal)
db %>% select(starts_with("Sepal"),"Species") %>% head(n=3)
##Nombres de variable que contengan la palabra (Width)
db %>% select(contains("Width")) %>% head(n=3)

##Seleccionar variables usando un vector  
vars = c("Species","Sepal.Length","Petal.Width")
db %>% select(all_of(vars)) %>% head(n=3)

##Deseleccionar variables 
db %>% select(-Species) %>% head()

##Remover filas u observaciones (usamos la base de datos starwars)
df = tibble(starwars)
df
#Remover filas usando condicionales 
df %>% subset(height > 180) %>% head(n=5) # height mayor a 180
#Función de la librería dplyr
df %>% filter(mass > 100) %>% head(n=5) # Más de 100 libras

##Operador pipe %>%
#Sin usar pipe 
df = as_tibble(x = women)
df = mutate(.data = df , height_cm = height*2.54,
            weight_hcm = weight/height_cm)
df = arrange(.data=df , desc(height_cm))
head(x=df , n=5)
##Usando pipe (se lee como un y ahora, nos ahorra nombrar el objeto )
df = as_tibble(x = women) %>% 
  mutate(height_cm = height*2.54, weight_hcm = weight/height_cm) %>%
  arrange(desc(height_cm))
head(x=df , n=5)

##TASK USANDO PIPE
df = import("https://www.datos.gov.co/resource/epsv-yhtj.csv")%>%
  as_tibble()%>%
  select(-cod_ase_)%>%
  mutate(ifelse(is.na(estrato),1,estrato))

head(x=df , n=5)

