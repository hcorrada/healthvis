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

def generate_form(obj):
    tmp_var_list = json.loads(obj.var_list)
    var_values = [tmp_var_list[name] for name in obj.var_names]

    class CovariateForm(wtf.Form):
        pass

    field = None
    for type,name,values in zip(obj.var_type,obj.var_names,var_values):
        if type == 'continuous':
            field = ContinuousCovariate(default=values[0], min=values[0], max=values[1])
        elif type == 'factor':
            field = FactorCovariate(choices=zip(values,values),default=values[0])

        setattr(CovariateForm, name, field)

    form = CovariateForm()
    return form

