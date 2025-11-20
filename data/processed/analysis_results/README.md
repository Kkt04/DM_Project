# Analysis Results Organization

This directory contains all analysis results organized by analysis type.

## Directory Structure

```
analysis_results/
├── data_quality/          # Data quality and EDA reports
├── statistical_tests/     # Statistical hypothesis testing results
├── predictive_models/     # Predictive modeling outputs
├── exploratory_analysis/  # Exploratory data analysis visualizations
└── focused_analysis/      # Focused analysis visualizations
```

## Contents by Category

### 📊 data_quality/
**Source:** `src/analysis/data_quality_report.py`

- `missing_values_analysis.png` - Missing value visualization
- `outlier_detection_boxplots.png` - Outlier detection box plots
- `data_distributions.png` - Distribution analysis (6 subplots)
- `correlation_heatmap.png` - Correlation matrix heatmap
- `data_quality_summary.txt` - Text summary report

### 📈 statistical_tests/
**Source:** `src/analysis/statistical_tests.py`

- `interdisciplinarity_anova_test.png` - ANOVA results with box plots and violin plots
- `correlation_analysis_tests.png` - Correlation scatter plots with regression lines

### 🤖 predictive_models/
**Source:** `src/analysis/predictive_models.py`

- `citation_prediction_performance.png` - Model comparison (predicted vs actual)
- `citation_prediction_feature_importance.png` - Top 15 feature importance
- `citation_prediction_results.csv` - Model metrics (RMSE, MAE, R²)
- `research_growth_forecast.png` - Growth forecasts for top 5 categories
- `research_growth_forecast.csv` - Forecast data (2026-2028)
- `emerging_keywords_classification.png` - Top 15 emerging keywords
- `emerging_keywords_analysis.csv` - Keyword growth analysis

### 🔍 exploratory_analysis/
**Source:** `src/analysis/exploratory_analysis.py`

- `collaboration_analysis.png` - Co-authorship distribution
- `interdisciplinarity_analysis.png` - Discipline count distribution
- `keyword_analysis.png` - Top 20 keywords bar chart
- `research_area_distribution.png` - Total publications by category
- `research_growth_data.csv` - Growth data CSV
- `research_growth_trend_top7.png` - Top 7 categories growth trend
- `category_cooccurrence_network.png` - Category co-occurrence heatmap

### 🎯 focused_analysis/
**Source:** `src/analysis/focused_analysis.py`

- `international_collaboration_heatmap.png` - Country × Field heatmap
- `research_growth_stacked.png` - Stacked area chart showing field growth

## Usage

All analysis scripts automatically save to their respective subdirectories. No manual organization needed.

## Regenerating Results

To regenerate all results:

```bash
# Data Quality Report
python3 src/analysis/data_quality_report.py

# Statistical Tests
python3 src/analysis/statistical_tests.py

# Predictive Models
python3 src/analysis/predictive_models.py

# Exploratory Analysis
python3 src/analysis/exploratory_analysis.py

# Focused Analysis
python3 src/analysis/focused_analysis.py
```

## Notes

- All results are generated from the 10K sample dataset
- Visualizations are saved as PNG files (300 DPI)
- CSV files contain raw data for further analysis
- All paths are relative to project root

