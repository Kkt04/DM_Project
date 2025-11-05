#!/bin/bash
# Run Script for Scientific Research Trends Analysis Project
# This script provides easy commands to run all project components

# Set project root
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PYTHONPATH="$PROJECT_ROOT:$PYTHONPATH"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Function to show help
show_help() {
    cat << EOF
Scientific Research Trends Analysis - Run Script

Usage: ./run.sh [command]

Commands:
  extract-sample     Extract 10K sample from raw arXiv dataset
  process-data       Process the sample data
  analyze            Run exploratory analysis
  dashboard          Start the web dashboard
  test               Run analysis with mock data (quick test)
  full               Run complete pipeline (extract → process → analyze → dashboard)
  help               Show this help message

Examples:
  ./run.sh extract-sample    # Extract 10,000 records
  ./run.sh analyze           # Run analysis
  ./run.sh dashboard         # Start web server
  ./run.sh test              # Quick test with mock data

EOF
}

# Check if we're in the right directory
if [ ! -f "$PROJECT_ROOT/requirements.txt" ]; then
    print_error "Error: Please run this script from the project root directory"
    exit 1
fi

# Main command handler
case "${1:-help}" in
    extract-sample)
        print_info "Extracting 10,000-record sample from raw arXiv dataset..."
        cd "$PROJECT_ROOT"
        python3 src/data_acquisition/create_sample_data.py --size 10000
        print_success "Sample extraction complete!"
        ;;
    
    process-data)
        print_info "Processing arXiv sample data..."
        cd "$PROJECT_ROOT"
        python3 src/data_acquisition/arxiv_dataset.py --sample
        print_success "Data processing complete!"
        ;;
    
    analyze)
        print_info "Running exploratory analysis..."
        cd "$PROJECT_ROOT"
        export MPLCONFIGDIR=/tmp/matplotlib
        python3 src/analysis/exploratory_analysis.py
        print_success "Analysis complete! Check data/processed/analysis_results/"
        ;;
    
    dashboard)
        print_info "Starting web dashboard on http://localhost:8080"
        print_warning "Press Ctrl+C to stop the server"
        cd "$PROJECT_ROOT"
        PYTHONPATH="$PROJECT_ROOT" gunicorn -w 4 -b 0.0.0.0:8080 "src.dashboard.app:app"
        ;;
    
    test)
        print_info "Running quick test with mock data..."
        cd "$PROJECT_ROOT"
        python3 src/analysis/exploratory_analysis.py
        print_success "Test complete!"
        ;;
    
    full)
        print_info "Running complete pipeline..."
        echo ""
        
        print_info "Step 1/4: Extracting sample..."
        python3 src/data_acquisition/create_sample_data.py --size 10000
        
        print_info "Step 2/4: Processing sample data..."
        python3 src/data_acquisition/arxiv_dataset.py --sample
        
        print_info "Step 3/4: Running analysis..."
        export MPLCONFIGDIR=/tmp/matplotlib
        python3 src/analysis/exploratory_analysis.py
        
        print_info "Step 4/4: Starting dashboard..."
        print_warning "Dashboard will start at http://localhost:8080"
        print_warning "Press Ctrl+C to stop"
        PYTHONPATH="$PROJECT_ROOT" gunicorn -w 4 -b 0.0.0.0:8080 "src.dashboard.app:app"
        ;;
    
    help|--help|-h)
        show_help
        ;;
    
    *)
        print_error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac

