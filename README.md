# 🛒 Análisis de Clientes y Segmentación K-Means - Supermercado Lidl

## Introducción al Proyecto

Este repositorio contiene el análisis completo de datos de 500 clientes de un supermercado chileno, realizado como parte de un estudio de factibilidad para la posible adquisición por parte de la cadena internacional **Lidl**. El objetivo principal fue transformar los datos de comportamiento en inteligencia de negocio actionable mediante técnicas de análisis exploratorio, detección de outliers y clustering.

El informe final se desarrolló en **LaTeX**, y todo el análisis estadístico fue ejecutado en **RStudio**.

---

## 🛠️ Entregables y Estructura del Repositorio

| Archivo/Carpeta | Descripción |
| :--- | :--- |
| `Informe.tex` | Código fuente del informe final en \LaTeX, incluyendo todas las interpretaciones y la documentación metodológica. |
| `analisis_lidl.R` | Script completo en R, utilizado para la carga, limpieza, EDA y la ejecución del Clustering K-Means. |
| `clientes_lidl.csv` | Dataset original de 500 clientes utilizado para el análisis. |
| `grafico_outliers.png` | Visualización del Boxplot para la detección de clientes atípicos (Outliers). |
| `grafico_clusters.png` | Visualización del resultado de la segmentación K-Means ($k=4$). |
| `README.md` | Este archivo. |

---

## 📊 Metodología y Hallazgos Clave

El análisis responde a tres preguntas centrales, utilizando las siguientes técnicas:

### 1. Perfiles de Rentabilidad (EDA)
- **Método:** Tablas de agregación (`dplyr::summarise`) para comparar Gasto Promedio y Frecuencia por \texttt{Tipo\_Cliente}.
- **Hallazgo:** El cliente **Planificado** genera el mayor Gasto Promedio, siendo el más rentable a nivel de transacción.

### 2. Detección de Outliers (Paso 5)
- **Método:** Cálculo del \textbf{Rango Intercuartil (IQR)} en la variable \texttt{Promedio\_Total\_Compra}.
- **Hallazgo:** Se identificaron 6 \textbf{Clientes VIP} con un gasto promedio superior al umbral IQR, concentrados principalmente en comunas de altos ingresos (Lo Barnechea, Las Condes, Vitacura).

### 3. Segmentación K-Means (Paso 6)
- **Método:** \textbf{Clustering K-Means} con $k=4$, usando las variables \texttt{Numero\_Compras}, \texttt{Promedio\_Total\_Compra}, \texttt{Ratio\_Frecuencia} y \texttt{Puntos\_Socio}.
- **Perfiles Identificados:**
    1.  **Cluster 3 (VIP / Alto Gasto):** Gasto promedio más alto ($\approx \$879.000$). Foco estratégico.
    2.  **Cluster 2 (Frecuentes / Bajo Valor):** Mayor número de compras, menor gasto. Objetivo de cross-selling.
    3.  **Cluster 4 (Orientados a Puntos):** Alta acumulación de puntos de fidelidad.
    4.  **Cluster 1 (Ocasionales):** Perfil medio o equilibrado.

---

## ⚙️ Cómo Ejecutar el Análisis

Para reproducir este análisis en tu entorno local de RStudio:

1.  Asegúrate de tener instaladas las librerías: `dplyr`, `ggplot2`, `cluster`, `factoextra`, y `tidyr`.
2.  Coloca el archivo `clientes_lidl.csv` en el directorio de trabajo de RStudio.
3.  Ejecuta el script `analisis_lidl.R` completamente.
4.  El script generará las tablas de resultados en la consola y los gráficos \texttt{grafico\_outliers.png} y \texttt{grafico\_clusters.png} en la carpeta del proyecto.

---

**Equipo de Trabajo:**
    Jaime Herrera
    Benjamin Valenzuela
    Paulo Brito

**Carrera:** Ingeniería en Informática
**Institución:** Instituto Profesional INACAP - Sede Renca
