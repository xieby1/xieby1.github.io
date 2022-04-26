function after_load_csv(csv) {
    let row_labels = csv.data[0];
    let num_labels = row_labels.length/2-1;
    console.log(num_labels);
    let _labels = [];
    for (let i=2; i<row_labels.length; i+=2)
    {
        _labels.push(row_labels[i]);
    }
    console.log(_labels);
    console.log(csv.data.length);
    for (let i=1; i<csv.data.length-1; i++)
    {
        let _name = csv.data[i][0];
        let _data1 = [];
        let _data2 = [];
        for (let j=2; j<row_labels.length; j+=2)
        {
            _data1.push(csv.data[i][j]);
            _data2.push(csv.data[i][j+1]);
        }
        console.log(_data1);
        console.log(_data2);
        let _color = csv.data[i][1];
        let _r = parseInt(_color.substring(0,2), 16);
        let _g = parseInt(_color.substring(2,4), 16);
        let _b = parseInt(_color.substring(4,6), 16);
        let _rgba = "rgba("+_r+","+_g+","+_b+",0.3)";
        let _rgb = "rgba("+_r+","+_g+","+_b+")";
        console.log(_color);
        console.log(_rgba);
        console.log(_rgb);
        let data = {
            labels: _labels,
            datasets: [{
                data: _data1,
                fill: true,
                backgroundColor: _rgba,
                borderColor: _rgb,
                pointBackgroundColor: _rgb,
                pointBorderColor: '#fff',
                pointHoverBackgroundColor: '#fff',
                pointHoverBorderColor: _rgb,
            }, {
                data: _data2,
                fill: true,
                backgroundColor: _rgba,
                // borderColor: _rgb,
                pointBackgroundColor: _rgba,
                pointBorderColor: '#fff',
                pointHoverBackgroundColor: '#fff',
                pointHoverBorderColor: _rgb,
            }]
        };
        let config = {
            type: 'radar',
            data: data,
            options: {
                elements: {
                    line: {
                        borderWidth: 3
                    },
                },
                plugins: {
                    legend: {
                        display: false,
                    },
                    title: {
                        text: _name,
                        display: true,
                        padding: 0,
                        position: "bottom",
                    },
                },
                scales: {
                    r: {
                        min: 0,
                        max: 10,
                    },
                },
            },
        };
        let _charts = document.getElementById("charts");
        let _div = document.createElement("div");
        let _canvas = document.createElement("canvas");
        _charts.appendChild(_div);
        _div.appendChild(_canvas);
        let _chart = new Chart(
          _canvas,
          config
        );
    }
};

Papa.parse("openEcoSys.csv", {
    download: true,
    complete: after_load_csv
});
