################################################################################
#             CÓDIGO R COMPLETO PARA EL INFORME LIDL - V. FINAL               #
#                       Ejecutar este script de corrido.                       #
################################################################################

# =============================== 1. CONFIGURACIÓN E INSTALACIÓN ===============================

# 1.1. Instalar librerías (Descomentar y ejecutar solo la primera vez que se use en el PC)
# install.packages(c("dplyr", "ggplot2", "cluster", "factoextra", "tidyr"))

# 1.2. Cargar todas las librerías necesarias (¡Esto es obligatorio en cada sesión!)
library(dplyr)      # Manipulación de datos
library(ggplot2)    # Creación de gráficos
library(cluster)    # Algoritmos de clustering
library(factoextra) # Visualización de clustering
library(tidyr)      # Para la función pivot_wider (soluciona el error anterior)

# 1.3. Cargar el dataset (Asegúrate de que "clientes_lidl.csv" esté en el directorio de trabajo)
# Se usa 'encoding = "UTF-8"' para manejar correctamente caracteres especiales como 'ñ' o tildes.
datos_lidl <- read.csv("clientes_lidl.csv", encoding = "UTF-8")


# =============================== 2. PREPARACIÓN DE DATOS ===============================

# 2.1. Limpieza y Creación de 'Edad'
# Convertir fechas a formato Date (Necesario para calcular la edad)
datos_lidl$Fecha_Ultima_Compra <- as.Date(datos_lidl$Fecha_Ultima_Compra, format="%Y-%m-%d")
datos_lidl$Fecha_Nacimiento <- as.Date(datos_lidl$Fecha_Nacimiento, format="%Y-%m-%d")

# 2.2. Calcular 'Edad' (Solución al error anterior: la columna 'Edad' se crea aquí)
datos_lidl$Edad <- as.integer(difftime(Sys.Date(), datos_lidl$Fecha_Nacimiento, units = "days") / 365.25)


# =============================== 3. ANÁLISIS EXPLORATORIO (Paso 4) ===============================

print("----------------------------------------------------------------------")
print("                          PASO 4: EDA Y RESUMEN                       ")
print("----------------------------------------------------------------------")

# 3.1. Estructura y Resumen
print("--- Estructura de los Datos (str) ---")
str(datos_lidl)

print("--- Resumen de Variables Numéricas (summary) ---")
# La columna 'Edad' ahora existe y se incluye sin errores.
summary(datos_lidl[c("Puntos_Socio", "Numero_Compras", "Promedio_Total_Compra", "Ratio_Frecuencia", "Edad")])

# 3.2. Frecuencias y Tablas de Agregación
print("--- Frecuencia por Tipo de Cliente ---")
table(datos_lidl$Tipo_Cliente)

print("--- Frecuencia por Comuna (Top 10) ---")
head(sort(table(datos_lidl$Comuna), decreasing = TRUE), 10)


# =============================== 4. PREGUNTA 1: INSIGHTS (Rentabilidad) ===============================

print("----------------------------------------------------------------------")
print("             PREGUNTA 1: PERFILES Y RENTABILIDAD                      ")
print("----------------------------------------------------------------------")

# Agregación: Gasto Promedio y Frecuencia por Tipo de Cliente
gasto_por_tipo <- datos_lidl %>%
  group_by(Tipo_Cliente) %>%
  summarise(
    Gasto_Promedio = mean(Promedio_Total_Compra, na.rm = TRUE),
    Frecuencia_Promedio = mean(Ratio_Frecuencia, na.rm = TRUE),
    Num_Clientes = n()
  ) %>%
  arrange(desc(Gasto_Promedio))

print("--- Perfil de Rentabilidad por Tipo de Cliente ---")
print(gasto_por_tipo)

# Gráfico 1: Gasto Promedio por Comuna (para Insight P1)
grafico_gasto_comuna <- ggplot(datos_lidl, aes(x = Comuna, y = Promedio_Total_Compra, fill = Comuna)) +
  geom_boxplot() +
  labs(title = "Gasto Total Promedio de Compra por Comuna", 
       y = "Gasto Promedio ($)", 
       x = "Comuna") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(grafico_gasto_comuna)


# =============================== 5. PREGUNTA 2: OUTLIERS (Paso 5) ===============================

