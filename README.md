# 🛒 Análisis de Clientes y Segmentación K-Means - Supermercado Lidl

## Introducción al Proyecto

Este repositorio contiene el análisis completo de datos de 500 clientes de un supermercado chileno, realizado como parte de un estudio de factibilidad para la posible adquisición por parte de la cadena internacional **Lidl**. El objetivo principal fue transformar los datos de comportamiento en inteligencia de negocio actionable mediante técnicas de análisis exploratorio, detección de outliers y clustering.

El informe final se desarrolló en **LaTeX**, y todo el análisis estadístico fue ejecutado en **RStudio**.

---

## 🛠️ Entregables y Estructura del Repositorio

| Archivo/Carpeta | Descripción |
| :--- | :--- |
| `Informe.tex` | Código fuente del informe final en LaTeX, incluyendo todas las interpretaciones y la documentación metodológica. |
| `analisis_lidl.R` | Script completo en R, utilizado para la carga, limpieza, EDA y la ejecución del Clustering K-Means. |
| `clientes_lidl.csv` | Dataset original de 500 clientes utilizado para el análisis. |
| `grafico_outliers.png` | Visualización del Boxplot para la detección de clientes atípicos (Outliers). |
| `grafico_clusters.png` | Visualización del resultado de la segmentación K-Means ($k=4$). |
| `README.md` | Este archivo. |

---

## 📊 Metodología y Hallazgos Clave

El análisis responde a tres preguntas centrales, utilizando las siguientes técnicas:

### 1. Perfiles de Rentabilidad (EDA)
- **Método:** Tablas de agregación (`dplyr::summarise`) para comparar Gasto Promedio y Frecuencia por `Tipo_Cliente`.
- **Hallazgo:** El cliente **Planificado** genera el mayor Gasto Promedio, siendo el más rentable a nivel de transacción.

### 2. Detección de Outliers (Paso 5)
- **Método:** Cálculo del **Rango Intercuartil (IQR)** en la variable `Promedio_Total_Compra`.
- **Hallazgo:** Se identificaron 6 **Clientes VIP** con un gasto promedio superior al umbral IQR, concentrados principalmente en comunas de altos ingresos (Lo Barnechea, Las Condes, Vitacura).

### 3. Segmentación K-Means (Paso 6)
- **Método:** **Clustering K-Means** con $k=4$, usando las variables `Numero_Compras`, `Promedio_Total_Compra`, `Ratio_Frecuencia` y `Puntos_Socio`.

**Perfiles Identificados:**
- **Cluster 3 (VIP / Alto Gasto):** Gasto promedio más alto (~ \$879.000). Foco estratégico.
- **Cluster 2 (Frecuentes / Bajo Valor):** Mayor número de compras, menor gasto. Objetivo de cross-selling.
- **Cluster 4 (Orientados a Puntos):** Alta acumulación de puntos de fidelidad.
- **Cluster 1 (Ocasionales):** Perfil medio o equilibrado.

---

## ⚙️ Cómo Ejecutar el Análisis

Para reproducir este análisis en tu entorno local de RStudio:

1.  Asegúrate de tener instaladas las librerías: `dplyr`, `ggplot2`, `cluster`, `factoextra`, y `tidyr`.
2.  Coloca el archivo `clientes_lidl.csv` en el directorio de trabajo de RStudio.
3.  Ejecuta el script `analisis_lidl.R` completamente.
4.  El script generará las tablas de resultados en la consola y los gráficos `grafico_outliers.png` y `grafico_clusters.png` en la carpeta del proyecto.

---

**Equipo de Trabajo:**
    *Jaime Herrera
    *Benjamin Valenzuela
    *Paulo Brito

**Carrera:** Ingeniería en Informática
**Institución:** Instituto Profesional INACAP - Sede Renca
