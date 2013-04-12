function Healthvis(elementId, embedIds)  {
    if (arguments.callee._singletonInstance ) {
        return arguments.callee._singletonInstance;
    }
    arguments.callee._singletonInstance = this;

    this.elementId = elementId;
    this.embedIds = embedIds;

    this.renderer = null;
    this.paramsURL = null;

    this.setParamsURL = function(url) {
        this.paramsURL = url;
    };

    this.register = function (fn) {
        this.renderer = fn;
    };

    this.visualize = function() {
        var renderer = this.renderer,
            elementId = this.elementId;

        d3.json(this.paramsURL, function(json) {
            renderer.init(elementId, json);
            renderer.visualize();
        })
    };

    this.update = function(formInput) {
        this.renderer.update(formInput);
    };

    this.getDimensions = function(inputWidth, inputHeight) {
        var height = inputHeight,
            width = inputWidth;

        if (embedIds) {
            var totalHeight = $(window).height();

            height = totalHeight - $(embedIds.header).height() - $(embedIds.footer).height();
            width = $(elementId).width();


            height = (height > 0 && height < inputHeight) ? height : inputHeight;
            width = (width > 0 && width < inputWidth) ? width : inputWidth;
        }

        return {width: width, height: height};
    };
}

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