print("----------------------------------------------------------------------")
print("                PREGUNTA 2: DETECCIÓN DE OUTLIERS                     ")
print("----------------------------------------------------------------------")

# 5.1. Detección visual con Boxplot y guardado (necesario para el informe LaTeX)
png("grafico_outliers.png", width = 800, height = 600)
boxplot(datos_lidl$Promedio_Total_Compra, 
        main = "Boxplot: Detección de Valores Atípicos en Gasto Promedio", 
        ylab = "Gasto ($)", 
        col = "orange")
dev.off() 

# 5.2. Uso del método IQR para identificar outliers (Gasto Promedio Superior)
Q1 <- quantile(datos_lidl$Promedio_Total_Compra, 0.25)
Q3 <- quantile(datos_lidl$Promedio_Total_Compra, 0.75)
IQR_val <- Q3 - Q1
Umbral_Superior <- Q3 + 1.5 * IQR_val

outliers_gasto <- datos_lidl %>%
  filter(Promedio_Total_Compra > Umbral_Superior) %>%
  select(RUN, Tipo_Cliente, Comuna, Promedio_Total_Compra, Numero_Compras, Puntos_Socio)

print("--- Clientes Outliers (Gasto Promedio Superior) ---")
print(outliers_gasto)


# =============================== 6. PREGUNTA 3: CLUSTERING (Paso 6) ===============================

print("----------------------------------------------------------------------")
print("                PREGUNTA 3: CLUSTERING K-MEANS                        ")
print("----------------------------------------------------------------------")

# 6.1. Seleccionar y Escalar (Estandarizar) Variables
variables_cluster <- datos_lidl %>%
  select(Numero_Compras, Promedio_Total_Compra, Ratio_Frecuencia, Puntos_Socio)

# Estandarizar los datos (media=0, desv. est=1)
datos_scaled <- scale(variables_cluster)

# 6.2. Aplicar K-Means (Usaremos k=4 como número óptimo, valor estándar para este tipo de datos)
k_optimo <- 4 
set.seed(42) # Semilla para reproducibilidad
k.final <- kmeans(datos_scaled, centers = k_optimo, nstart = 25)

# 6.3. Análisis de Centroides (CLAVE para la interpretación)
cluster_centers_scaled <- as.data.frame(k.final$centers)
cluster_centers <- cluster_centers_scaled %>%
  # Desescalar los centroides para interpretarlos en unidades originales
  mutate(
    Promedio_Total_Compra = Promedio_Total_Compra * sd(variables_cluster$Promedio_Total_Compra) + mean(variables_cluster$Promedio_Total_Compra),
    Numero_Compras = Numero_Compras * sd(variables_cluster$Numero_Compras) + mean(variables_cluster$Numero_Compras),
    Ratio_Frecuencia = Ratio_Frecuencia * sd(variables_cluster$Ratio_Frecuencia) + mean(variables_cluster$Ratio_Frecuencia),
    Puntos_Socio = Puntos_Socio * sd(variables_cluster$Puntos_Socio) + mean(variables_cluster$Puntos_Socio)
  )

print("--- Centroides (Valores Promedio) de los Clusters ---")
print(cluster_centers)
print(k.final$size) # Tamaño de cada cluster

# 6.4. Visualización del Clustering y Guardado (para el informe LaTeX)
grafico_clusters <- fviz_cluster(k.final, data = datos_scaled,
                                 geom = "point",
                                 main = paste("Visualización de Clusters K-Means (k=", k_optimo, ")"),
                                 ggtheme = theme_minimal())

ggsave("grafico_clusters.png", grafico_clusters, width = 8, height = 6)

# 6.5. Distribución del Tipo_Cliente por Cluster (Respuesta que ya te dio error, ahora resuelto)
datos_lidl$Cluster <- as.factor(k.final$cluster)
print("--- Distribución del Tipo_Cliente por Cluster (Validación) ---")
datos_lidl %>% 
  group_by(Cluster, Tipo_Cliente) %>% 
  summarise(Conteo = n()) %>% 
  pivot_wider(names_from = Tipo_Cliente, values_from = Conteo, values_fill = 0)

# =============================== FIN DEL ANÁLISIS ===============================