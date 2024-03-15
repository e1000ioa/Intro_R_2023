
library(tidyverse)

setwd("/Users/lio/Git/Intro_R_2023")

records <- read.csv("Datos/records.csv")

unique(recodrs$compiledRelease.buyer.name)

recordsS <- records %>%
  select(
"compiledRelease.tender.mainProcurementCategory",  
"compiledRelease.tender.procurementMethodDetails",   
"compiledRelease.tender.procuringEntity.name",  
"compiledRelease.buyer.name", 
"compiledRelease.planning.budget.description",                     
"compiledRelease.planning.budget.amount.currency",                
"compiledRelease.planning.budget.amount.amount",
"compiledRelease.tender.coveredBy") %>%
  filter(!is.na(compiledRelease.planning.budget.amount.amount)) 

#Cambiar Nombre
# Cambiar nombres de las columnas
records2 <- recordsS %>%
  rename(
    Tipo = compiledRelease.tender.mainProcurementCategory,
    Modo_Contratacion = compiledRelease.tender.procurementMethodDetails,
    Entidad_Pedido = compiledRelease.tender.procuringEntity.name,
    Entidad_Compradora = compiledRelease.buyer.name,
    Descripcion = compiledRelease.planning.budget.description,
    Divisa = compiledRelease.planning.budget.amount.currency,
    Cantidad = compiledRelease.planning.budget.amount.amount,
    Fondos = compiledRelease.tender.coveredBy
  ) %>%
  mutate(Cantidad_PYG = ifelse(Divisa == "PYG", Cantidad, Cantidad * 7350)) %>%
  mutate(Cantidad_USD = ifelse(Divisa == "USD", Cantidad, Cantidad / 7350)) %>%
  mutate(Fonacide = ifelse(Fondos == "USD", Cantidad, Cantidad / 7350)) %>%
  mutate(Fonacide = ifelse(grepl("fonacide", Fondos, ignore.case = TRUE), TRUE, FALSE))

#Ver datos de Hoheanu
Hoheanu <- records2 %>%
  filter(Entidad_Compradora == "Municipalidad de Hohenau") %>%
  summarize(Cantidad_Total = sum(Cantidad_USD, na.rm = TRUE))


# Summarize and add amounts for each category
Comprador <- records2 %>%
  group_by(Entidad_Compradora) %>%
  summarize(Cantidad_Total = sum(Cantidad_USD, na.rm = TRUE))


# Select ros where the "categoria" column contains "municiplaidad de"
Municipios <- records2 %>%
  filter(grepl("Municipalidad", Entidad_Compradora, ignore.case = TRUE))  %>%
  group_by(Entidad_Compradora) %>%
  summarize(Cantidad_Total = sum(Cantidad_USD, na.rm = TRUE))

# Seleccionar los 10 primeros municipios
top_10_municipios <- Municipios %>%
  top_n(10, wt = Cantidad_Total)

# Select rows where the "categoria" column contains "municiplaidad de"
Municipios_F <- records2 %>%
  filter(grepl("Municipalidad", Entidad_Compradora, ignore.case = TRUE))  %>%
  group_by(Entidad_Compradora,Fonacide) %>%
  summarize(Cantidad_Total = sum(Cantidad_USD, na.rm = TRUE)) %>%
  mutate(Porcentaje = Cantidad_Total / sum(Cantidad_Total) * 100)


# Select rows where the "categoria" column contains "municiplaidad de"
Fonacide <- Municipios_F %>%
  group_by(Fonacide) %>%
  summarize(Cantidad_Total = sum(Cantidad_Total, na.rm = TRUE))


# Supongamos que tienes un dataframe llamado df
Municipios_Itapua <- Municipios_F %>%
  filter(Entidad_Compradora %in% c("Municipalidad de Pirapó",
                                   "Municipalidad de Fram",
                                   "Municipalidad de Obligado",
                                   "Municipalidad de Carmen del Paraná",
                                   "Municipalidad de la Paz",
                                   "Municipalidad de Cárlos Antonio López",
                                   "Municipalidad de Hohenau"))

                                
# Crear gráfico de barras
ggplot(Municipios_Itapua, aes(x = Entidad_Compradora, y = Cantidad_Total / 1000, fill = Fonacide)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Cantidad Total en Milles de USD por Entidad Compradora",
       x = "Entidad Compradora",
       y = "Cantidad Total (Miles de USD)") +
  scale_y_continuous(labels = scales::comma) +  # Mostrar etiquetas en formato de miles
  theme_minimal()

#Una prueba de lo que podemos hacer con R
library(proxy)

  install.packages("proxy")

library(proxy)

  install.packages("stringdist")

library(stringdist)

  Des <- records2$Descripcion
  
  # Eliminar las palabras especificadas de la columna "texto"

    Des <- gsub("ADQUISICION DE ", "", Des, ignore.case = TRUE)
  
  dist_matrix <- stringdist::stringdistmatrix(Des, method = "jaccard")
  

umbral <- 0. # Puedes ajustar este umbral según tus necesidades
similares <- which(dist_matrix < umbral, arr.ind = TRUE)

distances <- 1 - dist_matrix  

# Perform hierarchical clustering
hc <- hclust(as.dist(distances), method = "complete")

# Cut the dendrogram to get clusters
cutree_result <- cutree(hc, k = 10)  # You can adjust the number of clusters (k)

# Attach cluster labels to your data
clustered_data <- data.frame(Des, cluster = cutree_result)

# Assuming cutree_result is a vector of cluster assignments
result_df <- cbind(records2, cluster = cutree_result)


# Scatter plot of the clusters
plot(clustered_data$cluster, 
     col = cutree_result, 
     pch = 19, main = "Clustered Data", 
     xlab = "Descriptions", ylab = "Cluster")

# Add legend
legend("topright", legend = unique(cutree_result), col = 1:max(cutree_result), pch = 19, title = "Cluster")

# Instalar y cargar la librería pROC si no está instalada
# install.packages("pROC")
library(pROC)

# Crear datos de ejemplo
set.seed(123)
datos <- data.frame(
  score = runif(100),  # Puedes reemplazar esto con las probabilidades de tu modelo
  clase = factor(sample(0:1, 100, replace = TRUE))
)

# Crear el objeto ROC
roc_obj <- roc(clustered_data$Des,clustered_data$cluster)

# Dibujar la curva ROC
plot(roc_obj, main = "Curva ROC", col = "blue", lwd = 2)

# Añadir área bajo la curva (AUC) al gráfico
text(0.8, 0.2, paste("AUC =", round(auc(roc_obj), 2)), col = "blue", cex = 1.2)

# Ajustar la leyenda
legend("bottomright", legend = paste("AUC =", round(auc(roc_obj), 2)), col = "blue", lwd = 2)


