var ctx = document.getElementById("myChart");

var data = {
  datasets: [
    {
      label: '# Tiempo de respuesta en la inserción',
      borderColor: 'rgba(255, 99, 132, 1)',
      backgroundColor: 'rgba(255, 99, 132, 0.2)',
      data: inser_data
    },
    {
      label: '# Tiempo de respuesta en la búsqueda',
      borderColor: 'rgba(153, 102, 255, 1)',
      backgroundColor: 'rgba(153, 102, 255, 0.2)',
      data: find_data
    }
  ]
};
var chartInstanceDifferentHoverMode = new Chart(ctx, {
  type: 'line',
  data: data,
  options: {
    scales: {
      xAxes: [{
        scaleLabel: {
          display: true,
          labelString: 'MB'
        },
        type: 'linear',
        position: 'bottom'
      }],
      yAxes: [{
        scaleLabel: {
          display: true,
          labelString: 'Milisegundos'
        }
      }]
    }
  }
});