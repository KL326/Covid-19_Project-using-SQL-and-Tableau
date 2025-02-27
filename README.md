# 🦠 COVID-19 Data Analysis

Welcome to the **COVID-19 Data Analysis Project**! This project explores COVID-19 trends using SQL for data analysis and Tableau for visualization. 📊📌

---

## 🚀 Project Overview

This project analyzes COVID-19 data from the `CovidDeaths` and `CovidVaccinations` tables within the `PortfolioProject` schema. The goal is to extract insights related to infection rates, mortality rates, and vaccination progress across different locations and time periods.

---

## 🔧 Tools and Technologies

- **SQL**: Data extraction, transformation, and analysis.
- **Tableau**: Interactive visualizations for insights.
- **Microsoft SQL Server**: Database used for running queries.

---

## 🏗️ Steps in the Analysis

### 1️⃣ View Raw Data
- Preview the `CovidDeaths` and `CovidVaccinations` tables.
- Sort data by location and date for structured exploration.

### 2️⃣ Total Cases vs Total Deaths
- Calculate the **likelihood of death if infected**.
- Use `total_cases` and `total_deaths` to derive mortality rates.

### 3️⃣ Total Cases vs Population
- Determine the **percentage of the population infected**.
- Identify countries with the highest infection rates.

### 4️⃣ Death Count Analysis
- Find **countries with the highest total deaths**.
- Aggregate death counts at the continent level.
- Compute **global COVID-19 statistics**.

### 5️⃣ Vaccination Progress
- Use **Common Table Expressions (CTEs)** to track rolling vaccination numbers.
- Compute the percentage of the population vaccinated.

### 6️⃣ Temporary Table for Vaccination Analysis
- Store and manipulate vaccination data in a **temporary table**.
- Query vaccination rates for better insights.

### 7️⃣ Creating a View
- Create a **SQL view** (`PercentPopulationVaccinated`) for easier access to vaccination data.

---

## 📈 Tableau Dashboard

This project includes an interactive **Tableau dashboard** that visualizes:
- **Infection trends over time** 📉
- **Mortality rates per country and continent** ⚰️
- **Vaccination rollout progress** 💉

📌[Covid-19 Dashboard](https://public.tableau.com/app/profile/kristian.lama/viz/Book1_17339443191480/Dashboard1)


---

## 🌟 Key Insights

1. **Mortality Rate**: The likelihood of death varies significantly by country.
2. **Infection Trends**: Certain countries experienced rapid spikes in infection rates.
3. **Vaccination Impact**: A clear correlation between increased vaccinations and declining case counts.

---

## 🛠️ How to Use This Project

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/covid19-analysis.git
   ```
2. Run the SQL scripts in **Microsoft SQL Server** or any compatible SQL environment.
3. Load the processed data into **Tableau** for visualization.

---
