from flaskext import wtf
from flaskext.wtf import validators
import json
import logging

class ContinuousCovariate(wtf.DecimalField):
    def __init__(self, label='', validators=None, min=0, max=1, **kwargs):
        super(ContinuousCovariate,self).__init__(label, validators, **kwargs)
        self.min = min
        self.max = max
        self.validated = True

class FactorCovariate(wtf.SelectField):
    def __init__(self, label='', validators=None, **kwargs):
        super(FactorCovariate,self).__init__(label, validators, **kwargs)
        self.validated = False

def generate_continuous_field(values):
    return ContinuousCovariate(default=values[0], min=values[0], max=values[1])

def generate_factor_field(values):
    return FactorCovariate(choices=values)

def generate_form(obj, requestargs=None):
    tmp_var_list = json.loads(obj.var_list)
    var_values = [tmp_var_list[name] for name in obj.var_names]

    class CovariateForm(wtf.Form):
        pass

    field = None
    for type,name,values in zip(obj.var_type,obj.var_names,var_values):
        form_val = requestargs.get(name)
        if type == 'continuous':
            form_val = float(form_val) if form_val is not None else None
            default = (values[0] + values[1])/2.0 if form_val is None or form_val<values[0] or form_val>values[1] else form_val
            field = ContinuousCovariate(default=default, min=values[0], max=values[1])
        elif type == 'factor':
            default = values[0] if form_val is None or form_val not in values else form_val
            field = FactorCovariate(choices=zip(values,values),default=default)

        setattr(CovariateForm, name, field)

    form = CovariateForm()
    return form

