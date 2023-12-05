###### Directorios de trabajo
setwd("/Users/lio/Documents/GitHub/Intro_R_2023")  #Mac
setwd("c:/docs/mydir/Session01")  # Windows
getwd() #Donde estamos trabajando ahora?

# Comentarios
# comentario

# Paquetes
install.packages("tidyverse", dependencies=T)
install.packages("dplyr", dependencies=T)
library(tidyverse)
library(dplyr) 
update.packages() #actualiza todos los paquetes que tengas instalados

#### Objetos
## Recuerda que R es un lenguaje sensible a mayúsculas y minúsculas
(10 + 2) * 5
x <- (10 + 2) * 5  # <- es equivalente a =
x <- c(8,9,10,12,14,10,13,10,9)
x <- NA

mode(x) #El tipo de objeto
length(x) #La Longitud del objeto
ls(x)  # Lista objetos en el entorno
rm(x)  # Elimina objetos

### Operadores
+ #Sumar
- #Restar
* #Multiplicar
/ #Dividir
^ #Potencia 
< #Mayor Que
<= #Mayor o Igual Que
> #Menor que
>= #Menor o Igual que
== #Igual Que
!= #no es igual
x | y #Operador Logico OR
x & y #Operador Logico AND

## Ayuda (Google a todo)
?lm #Busqueda Simple
??lm #Busqueda Amplia 

# Generación de datos
1:10
seq(from=1, to=10, by=1)
seq(1, 10, 1)
seq(length=9, from=1, to=5)
seq(1, 3, length=7)
c(1, 2, 3, 4, 5)
rep(1, 30)
rep(1:3, 10)

#Relevamiento de rindes, (50 parcelas, media de 2,8 t/ha, sd=0,8)
rnorm(50,2.8,0.8) #n = observaciones, mean = media, sd = desviacion standart
#https://www.tutorialspoint.com/r/r_normal_distribution.htm

# Funciones (Agregar comentario a cada funcion)
x <- 1:20 #Creamos un Objeto
summary(x) #resumen
sum(x) #suma
prod(x) #multiplicacion
max(x) #maximos
min(x) #minimos
range(x) #rango
mean(x) #media
median(x) #mediana
sd(x) #desviacion stadart
var(x) #Varianza
log(x) #logaritmo
log10(x) #logartmo base 10

rev(x)
x[3] <- 100 #introducir 100 en el lugar 3
sort(x)
x[c(2, 3)] <- 111 #Introcir 111 en el lugar 2 y 3
unique(x) 
rev(sort(x)) #orden reverso
which(x == 100) #En que posicion esta el valor 100?

#### Tipos de objetos
## Vectores

peso <- c(60, 72, 57, 90, 95, 72) 
altura <- c(1.75, 1.80, 1.65, 1.90, 1.74, 1.91)
plot(altura, peso)
imc <- peso/altura^2

## Factor
x <- factor(c("alpha", "beta", "gamma", "alpha", "beta"))
levels(x) #Distintos Valores unicos que puede tomar un factor
levels(x)[levels(x)=="beta"] <- "dos" #cambiamos beta por dos
levels(x)[3] <- "tres"  #cambiamos el tercer nivel por tres
levels(x) <- c("uno", "dos", "tres") #cambiamos todos los niveles por el vector

## Matriz
X <- matrix(c(1, 2, 3, 11, 12, 13), nrow=2, ncol=3, byrow=TRUE, 
            dimnames=list(c("fila1", "fila2"), c("C.1", "C.2", "C.3")))
rownames(X) #nombre de filas
colnames(X) #nombre de columnas
nrow(X) #Numero de filas
ncol(X) #numero de columnas
dim(X) #dimensiones
t(X) #trasponer
C.4 <- c(100, 1000) #crear vector para 4ta columna 
X1 <- cbind(X, C.4) #Agregar 4ta columna a X
fila3 <- c(10, 100, 1000) #crear fila 3
X2 <- rbind(X, fila3) #agregar fila 3 a X

#Donde se fue la Columna 4?
fila3 <- c(10, 100, 1000, 10000) #crear fila 3
X3 <- rbind(X1, fila3) #agregar fila 3 a X

## Marco de datos (Data Frame)
d <- data.frame(alpha=1:3, beta=4:6, gamma=7:9)
names(d)[3] <- "tres"
d$tres <- NULL

