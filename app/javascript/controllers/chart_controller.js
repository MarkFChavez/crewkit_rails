import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"

export default class extends Controller {
  static values = {
    labels: Array,
    present: Array,
    absent: Array,
    late: Array
  }

  connect() {
    Chart.register(...registerables)
    console.log('Chart controller connected')
    console.log('Labels:', this.labelsValue)
    console.log('Present:', this.presentValue)
    console.log('Absent:', this.absentValue)
    console.log('Late:', this.lateValue)
    this.initializeChart()
  }

  initializeChart() {
    const ctx = this.element.getContext('2d')
    console.log('Initializing chart with context:', ctx)

    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: this.labelsValue,
        datasets: [
          {
            label: 'Present',
            data: this.presentValue,
            backgroundColor: 'rgb(16, 185, 129)', // emerald-500
            borderColor: 'rgb(5, 150, 105)', // emerald-600
            borderWidth: 1
          },
          {
            label: 'Late',
            data: this.lateValue,
            backgroundColor: 'rgb(251, 191, 36)', // amber-400
            borderColor: 'rgb(245, 158, 11)', // amber-500
            borderWidth: 1
          },
          {
            label: 'Absent',
            data: this.absentValue,
            backgroundColor: 'rgb(239, 68, 68)', // red-500
            borderColor: 'rgb(220, 38, 38)', // red-600
            borderWidth: 1
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        aspectRatio: 2.5,
        scales: {
          x: {
            stacked: true,
            grid: {
              display: false
            }
          },
          y: {
            stacked: true,
            beginAtZero: true,
            ticks: {
              stepSize: 1
            },
            title: {
              display: true,
              text: 'Number of Team Members'
            }
          }
        },
        plugins: {
          legend: {
            display: true,
            position: 'top',
          },
          tooltip: {
            mode: 'index',
            intersect: false,
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            padding: 12,
            titleFont: {
              size: 14
            },
            bodyFont: {
              size: 13
            }
          }
        }
      }
    })
  }
}
