var ctx = document.getElementById("myChart");

var data = {
  datasets: [
    {
      label: '# Inserción',
      borderColor: 'rgba(255, 99, 132, 1)',
      backgroundColor: 'rgba(255, 99, 132, 0.2)',
      data: inserts_data
    },
    {
      label: '# Búsqueda por Extensión',
      borderColor: 'rgba(0, 255, 0, 1)',
      backgroundColor: 'rgba(0, 255, 0, 0.2)',
      data: finds_extension_data
    },
    {
      label: '# Búsqueda por Nombre',
      borderColor: 'rgba(255, 255, 0, 1)',
      backgroundColor: 'rgba(255, 255, 0, 0.2)',
      data: finds_name_data
    },
    {
      label: '# Búsqueda por Tamaño',
      borderColor: 'rgba(153, 102, 255, 1)',
      backgroundColor: 'rgba(153, 102, 255, 0.2)',
      data: finds_size_data
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