# Reordenar marco de datos
data <- data.frame(id=1:3, peso=c(20, 27, 24), tamaño=c("pequeño", "grande", "mediano"))
data[c(1, 3, 2)]
data[c("tamaño", "id", "peso")]

## Lista (grupos de cualquier tipo de objeto R)
lista.A <- list(data=data, otro.data=d, X, c(1, 2, 3, 4))

# Convertir objetos
as.numeric() #Para convertir a Numeros
data.mat <- as.matrix(data) #Para convertir en Matriz

# Indexación
iris #Datos incluidos en R

iris[3]
iris[c(1, 2)]
iris[1,] #Numero de fila
iris[,4] #Datos en Columna 1
iris[15,3] #Numero de fila y columna

#Creamos dos Vectores
Sepalos_largo <- iris$Sepal.Length #en cm
Petalos_largo <- iris$Petal.Length #en cm

#Selleccionar vectores
Sepalos_largo > 6
Sepalos_largo[Sepalos_largo > 6]
Petalos_largo[Petalos_largo > 5]
Petalos_largo[Sepalos_largo > 6 & Petalos_largo > 6]

# Gráficos
plot(Sepalos_largo)
plot(Petalos_largo)
plot(Sepalos_largo, type="p")
plot(Sepalos_largo, type="l")
plot(Sepalos_largo, type="b")
plot(y, xlim=c(40, 80), ylim=c(-20, 20))
plot(Sepalos_largo~Petalos_largo, main="Iris", xlab="Sepalos (cm)", ylab="Petalos (cm)")
plot(rnorm(50,2.8,0.8))
hist(rnorm(50,2.8,0.8))

#Paquete tidyverse

# Instalar y cargar tidyverse
install.packages("tidyverse")
library(tidyverse)

# Crear un data frame de ejemplo
data <- data.frame(
  ID = c(1, 2, 3, 4, 5),
  Nombre = c("Juan", "María", "Carlos", "Ana", "Pedro"),
  Edad = c(25, 30, 22, 28, 35)
)

# Filtrar personas mayores de 25 años y seleccionar solo las columnas de ID y Nombre
resultado <- data %>%
  filter(Edad > 25) %>%
  select(ID, Nombre)

# Imprimir el resultado
print(resultado)


#### Leer y escribir datos
## La separación decimal en R es . y no ,
Ingreso <- read.csv("Datos/IngresoPromPoblacion_py.csv")
Ingreso <- read.table("Datos/IngresoPromPoblacion_py.csv", header=T,
                    na.strings = "4/", sep= ";", check.names = FALSE)

##Revisar Datos
head(Ingreso) #Primeros datos
tail(Ingreso) #Ultimos Datos
dim(Ingreso) #Tamaño 
names(Ingreso) #Nombre de Columnas
summary(Ingreso) #Sumario de Datos 

#Departamento con mayor ingreso promedio?

#Cambiar a datos largos
dato_largo <- Ingreso %>%
  gather(key = "year", value = "Cantidad", -Departamento) %>%
  mutate(year = as.integer(year))

#Datos en Millones de Guaranies

#Limpiar Datos
dato_largo$Departamento <- str_trim(dato_largo$Departamento)  # Recortar espacios en blanco
dato_largo$Departamento <- str_replace(dato_largo$Departamento, ' ', '_')  # Reemplazar ciertos valores
any(is.na(dato_largo))  # Verificar valores faltantes (NAs)
dato_largo[is.na(dato_largo)] <- 0  # Reemplazar NAs con 0s

#Seleccionar Solo datos de Itapua
dato_largo_itapua <- dato_largo[dato_largo$Departamento == "Itapua", ]
Ingreso_Promedio_itapua <-  dato_largo_itapua$Cantidad

#Seleccionar Solo datos de Itapua
dato_largo_Boqueron <- dato_largo[dato_largo$Departamento == "Boqueron", ]
Ingreso_Promedio_Boqueron <-  dato_largo_Boqueron$Cantidad

# Agrupar los datos por departamento y encontrar el departamento con el mayor ingreso promedio
Mayor_Departamento <- dato_largo %>%
  group_by(Departamento) %>%
  summarize(Cantidad_total = mean(Cantidad, na.rm = TRUE)) %>%
  slice(which.max(Cantidad_total)) %>%
  ungroup()

#Departamentos con ingresos mayor a 2.5
resultados <- dato_largo %>%
  filter(Cantidad > 2.5) %>%
  select(Departamento, year, Cantidad)


