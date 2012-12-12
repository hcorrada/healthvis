function Healthvis()  {
    if (arguments.callee._singletonInstance ) {
        return arguments.callee._singletonInstance;
    }
    arguments.callee._singletonInstance = this;

    this.renderer = null;
    this.paramsURL = null;

    this.setParamsURL = function(url) {
        this.paramsURL = url;
    }

    this.register = function (fn) {
        this.renderer = fn;
    }

    this.visualize = function(elementId) {
        var renderer = this.renderer;

        d3.json(this.paramsURL, function(json) {
            renderer.init(elementId, json);
            renderer.visualize();
        })
    }

    this.update = function(formInput) {
        this.renderer.update(formInput);
    }
}

var healthvis = new Healthvis();

$(document).ready(function () {
    $('#covariate-form :input').change(function () {
        if ($('#covariate-form').valid()) {
            var newcov = $('#covariate-form').serializeArray();
            healthvis.update(newcov);
        } else {
            console.log('Not valid')
        }
    });
});

