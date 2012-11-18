from flaskext import wtf
from flaskext.wtf import validators
import json
import logging

class ContinuousCovariate(wtf.DecimalField):
    def __init__(self, label='', validators=None, min=0, max=1, **kwargs):
        super(ContinuousCovariate,self).__init__(label, validators, **kwargs)
        self.min = min
        self.max = max

class FactorCovariate(wtf.SelectField):
    pass

def generate_continuous_field(values):
    return ContinuousCovariate(default=values[0], min=values[0], max=values[1])

def generate_factor_field(values):
    return FactorCovariate(choices=values)

def generate_form(obj):
    var_list = json.loads(obj.var_list)
    var_names = var_list.keys()
    var_values = var_list.values()

    field_names = []

    class CovariateForm(wtf.Form):
        pass

    field = None
    for type,name,values in zip(obj.var_type,var_names,var_values):
        if type == 'continuous':
            field = ContinuousCovariate(default=values[0], min=values[0], max=values[1])
        elif type == 'factor':
            field = FactorCovariate(values)

        setattr(CovariateForm, name, field)
        field_names.append(name)

    form = CovariateForm()
    logging.debug(str(form))
    logging.debug(str(field_names))
    return form, field_names

