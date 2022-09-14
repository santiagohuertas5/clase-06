## Eduard Martinez
## Update: 14-09-2022

## Instalemos y llamemos a tidyverse
browseURL("https://www.rstudio.com/resources/cheatsheets/")
install.packages("tidyverse")
library(tidyverse)

## llamar/instalar otras librerias de la clase: (use pacman)
print("Para esta clase vamos a necesitar las siguientes lbrerias: rio, skimr y janitor.")

##=== [2.] Adicionar variables a un conjunto de datos ===##

### **2.1 Conjuntos de datos disponibles en la memoria de R**
data(package="datasets")

### **2.2 Función `$`**
df = as_tibble(x = women)
df

##Crear una variable con la estatura en centímetros (1 pulgada = 2.54 centímetros):
df$height_cm = df$height*2.54 ## agregar nueva variable
df

### **2.3 mutate()**
## Generar una variable con la relación weight/height_cm:
df = mutate(.data = df , weight_hcm = weight/height_cm)
head(x=df, n=5)

### **2.4 Generar variables usando condicionales:**
## Generar una variable para las mujeres más con una relación weight/height_cm mayor a 0.8 y otra con las mujeres de más de 180 cm:
df$height_180 = ifelse(test=df$height_cm>180 , yes=1 , no=0)
head(x=df, n=5)

## mutate
df = mutate(.data=df , sobrepeso = ifelse(test=weight_hcm>=0.85 , yes=1 , no=0))
head(x=df, n=5)

## Generar una variable con categorías para la relación weight/height_cm.
df = mutate(df , category = case_when(weight_hcm>=0.85 ~ "pesado" ,
                                      weight_hcm>=0.8 & weight_hcm<0.85 ~ "promedio" ,
                                      weight_hcm<0.8 ~ "liviano"))
head(x=df, n=5)

### **2.5 Aplicar funciones a variables**

## Convertir todas las variables en caracteres:
df = mutate_all(.tbl=df , .funs = as.character)
str(df)

## Convertir solo algunas variables a numéricas:
df = mutate_at(.tbl=df , .vars = c("height","weight","height_cm","weight_hcm"),.funs = as.numeric)
glimpse(df)

## Convertir a numéricas solo las variables que son caracteres:
df2 = mutate_if(.tbl=df , .predicate = is.character,.funs = as.numeric)
glimpse(df2)

#### **Ordenar un objeto por os valores de una variable:**

## Ordenar un dataframe: alfabético ascendente
df = arrange(.data=df , category)
head(df)

## Ordenar un dataframe: alfabético descendente
df = arrange(.data=df , desc(category)) 
head(df)

## Ordenar un dataframe: numérico ascendente
df = arrange(.data=df , height_cm)
head(df)

## Ordenar un dataframe: numérico descendente
df = arrange(.data=df , desc(height_cm))
head(df)

##=== [3.] Remover filas y/o columnas ===##

### **3.1 Seleccionar variables**
## `iris` es un conjunto de datos de la librería `datasets`, que contiene las medidas en centímetros de la longitud y ancho del sépalo y largo y ancho del pétalo, respectivamente, para 50 flores de cada una de las 3 especies de iris:
db = tibble(iris) %>% mutate(Species=as.character(Species))
db

## La función `select()` permite seleccionar columnas de un dataframe o un tibble, usando el nombre o la posición de la variable en el conjunto de datos:
db %>% select(c(1,3,5)) %>% head(n=3) 
db %>% select(Petal.Length , Petal.Width , Species) %>% head(n=3)

#### **3.1.1 Seleccionar variables usando partes del nombre**
## Nombres de variable que empizan con (*Sepal*)
db %>% select(starts_with("Sepal")) %>% head(n=3)

## Nombres de variable que contengan la palabra (*Width*)
db %>% select(contains("Width")) %>% head(n=3)

#### **3.1.2 Seleccionar variables usando el tipo**
## Variables de tipo carácter:
db %>% select_if(is.character) %>% head(3)

## Variables de tipo numérico:
db %>% select_if(is.numeric) %>% head(3)

#### **3.1.3 Seleccionar variables usando un vector**
## Vector de caracteres
vars = c("Species","Sepal.Length","Petal.Width")
db %>% select(all_of(vars)) %>% head(n=3)

## Vector numérico:
nums = c(5,2,3)
db %>% select(all_of(nums)) %>% head(n=3)

#### **3.1.4 Deseleccionar variables**
db %>% select(-Species) %>% head()

### **3.2 Remover filas/observaciones**
df = tibble(starwars)
df

#### **3.2.1 Remover filas usando condicionales**

## La función `subset()` pertenece a una de las librerías base de `R`
df %>% subset(height > 180) %>% head(n=5) # height mayor a 180

## La función `filter()` de la librería `dplyr` :
df %>% filter(mass > 100) %>% head(n=5) # Más de 100 libras

## El nombre de la función `filter()` presenta coflictos con el nombre de la función `filter()` de la librería `stats` (base).
tidyverse_conflicts() # ver conflictos con los nombres de las funciones de tidyverse

##Una forma de solucionar este conflicto es usar `::` para llamar la función de librería `dplyr::filter()` o creando un objeto con la función a preferir:
filter = dplyr::filter # Tenga en cuenta que no se usa paréntesis.
df %>% filter(mass > 100) %>% head(n=5) # Más de 100 libras

##=== [4.] Operador pipe (%>%) ===##

## %>% es un operador que permite conectar funciones en R. 
## Se enfoca en la transformación que se le está haciendo al objeto y no en el objeto, permitiendo que el código sea más corto y fácil de leer. 

### Veamos un ejemplo:
df = as_tibble(x = women)
df = mutate(.data = df , height_cm = height*2.54,
                         weight_hcm = weight/height_cm)
df = arrange(.data=df , desc(height_cm))
head(x=df , n=5)

## una forma de hacerlo usando el operador pipe `%>%`:  
df = as_tibble(x = women) %>% 
     mutate(height_cm = height*2.54, weight_hcm = weight/height_cm) %>%
     arrange(desc(height_cm))
head(x=df , n=5)

### Veamos otro ejemplo:
print("Intente reescribir el siguiente código usando el operador `%>%`:")

df <- import("https://www.datos.gov.co/resource/epsv-yhtj.csv")
df <- as_tibble(df)
df <- select(df, -cod_ase_)
df <- mutate(df,ifelse(is.na(estrato),1,estrato))

